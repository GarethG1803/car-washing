import 'package:flutter/foundation.dart';

enum UserRole { customer, washer, admin }

@immutable
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final UserRole role;
  final DateTime createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          avatarUrl == other.avatarUrl &&
          role == other.role &&
          createdAt == other.createdAt &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        email,
        phone,
        avatarUrl,
        role,
        createdAt,
        isActive,
      );

  @override
  String toString() =>
      'User(id: $id, name: $name, email: $email, phone: $phone, '
      'avatarUrl: $avatarUrl, role: $role, createdAt: $createdAt, '
      'isActive: $isActive)';

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole parsedRole = UserRole.customer;
    if (json['role'] == 'employee') {
      parsedRole = UserRole.washer;
    } else if (json['role'] == 'admin') {
      parsedRole = UserRole.admin;
    }

    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      role: parsedRole,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}
