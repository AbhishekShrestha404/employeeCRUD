import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  late final Box<Employee> box;

  @override
  void initState() {
    super.initState();

    // Open Hive box
    box = Hive.box<Employee>('employeesBox');

    // Load cached employees immediately
    employees = box.values.toList();
    isLoading = false;

    // Fetch the single employee from API in background
    loadEmployeeFromAPI();
  }

  Future<void> loadEmployeeFromAPI() async {
    setState(() => isLoading = true);

    try {
      final service = EmployeeServices();
      final employee = await service
          .fetchAndSaveEmployees(); // returns single Employee?

      if (employee != null) {
        // Check if this employee already exists in the local list
        final existsIndex = employees.indexWhere(
          (e) => e.userId == employee.userId,
        );

        setState(() {
          if (existsIndex == -1) {
            employees.add(employee);
          } else {
            employees[existsIndex] = employee;
          }
        });
      }
    } catch (_) {
      debugPrint('API failed, using local Hive data');
      setState(() {
        employees = box.values.toList();
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // EDIT
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final updatedEmployee =
                                await Navigator.push<Employee>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EmployeeFormScreen(employee: emp),
                                  ),
                                );

                            if (updatedEmployee != null) {
                              setState(() {
                                employees[index] = updatedEmployee;
                                box.putAt(index, updatedEmployee);
                              });
                            }
                          },
                        ),
                        // DELETE
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              employees.removeAt(index);
                              box.deleteAt(index);
                            });
                          },
                        ),
                      ],
                    ),
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
              box.add(newEmployee); // save in Hive for offline
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
