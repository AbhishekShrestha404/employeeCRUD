import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/screens/auth_screen.dart';
import 'package:employee_dashboard/screens/employee_list_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  final Employee employee;

  const DashboardScreen({super.key, required this.employee});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple[300]),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Employee Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.employee.name,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Employees'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeListScreen()),
                );
              },
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context); // closes drawer
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => AuthScreen()),
                    (route) => false, // remove every screen and redirect to authScreen
                  ); 
                },
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: Text(
          'Welcome, ${widget.employee.name}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
