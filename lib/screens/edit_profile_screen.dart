import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:employee_dashboard/models/user_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  const EditProfileScreen({super.key, required this.userProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Box<UserProfile> userBox;
  UserProfile? user;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<UserProfile>('userProfileBox');

    if (userBox.isNotEmpty) {
      user = userBox.values.first;

      fullNameController.text = user!.fullName;
      designationController.text = user!.designation;
      emailController.text = user!.emailAddress;
      contactController.text = user!.contactNumber;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    designationController.dispose();
    emailController.dispose();
    contactController.dispose();
    super.dispose();
  }

  void saveProfile() async {
    if (user == null) return;

    final updatedUser = UserProfile(
      userId: user!.userId,
      userName: user!.userName,
      fullName: fullNameController.text.trim(),
      designation: designationController.text.trim(),
      emailAddress: emailController.text.trim(),
      contactNumber: contactController.text.trim(),
      defaultPradesh: user!.defaultPradesh,
      defaultWork: user!.defaultWork,
      workOnHoliday: user!.workOnHoliday,
      overtime: user!.overtime,
      unreadNotificationCount: user!.unreadNotificationCount,
      leavesTaken: user!.leavesTaken,
      leaveNotLiable: user!.leaveNotLiable,
      leaveTransferred: user!.leaveTransferred,
      leaveBalance: user!.leaveBalance,
      attendanceHistory: user!.attendanceHistory,
      workingArea: user!.workingArea,
    );

    await userBox.clear();
    await userBox.add(updatedUser);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: designationController,
              decoration: const InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                child: const Text(
                  'Save Changes',
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
