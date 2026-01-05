import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import 'package:employee_dashboard/utils/api_config.dart';

class AuthService {
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final String tokenFromCompany = decoded['token'];
      await TokenStorage.saveToken(tokenFromCompany);
      return true;
    } else {
      return false;
    }
  }
}
