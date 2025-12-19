import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// User Roles in CareSync
enum UserRole { patient, manager, caregiver }

/// User Role State - Multiple roles per account, one active at a time
class UserRoleState {
  final List<UserRole> registeredRoles; // All roles user has registered
  final UserRole? activeRole; // Currently active/selected role

  UserRoleState({this.registeredRoles = const [], this.activeRole});

  UserRoleState copyWith({
    List<UserRole>? registeredRoles,
    UserRole? activeRole,
  }) {
    return UserRoleState(
      registeredRoles: registeredRoles ?? this.registeredRoles,
      activeRole: activeRole ?? this.activeRole,
    );
  }

  bool get hasRole => activeRole != null;
  bool get hasMultipleRoles => registeredRoles.length > 1;
  bool get hasSingleRole => registeredRoles.length == 1;
}

/// Role Provider - Manages multiple roles per account with persistence
class RoleNotifier extends StateNotifier<UserRoleState> {
  static const String _registeredRolesKey = 'user_registered_roles';
  static const String _activeRoleKey = 'user_active_role';

  RoleNotifier() : super(UserRoleState()) {
    _loadRoles();
  }

  /// Load roles from SharedPreferences
  Future<void> _loadRoles() async {
    final prefs = await SharedPreferences.getInstance();

    // Load registered roles
    final rolesJson = prefs.getString(_registeredRolesKey);
    List<UserRole> registeredRoles = [];
    if (rolesJson != null) {
      final rolesList = jsonDecode(rolesJson) as List<dynamic>;
      registeredRoles = rolesList
          .map(
            (r) => UserRole.values.firstWhere(
              (role) => role.name == r,
              orElse: () => UserRole.patient,
            ),
          )
          .toList();
    }

    // Load active role
    final activeRoleString = prefs.getString(_activeRoleKey);
    UserRole? activeRole;
    if (activeRoleString != null) {
      activeRole = UserRole.values.firstWhere(
        (r) => r.name == activeRoleString,
        orElse: () => UserRole.patient,
      );
    }

    state = UserRoleState(
      registeredRoles: registeredRoles,
      activeRole: activeRole,
    );
  }

  /// Save registered roles to SharedPreferences
  Future<void> _saveRegisteredRoles(List<UserRole> roles) async {
    final prefs = await SharedPreferences.getInstance();
    final rolesJson = jsonEncode(roles.map((r) => r.name).toList());
    await prefs.setString(_registeredRolesKey, rolesJson);
  }

  /// Save active role to SharedPreferences
  Future<void> _saveActiveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeRoleKey, role.name);
  }

  /// Register a new role for the user (called during signup)
  Future<void> registerRole(UserRole role) async {
    List<UserRole> updatedRoles = List.from(state.registeredRoles);

    // Add role if not already registered
    if (!updatedRoles.contains(role)) {
      updatedRoles.add(role);
      await _saveRegisteredRoles(updatedRoles);
    }

    // Set as active role if it's the first role
    if (state.activeRole == null) {
      await _saveActiveRole(role);
      state = UserRoleState(registeredRoles: updatedRoles, activeRole: role);
    } else {
      state = UserRoleState(
        registeredRoles: updatedRoles,
        activeRole: state.activeRole,
      );
    }
  }

  /// Set active role (for switching)
  Future<void> setActiveRole(UserRole role) async {
    // Verify role is registered
    if (!state.registeredRoles.contains(role)) {
      throw Exception('Role not registered for this account');
    }

    await _saveActiveRole(role);
    state = UserRoleState(
      registeredRoles: state.registeredRoles,
      activeRole: role,
    );
  }

  /// Clear active role (for switching)
  Future<void> clearActiveRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeRoleKey);
    state = UserRoleState(
      registeredRoles: state.registeredRoles,
      activeRole: null,
    );
  }

  /// Get registered roles for current user
  List<UserRole> get registeredRoles => state.registeredRoles;

  /// Get active role
  UserRole? get activeRole => state.activeRole;

  /// Check if user has a role
  bool get hasRole => state.hasRole;

  /// Check if user has multiple roles
  bool get hasMultipleRoles => state.hasMultipleRoles;
}

/// Provider for role management
final roleProvider = StateNotifierProvider<RoleNotifier, UserRoleState>((ref) {
  return RoleNotifier();
});
