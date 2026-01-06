import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/utils/token_storage.dart';
import 'package:employee_dashboard/utils/api_config.dart';

class EmployeeServices {
  final Box<Employee> box = Hive.box<Employee>('employeesBox');

  /// Fetch single employee from API and save to Hive
  Future<Employee?> fetchAndSaveEmployees() async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token not found");

      final response = await http.get(
        Uri.parse(ApiConfig.get_user),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final employee = Employee.fromJson(data);

        // Clear previous Hive data and save the latest employee
        await box.clear();
        await box.add(employee);

        return employee;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token may have expired');
      } else {
        throw Exception('API Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Fetch failed: $e');

      // Fallback: return cached employee if available
      if (box.isNotEmpty) return box.getAt(0);

      // Nothing to return
      return null;
    }
  }

  /// Add a new employee to Hive
  Future<void> addEmployee(Employee employee) async {
    await box.add(employee);
  }

  /// Update an employee in Hive by index
  Future<void> updateEmployee(int index, Employee employee) async {
    await box.putAt(index, employee);
  }

  /// Delete an employee from Hive by index
  Future<void> deleteEmployee(int index) async {
    await box.deleteAt(index);
  }

  /// Optional: Get cached employee (first entry)
  Employee? getCachedEmployee() {
    if (box.isNotEmpty) return box.getAt(0);
    return null;
  }
}
