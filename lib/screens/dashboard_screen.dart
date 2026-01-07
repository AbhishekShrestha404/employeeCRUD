import 'package:employee_dashboard/models/user_profile.dart';
import 'package:employee_dashboard/screens/auth_screen.dart';
import 'package:employee_dashboard/screens/edit_profile_screen.dart';
import 'package:employee_dashboard/screens/setting_screen.dart';
import '../utils/token_storage.dart';

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Box<UserProfile> userBox;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserProfile>('userProfileBox');
  }

  UserProfile? get loggedInUser =>
      userBox.isNotEmpty ? userBox.values.first : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),

      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange[700]),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      loggedInUser?.fullName ?? 'WELCOME',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      loggedInUser?.emailAddress ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Information'),
              onTap: () {
                if (loggedInUser == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EditProfileScreen(userProfile: loggedInUser!),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingScreen()),
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

                  await Hive.box<UserProfile>('userProfileBox').clear();
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
