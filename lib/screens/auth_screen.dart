import 'package:employee_dashboard/screens/dashboard_screen.dart';
import 'package:employee_dashboard/services/auth_service.dart';
import 'package:employee_dashboard/services/employee_services.dart';
import 'package:employee_dashboard/models/employee.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final Employee? employee;
  const AuthScreen({super.key, this.employee});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? usernameError;
  String? passwordError;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool validateLogin() {
    setState(() {
      usernameError = usernameController.text.trim().isEmpty
          ? 'Username must not be empty'
          : null;
      passwordError = passwordController.text.trim().isEmpty
          ? 'Password must not be empty'
          : null;
    });
    return usernameError == null && passwordError == null;
  }

  Future<void> handleLogin() async {
    if (!validateLogin()) return;

    setState(() => isLoading = true);

    try {
      final authService = AuthService();
      final loginSuccess = await authService.login(
        usernameController.text.trim(),
        passwordController.text.trim(),
      );

      if (!loginSuccess) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
        return;
      }

      // Fetch employees from company API and save to Hive
      final employeeService = EmployeeServices();
      final employees = await employeeService.fetchAndSaveEmployees();

      setState(() => isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 150),
              const Text(
                "Welcome back",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Login to continue',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: const OutlineInputBorder(),
                  errorText: usernameError,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  errorText: passwordError,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: isLoading ? null : handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('LOGIN', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
