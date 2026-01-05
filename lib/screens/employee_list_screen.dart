import 'package:flutter/material.dart';
import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/services/employee_services.dart';
import 'employee_form_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> employees = [];
  bool isLoading = true;
  final EmployeeServices service = EmployeeServices();

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    setState(() => isLoading = true);

    try {
      final result = await service.fetchAndSaveEmployees();
      setState(() {
        employees = result; // <-- always use API returned list
      });
    } catch (_) {
      setState(() {
        employees = service.box.values.toList(); // fallback offline
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : employees.isEmpty
          ? const Center(child: Text('No employees found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final emp = employees[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      emp.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(emp.emailAddress),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEmployee = await Navigator.push<Employee>(
            context,
            MaterialPageRoute(builder: (_) => const EmployeeFormScreen()),
          );
          if (newEmployee != null) {
            setState(() {
              employees.add(newEmployee);
              service.box.add(newEmployee);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
