import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/providers/role_provider.dart';

/// Role Switcher - Allows users to switch between their roles
class RoleSwitcher extends ConsumerWidget {
  const RoleSwitcher({super.key});

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.manager:
        return 'Manager';
      case UserRole.caregiver:
        return 'Caregiver';
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return Icons.person;
      case UserRole.manager:
        return Icons.people;
      case UserRole.caregiver:
        return Icons.medical_services;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleState = ref.watch(roleProvider);
    
    // Don't show if user has only one role
    if (roleState.roles.length <= 1) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: CareSyncDesignSystem.primaryTeal.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: CareSyncDesignSystem.primaryTeal.withAlpha((0.3 * 255).round()),
          width: 1.w,
        ),
      ),
      child: PopupMenuButton<UserRole>(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getRoleIcon(roleState.activeRole!),
              size: 18.sp,
              color: CareSyncDesignSystem.primaryTeal,
            ),
            SizedBox(width: 6.w),
            Text(
              _getRoleLabel(roleState.activeRole!),
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: CareSyncDesignSystem.primaryTeal,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.arrow_drop_down,
              size: 18.sp,
              color: CareSyncDesignSystem.primaryTeal,
            ),
          ],
        ),
        onSelected: (role) {
          ref.read(roleProvider.notifier).setActiveRole(role);
        },
        itemBuilder: (context) {
          return roleState.roles.map((role) {
            final isActive = role == roleState.activeRole;
            return PopupMenuItem<UserRole>(
              value: role,
              child: Row(
                children: [
                  Icon(
                    _getRoleIcon(role),
                    size: 20.sp,
                    color: isActive
                        ? CareSyncDesignSystem.primaryTeal
                        : CareSyncDesignSystem.textSecondary,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    _getRoleLabel(role),
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      color: isActive
                          ? CareSyncDesignSystem.primaryTeal
                          : CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  if (isActive) ...[
                    Spacer(),
                    Icon(
                      Icons.check,
                      size: 18.sp,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                  ],
                ],
              ),
            );
          }).toList();
        },
      ),
    );
  }
}

