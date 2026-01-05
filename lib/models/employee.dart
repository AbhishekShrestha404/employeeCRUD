import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String designation;

  @HiveField(3)
  final String emailAddress;

  Employee({
    required this.userId,
    required this.userName,
    required this.designation,
    required this.emailAddress,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      userId: json['userId'],
      userName: json['userName'],
      designation: json['designation'],
      emailAddress: json['emailAddress'],
    );
  }
}
