import 'package:flutter/material.dart';
import 'package:employee_dashboard/models/employee.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  String? nameError;
  String? roleError;

  bool validate() {
    setState(() {
      nameError = nameController.text.trim().isEmpty
          ? "Name field cannot be empty."
          : null;

      roleError = roleController.text.trim().isEmpty
          ? "Designation field cannot be empty."
          : null;
    });

    return nameError == null && roleError == null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      nameController.text = widget.employee!.name;
      roleController.text = widget.employee!.role;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? "Add Employee" : "Edit Employee"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Employee Name',
                errorText: nameError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: roleController,
              decoration: InputDecoration(
                labelText: 'Designation',
                errorText: roleError,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!validate()) return;

                  final updatedEmployee = Employee(
                    id:
                        widget.employee?.id ??
                        DateTime.now().microsecondsSinceEpoch,
                    name: nameController.text.trim(),
                    role: roleController.text.trim(),
                    email:
                        widget.employee?.email ??
                        '${nameController.text.trim().toLowerCase()}@company.com',
                  );

                  Navigator.pop(context, updatedEmployee);
                 
                },
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
