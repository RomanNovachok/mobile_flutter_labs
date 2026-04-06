class UserModel {
  const UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.id,
  });

  final String? id;
  final String fullName;
  final String email;
  final String password;
  final String role;

  Map<String, String> toMap() {
    return {
      'id': id ?? '',
      'fullName': fullName,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, String> map) {
    return UserModel(
      id: map['id'],
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
    );
  }

  factory UserModel.fromDynamicMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toString(),
      fullName: map['fullName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      password: map['password']?.toString() ?? '',
      role: map['role']?.toString() ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
