import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User Roles in CareSync
enum UserRole { patient, manager, caregiver }

/// User Role State - Single role per user
class UserRoleState {
  final UserRole? selectedRole; // Currently selected role

  UserRoleState({this.selectedRole});

  UserRoleState copyWith({UserRole? selectedRole}) {
    return UserRoleState(selectedRole: selectedRole ?? this.selectedRole);
  }

  bool get hasRole => selectedRole != null;
}

/// Role Provider - Manages single role per user with persistence
class RoleNotifier extends StateNotifier<UserRoleState> {
  static const String _roleKey = 'user_selected_role';
  static const String _roleSelectedKey = 'role_selected_before';

  RoleNotifier() : super(UserRoleState()) {
    _loadRole();
  }

  /// Load role from SharedPreferences
  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final roleString = prefs.getString(_roleKey);

    if (roleString != null) {
      final role = UserRole.values.firstWhere(
        (r) => r.name == roleString,
        orElse: () => UserRole.patient,
      );
      state = UserRoleState(selectedRole: role);
    }
  }

  /// Save role to SharedPreferences
  Future<void> _saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role.name);
    await prefs.setBool(_roleSelectedKey, true);
  }

  /// Set and save a single role
  Future<void> setRole(UserRole role) async {
    await _saveRole(role);
    state = UserRoleState(selectedRole: role);
  }

  /// Clear role (for switching)
  Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
    state = UserRoleState();
  }

  /// Check if role has been selected before
  Future<bool> hasRoleBeenSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_roleSelectedKey) ?? false;
  }

  /// Get current role
  UserRole? get currentRole => state.selectedRole;

  /// Check if user has a role
  bool get hasRole => state.hasRole;
}

/// Provider for role management
final roleProvider = StateNotifierProvider<RoleNotifier, UserRoleState>((ref) {
  return RoleNotifier();
});
