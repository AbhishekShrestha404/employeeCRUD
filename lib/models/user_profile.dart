import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String userName;

  @HiveField(3)
  final String designation;

  @HiveField(4)
  final String emailAddress;

  @HiveField(5)
  final String contactNumber;

  @HiveField(6)
  final String defaultPradesh;

  @HiveField(7)
  final String defaultWork;

  // ===== FLAGS / META =====
  @HiveField(8)
  final String workOnHoliday;

  @HiveField(9)
  final String overtime;

  @HiveField(10)
  final int unreadNotificationCount;

  // ===== NESTED OBJECTS (STORED AS MAPS) =====
  @HiveField(11)
  final Map<String, dynamic> leavesTaken;

  @HiveField(12)
  final Map<String, dynamic> leaveNotLiable;

  @HiveField(13)
  final Map<String, dynamic> leaveTransferred;

  @HiveField(14)
  final Map<String, dynamic> leaveBalance;

  @HiveField(15)
  final Map<String, dynamic> attendanceHistory;

  @HiveField(16)
  final Map<String, dynamic> workingArea;

  UserProfile({
    required this.userId,
    required this.fullName,
    required this.userName,
    required this.designation,
    required this.emailAddress,
    required this.contactNumber,
    required this.defaultPradesh,
    required this.defaultWork,
    required this.workOnHoliday,
    required this.overtime,
    required this.unreadNotificationCount,
    required this.leavesTaken,
    required this.leaveNotLiable,
    required this.leaveTransferred,
    required this.leaveBalance,
    required this.attendanceHistory,
    required this.workingArea,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      userName: json['userName'] ?? '',
      designation: json['designation'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      defaultPradesh: json['defaultPradesh'] ?? '',
      defaultWork: json['defaultWork'] ?? '',
      workOnHoliday: json['work_on_holiday'] ?? '0',
      overtime: json['overtime'] ?? '0',
      unreadNotificationCount: json['unread_notification_count'] ?? 0,
      leavesTaken: json['leaves_taken'] ?? {},
      leaveNotLiable: json['leave_not_liable'] ?? {},
      leaveTransferred: json['leave_transferred'] ?? {},
      leaveBalance: json['leave_balance'] ?? {},
      attendanceHistory: json['attendance_history'] ?? {},
      workingArea: json['working_area'] ?? {},
    );
  }
}
