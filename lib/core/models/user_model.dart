import '../providers/role_provider.dart';

/// User Model - Stores user account information with multiple roles
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final List<UserRole> registeredRoles; // All roles this user has registered
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.registeredRoles,
    required this.createdAt,
    this.lastLoginAt,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    List<UserRole>? registeredRoles,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      registeredRoles: registeredRoles ?? this.registeredRoles,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  /// Check if user has a specific role registered
  bool hasRole(UserRole role) {
    return registeredRoles.contains(role);
  }

  /// Add a role to registered roles (if not already present)
  UserModel addRole(UserRole role) {
    if (registeredRoles.contains(role)) {
      return this; // Role already exists
    }
    return copyWith(registeredRoles: [...registeredRoles, role]);
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'registeredRoles': registeredRoles.map((r) => r.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      registeredRoles: (json['registeredRoles'] as List<dynamic>)
          .map(
            (r) => UserRole.values.firstWhere(
              (role) => role.name == r,
              orElse: () => UserRole.patient,
            ),
          )
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }
}
