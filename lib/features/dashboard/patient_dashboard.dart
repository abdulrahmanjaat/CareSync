import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/widgets/responsive_icon.dart';
import '../medication/medication_entry_form.dart';
import '../schedule/schedule_screen.dart';
import '../messages/messages_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import 'widgets/timeline_widget.dart';
import 'widgets/vitals_bento_box.dart';
import 'presentation/widgets/hello_header.dart';
import 'presentation/widgets/adherence_ring.dart';
import 'presentation/widgets/smart_action_card.dart';
import 'presentation/widgets/wellness_bento_strip.dart';
import 'presentation/widgets/safety_slider.dart';
import 'presentation/widgets/patient_caregiver_management.dart';
import 'presentation/widgets/quick_actions_grid.dart';

class PatientDashboard extends ConsumerStatefulWidget {
  const PatientDashboard({super.key});

  @override
  ConsumerState<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends ConsumerState<PatientDashboard> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const ScheduleScreen();
      case 2:
        return const MessagesScreen();
      case 3:
        return const ProfileScreen();
      case 4:
        return const SettingsScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Role Switcher
          const HelloHeader(userName: 'Patient')
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
                                builder: (_) => const MedicationEntryForm(),
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
          // Quick Actions Grid
          const QuickActionsGrid(),
          SizedBox(height: 24.h),
          // Caregiver Management
          const PatientCaregiverManagement(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(child: _getBody()),
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const _BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

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
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isActive: selectedIndex == 0,
                onTap: () => onItemTapped(0),
              ),
              _NavItem(
                icon: Icons.calendar_today,
                label: 'Schedule',
                isActive: selectedIndex == 1,
                onTap: () => onItemTapped(1),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Messages',
                isActive: selectedIndex == 2,
                onTap: () => onItemTapped(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: selectedIndex == 3,
                onTap: () => onItemTapped(3),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: selectedIndex == 4,
                onTap: () => onItemTapped(4),
              ),
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
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
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
        ),
      ),
    );
  }
}
