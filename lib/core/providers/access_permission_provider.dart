import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Permission Level
enum PermissionLevel {
  viewOnly, // Can only view data
  monitoringOnly, // Can view and monitor
  medicationOnly, // Can manage medications
  vitalsOnly, // Can enter vitals
  fullAccess, // Full access to all features
}

/// Access Permission Model
class AccessPermission {
  final String id;
  final String caregiverId;
  final String patientId;
  final PermissionLevel level;
  final DateTime grantedAt;
  final String grantedBy; // User ID who granted the permission

  AccessPermission({
    required this.id,
    required this.caregiverId,
    required this.patientId,
    required this.level,
    required this.grantedAt,
    required this.grantedBy,
  });

  AccessPermission copyWith({
    String? id,
    String? caregiverId,
    String? patientId,
    PermissionLevel? level,
    DateTime? grantedAt,
    String? grantedBy,
  }) {
    return AccessPermission(
      id: id ?? this.id,
      caregiverId: caregiverId ?? this.caregiverId,
      patientId: patientId ?? this.patientId,
      level: level ?? this.level,
      grantedAt: grantedAt ?? this.grantedAt,
      grantedBy: grantedBy ?? this.grantedBy,
    );
  }
}

/// Access Permission State
class AccessPermissionState {
  final List<AccessPermission> permissions;

  AccessPermissionState({this.permissions = const []});

  AccessPermissionState copyWith({List<AccessPermission>? permissions}) {
    return AccessPermissionState(
      permissions: permissions ?? this.permissions,
    );
  }

  /// Get permission for caregiver-patient pair
  PermissionLevel? getPermission(String caregiverId, String patientId) {
    try {
      final permission = permissions.firstWhere(
        (p) => p.caregiverId == caregiverId && p.patientId == patientId,
      );
      return permission.level;
    } catch (e) {
      return null;
    }
  }
}

/// Access Permission Notifier
class AccessPermissionNotifier extends StateNotifier<AccessPermissionState> {
  AccessPermissionNotifier() : super(AccessPermissionState());

  void grantPermission({
    required String caregiverId,
    required String patientId,
    required PermissionLevel level,
    required String grantedBy,
  }) {
    // Remove existing permission if any
    final updatedPermissions = state.permissions
        .where((p) =>
            !(p.caregiverId == caregiverId && p.patientId == patientId))
        .toList();

    // Add new permission
    final permission = AccessPermission(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      caregiverId: caregiverId,
      patientId: patientId,
      level: level,
      grantedAt: DateTime.now(),
      grantedBy: grantedBy,
    );

    state = state.copyWith(
      permissions: [...updatedPermissions, permission],
    );
  }

  void revokePermission(String caregiverId, String patientId) {
    state = state.copyWith(
      permissions: state.permissions
          .where((p) =>
              !(p.caregiverId == caregiverId && p.patientId == patientId))
          .toList(),
    );
  }

  void updatePermissionLevel({
    required String caregiverId,
    required String patientId,
    required PermissionLevel newLevel,
  }) {
    final updatedPermissions = state.permissions.map((p) {
      if (p.caregiverId == caregiverId && p.patientId == patientId) {
        return p.copyWith(level: newLevel);
      }
      return p;
    }).toList();

    state = state.copyWith(permissions: updatedPermissions);
  }
}

/// Access Permission Provider
final accessPermissionProvider =
    StateNotifierProvider<AccessPermissionNotifier, AccessPermissionState>(
        (ref) {
  return AccessPermissionNotifier();
});

