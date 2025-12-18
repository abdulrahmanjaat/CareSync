import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/widgets/responsive_icon.dart';
import '../medication/medication_entry_form.dart';
import 'widgets/timeline_widget.dart';
import 'widgets/vitals_bento_box.dart';
import 'widgets/role_switcher.dart';
import 'presentation/widgets/hello_header.dart';
import 'presentation/widgets/adherence_ring.dart';
import 'presentation/widgets/smart_action_card.dart';
import 'presentation/widgets/wellness_bento_strip.dart';
import 'presentation/widgets/safety_slider.dart';
import 'presentation/widgets/notification_center.dart';
import 'presentation/widgets/patient_caregiver_management.dart';
import 'presentation/widgets/quick_actions_grid.dart';
import '../notifications/notification_list_screen.dart';

class PatientDashboard extends ConsumerWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Role Switcher
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: const HelloHeader(userName: 'Patient')),
                        SizedBox(width: 12.w),
                        const RoleSwitcher(),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .slideY(begin: -0.2, end: 0, duration: 300.ms),
                SizedBox(height: 24.h),
                // Bento Grid Layout
                Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Adherence Ring (2x2)
                        Expanded(flex: 2, child: const AdherenceRing()),
                        SizedBox(width: 12.w),
                        // Right Column - Smart Action & Quick Actions
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              const SmartActionCard(),
                              SizedBox(height: 12.h),
                              BentoCard(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MedicationEntryForm(),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  children: [
                                    ResponsiveIcon(
                                      icon: Icons.medication,
                                      size: 28,
                                      color: CareSyncDesignSystem.primaryTeal,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Add Med',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: CareSyncDesignSystem.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 100.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      duration: 300.ms,
                      delay: 100.ms,
                    ),
                SizedBox(height: 16.h),
                // Timeline Widget
                const TimelineWidget()
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 200.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      duration: 300.ms,
                      delay: 200.ms,
                    ),
                SizedBox(height: 16.h),
                // Wellness Bento Strip
                const WellnessBentoStrip(),
                SizedBox(height: 16.h),
                // Vitals Bento Box
                const VitalsBentoBox()
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      duration: 300.ms,
                      delay: 300.ms,
                    ),
                SizedBox(height: 16.h),
                // Safety Slider (SOS)
                const SafetySlider(),
                SizedBox(height: 24.h),
                // Notifications
                const NotificationCenter(),
                SizedBox(height: 24.h),
                // Caregiver Management
                const PatientCaregiverManagement(),
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
              _NavItem(icon: Icons.calendar_today, label: 'Schedule'),
              _NavItem(icon: Icons.chat_bubble_outline, label: 'Messages'),
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
