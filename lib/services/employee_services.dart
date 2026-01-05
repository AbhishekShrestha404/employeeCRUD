import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/utils/token_storage.dart';
import 'package:employee_dashboard/utils/api_config.dart';

class EmployeeServices {
  final Box<Employee> box = Hive.box<Employee>('employeesBox');

  Future<List<Employee>> fetchAndSaveEmployees() async {
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
        final List results = data['employees'] ?? [];

        final List<Employee> employees = results.map<Employee>((json) {
          return Employee(
            userId: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
            userName: json['name'] ?? 'No Name',
            designation: json['role'] ?? 'Employee',
            emailAddress: json['email'] ?? '',
          );
        }).toList();

        await box.clear();
        await box.addAll(employees);

        return employees;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Token may have expired');
      } else {
        throw Exception('API Failed: ${response.statusCode}');
      }
    } catch (e) {
      return box.values.toList(); // return offline data if API fails
    }
  }

  Future<void> addEmployee(Employee employee) async {
    await box.add(employee);
  }

  Future<void> updateEmployee(int index, Employee employee) async {
    await box.putAt(index, employee);
  }

  Future<void> deleteEmployee(int index) async {
    await box.deleteAt(index);
  }
}
