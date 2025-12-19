import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/role_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../auth/login_screen.dart';
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
    final authState = ref.watch(authProvider);

    // If not authenticated, redirect to login
    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If no active role is set, check registered roles
    if (!roleState.hasRole) {
      // If user has only one registered role, set it as active
      if (roleState.hasSingleRole) {
        final singleRole = roleState.registeredRoles.first;
        // Set as active role
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(roleProvider.notifier).setActiveRole(singleRole);
        });
        // Show loading or the dashboard will rebuild
        return const Center(child: CircularProgressIndicator());
      }
      // If user has multiple roles or no roles, show role selection
      return const RoleSelectionScreen();
    }

    // Get active role
    final activeRole = roleState.activeRole!;

    // Switch based on active role
    switch (activeRole) {
      case UserRole.patient:
        return const PatientDashboard();
      case UserRole.manager:
        return const ManagerDashboard();
      case UserRole.caregiver:
        return const CaregiverDashboard();
    }
  }
}
