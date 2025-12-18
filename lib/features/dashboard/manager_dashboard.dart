import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import 'presentation/widgets/global_status_ticker.dart';
import 'presentation/widgets/advanced_patient_card.dart';
import 'presentation/widgets/quick_command_grid.dart';
import 'presentation/screens/patient_detail_screen.dart';
import 'presentation/screens/add_patient_screen.dart';
import '../../core/providers/household_provider.dart';

/// Manager Dashboard - Command Center & Trends
class ManagerDashboard extends ConsumerWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final household = ref.watch(householdProvider);
    final sortedPatients = household.sortedPatients;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Family Manager',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Command Center',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Global Status Ticker
                const GlobalStatusTicker(),
                SizedBox(height: 24.h),
                // Quick Command Grid
                const QuickCommandGrid(),
                SizedBox(height: 24.h),
                // Patient List Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Patients',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${sortedPatients.length} total',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AddPatientScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 36.w,
                            height: 36.w,
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
                              boxShadow: [
                                BoxShadow(
                                  color: CareSyncDesignSystem.primaryTeal
                                      .withAlpha((0.3 * 255).round()),
                                  blurRadius: 8.r,
                                  spreadRadius: 1.r,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: CareSyncDesignSystem.surfaceWhite,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Advanced Patient Cards (Triage Sorted)
                ...sortedPatients.map((patient) {
                  return AdvancedPatientCard(
                    patient: patient,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PatientDetailScreen(patient: patient),
                        ),
                      );
                    },
                  );
                }),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.9 * 255).round()),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 20.r,
            offset: Offset(0, -4.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home, label: 'Home', isActive: true),
              _NavItem(icon: Icons.people, label: 'Family'),
              _NavItem(icon: Icons.notifications_outlined, label: 'Alerts'),
              _NavItem(icon: Icons.person_outline, label: 'Profile'),
              _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive
              ? CareSyncDesignSystem.primaryTeal
              : CareSyncDesignSystem.textSecondary,
          size: 24.sp,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            color: isActive
                ? CareSyncDesignSystem.primaryTeal
                : CareSyncDesignSystem.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
