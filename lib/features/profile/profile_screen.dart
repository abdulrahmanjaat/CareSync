import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/providers/role_provider.dart';
import '../../core/providers/auth_provider.dart';
import '../dashboard/role_selection_screen.dart';

/// Profile Screen - User profile and settings
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final roleState = ref.watch(roleProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Profile',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Profile Avatar
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CareSyncDesignSystem.primaryTeal,
                        CareSyncDesignSystem.primaryTeal.withAlpha(
                          (0.7 * 255).round(),
                        ),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50.sp,
                    color: CareSyncDesignSystem.surfaceWhite,
                  ),
                ),
                SizedBox(height: 16.h),
                // User Email
                Text(
                  authState.email ?? 'Not logged in',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                // Active Role
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: CareSyncDesignSystem.primaryTeal.withAlpha(
                      (0.1 * 255).round(),
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Active Role: ${roleState.selectedRole?.name.toUpperCase() ?? "NONE"}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Switch Role Button
                BentoCard(
                  onTap: () async {
                    // Clear current role and navigate to role selection
                    await ref.read(roleProvider.notifier).clearRole();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const RoleSelectionScreen(),
                        ),
                      );
                    }
                  },
                  padding: EdgeInsets.all(16.w),
                  backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.swap_horiz,
                        color: CareSyncDesignSystem.primaryTeal,
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Switch Role',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: CareSyncDesignSystem.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Logout Button
                BentoCard(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    );
                  },
                  padding: EdgeInsets.all(16.w),
                  backgroundColor: CareSyncDesignSystem.alertRed.withAlpha(
                    (0.1 * 255).round(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: CareSyncDesignSystem.alertRed,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: CareSyncDesignSystem.alertRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
