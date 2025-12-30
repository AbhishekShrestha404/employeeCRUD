import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:employee_dashboard/models/employee.dart';
import 'package:employee_dashboard/utils/api_config.dart';

class EmployeeServices {
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // IMPORTANT: results is a LIST
        final List results = data['results'];

        return results.map((json) {
          return Employee(
            id: json['login']['uuid'].hashCode,
            name: '${json['name']['first']} ${json['name']['last']}',
            email: json['email'],
            role: 'Employee',
          );
        }).toList();
      } else {
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('Error loading employees: $e');
      return [];
    }
  }
}
