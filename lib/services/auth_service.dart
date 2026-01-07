import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'package:employee_dashboard/models/user_profile.dart';
import '../utils/token_storage.dart';
import 'package:employee_dashboard/utils/api_config.dart';

class AuthService {
  Future<bool> login(
    String username,
    String password,
    BuildContext context,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);

      // Safely save token if present
      final tokenFromCompany = data['token'] as String?;
      if (tokenFromCompany != null) {
        await TokenStorage.saveToken(tokenFromCompany);
      }

      // Safely get message for SnackBar
      final message =
          (data['message'] as String?) ??
          (data['error_description'] as String?) ??
          'Login Failed.';

      // Show SnackBar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      // Return success only if API says success
      return data['success'] == true;
    } catch (e) {
      // Handle network or decoding errors
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong: $e')));
      return false;
    }
  }

  Future<void> fetchAndSaveUserProfile() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse(ApiConfig.get_user), //  profile endpoint
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load user profile');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    final userProfile = UserProfile.fromJson(data);

    final box = Hive.box<UserProfile>('userProfileBox');
    await box.clear(); // only one logged-in user
    await box.add(userProfile);
  }
}
