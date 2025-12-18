import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/role_provider.dart';
import 'patient_dashboard.dart';
import 'manager_dashboard.dart';
import 'caregiver_dashboard.dart';
import 'role_selection_screen.dart';

/// Dashboard Shell - Role-based dashboard switching
class DashboardShell extends ConsumerWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleState = ref.watch(roleProvider);

    // If no role is set, show role selection screen
    if (!roleState.hasRole) {
      return const RoleSelectionScreen();
    }

    // Get selected role
    final selectedRole = roleState.selectedRole!;

    // Switch based on selected role
    switch (selectedRole) {
      case UserRole.patient:
        return const PatientDashboard();
      case UserRole.manager:
        return const ManagerDashboard();
      case UserRole.caregiver:
        return const CaregiverDashboard();
    }
  }
}
