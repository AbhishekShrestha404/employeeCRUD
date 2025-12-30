class Employee {
  final int id;
  final String name;
  final String role;
  final String email;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      email: json['email'],
    );
  }
}
