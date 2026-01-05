import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/screens/auth_screen.dart';
import 'package:employee_dashboard/screens/employee_list_screen.dart';
import '../utils/token_storage.dart';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

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
                onTap: () async {
                  Navigator.pop(context); // closes drawer

                  await TokenStorage.deleteToken();

                  await Hive.box<Employee>('employeesBox').clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => AuthScreen()),
                    (route) =>
                        false, // remove every screen and redirect to authScreen
                  );
                },
              ),
            ),
          ],
        ),
      ),

      body: Center(
        child: Text(
          'Welcome to Dashboard',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
