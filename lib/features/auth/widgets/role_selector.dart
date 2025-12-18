import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/widgets/bento_card.dart';
import '../../../core/providers/role_provider.dart';

class RoleSelector extends StatelessWidget {
  final UserRole? selectedRole;
  final Function(UserRole) onRoleSelected;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleCard(
          role: UserRole.patient,
          title: 'Patient',
          icon: Icons.person,
          isSelected: selectedRole == UserRole.patient,
          onTap: () => onRoleSelected(UserRole.patient),
        ),
        SizedBox(height: 12.h),
        RoleCard(
          role: UserRole.manager,
          title: 'Manager',
          icon: Icons.people,
          isSelected: selectedRole == UserRole.manager,
          onTap: () => onRoleSelected(UserRole.manager),
        ),
        SizedBox(height: 12.h),
        RoleCard(
          role: UserRole.caregiver,
          title: 'Caregiver',
          icon: Icons.medical_services,
          isSelected: selectedRole == UserRole.caregiver,
          onTap: () => onRoleSelected(UserRole.caregiver),
        ),
      ],
    );
  }
}

class RoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.role,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      onTap: onTap,
      padding: EdgeInsets.all(20.w),
      backgroundColor: isSelected
          ? CareSyncDesignSystem.primaryTeal.withAlpha((0.1 * 255).round())
          : Colors.white.withAlpha((0.9 * 255).round()),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? CareSyncDesignSystem.primaryTeal
                  : CareSyncDesignSystem.primaryTeal.withAlpha(
                      (0.1 * 255).round(),
                    ),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? CareSyncDesignSystem.surfaceWhite
                  : CareSyncDesignSystem.primaryTeal,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: CareSyncDesignSystem.textPrimary,
              ),
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
    );
  }
}
