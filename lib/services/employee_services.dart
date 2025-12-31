import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';

import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/utils/api_config.dart';

class EmployeeServices {
  final Box<Employee> box = Hive.box<Employee>('employeesBox');

  Future<List<Employee>> fetchAndSaveEmployees() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // IMPORTANT: results is a LIST
        final List results = data['results'];

        final List<Employee> employees = results.map<Employee>((json) {
          return Employee(
            id: json['login']['uuid'].hashCode,
            name: '${json['name']['first']} ${json['name']['last']}',
            email: json['email'],
            role: 'Employee',
          );
        }).toList();
        await box.clear();
        await box.addAll(employees);
        return employees;
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('Error loading employees: $e');
      return [];
    }
  }
}
