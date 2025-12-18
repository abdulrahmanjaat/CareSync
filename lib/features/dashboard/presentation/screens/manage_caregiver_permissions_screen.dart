import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/caregiver_provider.dart';
import '../../../../core/providers/access_permission_provider.dart';
import '../../../../core/providers/auth_provider.dart';

/// Manage Caregiver Permissions Screen
class ManageCaregiverPermissionsScreen extends ConsumerWidget {
  final Caregiver caregiver;

  const ManageCaregiverPermissionsScreen({
    super.key,
    required this.caregiver,
  });

  String _getPermissionLabel(PermissionLevel level) {
    switch (level) {
      case PermissionLevel.viewOnly:
        return 'View Only';
      case PermissionLevel.monitoringOnly:
        return 'Monitoring Only';
      case PermissionLevel.medicationOnly:
        return 'Medication Only';
      case PermissionLevel.vitalsOnly:
        return 'Vitals Only';
      case PermissionLevel.fullAccess:
        return 'Full Access';
    }
  }

  String _getPermissionDescription(PermissionLevel level) {
    switch (level) {
      case PermissionLevel.viewOnly:
        return 'Can only view health data';
      case PermissionLevel.monitoringOnly:
        return 'Can view and monitor trends';
      case PermissionLevel.medicationOnly:
        return 'Can manage medications';
      case PermissionLevel.vitalsOnly:
        return 'Can enter vitals';
      case PermissionLevel.fullAccess:
        return 'Full access to all features';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final permissions = ref.watch(accessPermissionProvider).permissions;
    
    // Get current permission for this caregiver-patient pair
    final currentPermission = ref
        .read(accessPermissionProvider.notifier)
        .state
        .getPermission(caregiver.id, authState.userId ?? '');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage Permissions',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            caregiver.name,
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Permission Options
                ...PermissionLevel.values.map((level) {
                  final isSelected = currentPermission == level;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: GestureDetector(
                      onTap: () {
                        if (authState.userId != null) {
                          ref
                              .read(accessPermissionProvider.notifier)
                              .grantPermission(
                                caregiverId: caregiver.id,
                                patientId: authState.userId!,
                                level: level,
                                grantedBy: authState.userId!,
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Permission updated to ${_getPermissionLabel(level)}',
                              ),
                              backgroundColor: CareSyncDesignSystem.successEmerald,
                            ),
                          );
                        }
                      },
                      child: BentoCard(
                        padding: EdgeInsets.all(16.w),
                        backgroundColor: isSelected
                            ? CareSyncDesignSystem.primaryTeal.withAlpha(
                                (0.1 * 255).round(),
                              )
                            : null,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getPermissionLabel(level),
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? CareSyncDesignSystem.primaryTeal
                                          : CareSyncDesignSystem.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    _getPermissionDescription(level),
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      color: CareSyncDesignSystem.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: CareSyncDesignSystem.primaryTeal,
                                size: 24.sp,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

