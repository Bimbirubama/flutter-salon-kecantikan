class UserModel {
  final String? id;
  final String name;
  final String email;
  final String role;
  final String address;
  final String? password; // Password hanya dikirim saat register/login

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'address': address,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      address: json['address'] ?? '',
    );
  }
}