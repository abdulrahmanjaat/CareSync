import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User Roles in CareSync
enum UserRole { patient, manager, caregiver }

/// User Role State - Supports multiple roles per user
class UserRoleState {
  final List<UserRole> roles;
  final UserRole? activeRole; // Currently active role

  UserRoleState({this.roles = const [], this.activeRole});

  UserRoleState copyWith({List<UserRole>? roles, UserRole? activeRole}) {
    return UserRoleState(
      roles: roles ?? this.roles,
      activeRole: activeRole ?? this.activeRole,
    );
  }

  bool hasRole(UserRole role) => roles.contains(role);
  bool get hasAnyRole => roles.isNotEmpty;
}

/// Role Provider - Manages multiple roles per user
class RoleNotifier extends StateNotifier<UserRoleState> {
  RoleNotifier() : super(UserRoleState());

  /// Add a role to user's roles
  void addRole(UserRole role) {
    if (!state.roles.contains(role)) {
      final updatedRoles = [...state.roles, role];
      state = state.copyWith(
        roles: updatedRoles,
        activeRole: state.activeRole ?? role, // Set as active if none selected
      );
    }
  }

  /// Remove a role from user's roles
  void removeRole(UserRole role) {
    final updatedRoles = state.roles.where((r) => r != role).toList();
    UserRole? newActiveRole = state.activeRole;

    // If removing active role, switch to another if available
    if (state.activeRole == role && updatedRoles.isNotEmpty) {
      newActiveRole = updatedRoles.first;
    } else if (updatedRoles.isEmpty) {
      newActiveRole = null;
    }

    state = state.copyWith(roles: updatedRoles, activeRole: newActiveRole);
  }

  /// Set active role (must be in user's roles)
  void setActiveRole(UserRole role) {
    if (state.roles.contains(role)) {
      state = state.copyWith(activeRole: role);
    }
  }

  /// Set single role (for backward compatibility)
  void setRole(UserRole role) {
    state = UserRoleState(roles: [role], activeRole: role);
  }

  /// Clear all roles
  void clearRole() {
    state = UserRoleState();
  }

  bool get hasRole => state.hasAnyRole;
  UserRole? get currentRole => state.activeRole;
}

/// Provider for role management
final roleProvider = StateNotifierProvider<RoleNotifier, UserRoleState>((ref) {
  return RoleNotifier();
});
