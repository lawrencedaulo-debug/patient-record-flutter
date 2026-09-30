class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.tenantId,
    required this.tenantName,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.defaultAdmin() {
    return UserModel(
      id: 'admin-default',
      name: 'Clinic Administrator',
      email: 'admin@clinic.com',
      password: 'admin123',
      tenantId: 'default-clinic',
      tenantName: 'Default Clinic',
      role: 'admin',
      createdAt: DateTime.now(),
    );
  }

  final String id;
  final String name;
  final String email;
  final String password;
  final String tenantId;
  final String tenantName;
  final String role;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'tenantId': tenantId,
      'tenantName': tenantName,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      tenantId: json['tenantId'] as String,
      tenantName: json['tenantName'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
