import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/role_provider.dart';
import '../auth/widgets/role_selector.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final Set<UserRole> _selectedRoles = {};

  void _handleContinue() {
    if (_selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one role'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    // Add all selected roles
    final notifier = ref.read(roleProvider.notifier);
    for (final role in _selectedRoles) {
      notifier.addRole(role);
    }
    // Set first role as active
    notifier.setActiveRole(_selectedRoles.first);
  }

  void _toggleRole(UserRole role) {
    setState(() {
      if (_selectedRoles.contains(role)) {
        _selectedRoles.remove(role);
      } else {
        _selectedRoles.add(role);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40.h),
                // Logo
                Center(
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: CareSyncDesignSystem.primaryGradient,
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 40.sp,
                          color: CareSyncDesignSystem.surfaceWhite,
                        ),
                      ),
                    )
                    .animate()
                    .scale(begin: const Offset(0.0, 0.0), duration: 400.ms)
                    .fadeIn(duration: 300.ms),
                SizedBox(height: 32.h),
                // Title
                Text(
                      'Select Your Role',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 300.ms,
                      delay: 100.ms,
                    ),
                SizedBox(height: 8.h),
                Text(
                  'Choose your role to continue',
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                SizedBox(height: 40.h),
                // Role Selector - Multi-select
                Column(
                      children: [
                        _MultiRoleCard(
                          role: UserRole.patient,
                          title: 'Patient',
                          icon: Icons.person,
                          isSelected: _selectedRoles.contains(UserRole.patient),
                          onTap: () => _toggleRole(UserRole.patient),
                        ),
                        SizedBox(height: 12.h),
                        _MultiRoleCard(
                          role: UserRole.manager,
                          title: 'Manager',
                          icon: Icons.people,
                          isSelected: _selectedRoles.contains(UserRole.manager),
                          onTap: () => _toggleRole(UserRole.manager),
                        ),
                        SizedBox(height: 12.h),
                        _MultiRoleCard(
                          role: UserRole.caregiver,
                          title: 'Caregiver',
                          icon: Icons.medical_services,
                          isSelected: _selectedRoles.contains(
                            UserRole.caregiver,
                          ),
                          onTap: () => _toggleRole(UserRole.caregiver),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      duration: 300.ms,
                      delay: 300.ms,
                    ),
                SizedBox(height: 32.h),
                // Continue Button
                CareSyncButton(
                      text: 'Continue',
                      onPressed: _handleContinue,
                      width: double.infinity,
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 400.ms)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 300.ms,
                      delay: 400.ms,
                    ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MultiRoleCard extends StatelessWidget {
  final UserRole role;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MultiRoleCard({
    required this.role,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected
              ? CareSyncDesignSystem.primaryTeal.withAlpha((0.1 * 255).round())
              : Colors.white.withAlpha((0.9 * 255).round()),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? CareSyncDesignSystem.primaryTeal
                : CareSyncDesignSystem.textSecondary.withAlpha(
                    (0.2 * 255).round(),
                  ),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CareSyncDesignSystem.primaryTeal,
                          CareSyncDesignSystem.primaryTeal.withAlpha(
                            (0.7 * 255).round(),
                          ),
                        ],
                      )
                    : null,
                color: isSelected
                    ? null
                    : CareSyncDesignSystem.textSecondary.withAlpha(
                        (0.1 * 255).round(),
                      ),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? CareSyncDesignSystem.surfaceWhite
                    : CareSyncDesignSystem.textSecondary,
                size: 28.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? CareSyncDesignSystem.primaryTeal
                          : CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _getRoleDescription(role),
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
    );
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return 'Track your health and medications';
      case UserRole.manager:
        return 'Monitor and manage patients';
      case UserRole.caregiver:
        return 'Assist and care for patients';
    }
  }
}
