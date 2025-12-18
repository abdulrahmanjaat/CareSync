import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../symptoms/symptom_logging_form.dart';
import '../../../habits/habit_tracking_form.dart';
import '../../../appointments/appointment_scheduling_screen.dart';
import '../../../../core/providers/habit_provider.dart';

/// Quick Actions Grid - Quick access to logging features
class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        // First Row - 2 cards
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.medical_services,
                label: 'Log Symptom',
                color: CareSyncDesignSystem.alertRed,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SymptomLoggingForm(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.fitness_center,
                label: 'Exercise',
                color: CareSyncDesignSystem.successEmerald,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HabitTrackingForm(
                        habitType: HabitType.exercise,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Second Row - 2 cards
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.bedtime,
                label: 'Sleep',
                color: CareSyncDesignSystem.primaryTeal,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const HabitTrackingForm(habitType: HabitType.sleep),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _QuickActionCard(
                icon: Icons.calendar_today,
                label: 'Appointment',
                color: CareSyncDesignSystem.softCoral,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppointmentSchedulingScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Third Row - 1 card (centered or full width)
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                icon: Icons.restaurant,
                label: 'Meal',
                color: CareSyncDesignSystem.softCoral,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const HabitTrackingForm(habitType: HabitType.dietary),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      onTap: onTap,
      height: 140.h, // Fixed height for all cards
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withAlpha((0.7 * 255).round())],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha((0.3 * 255).round()),
                  blurRadius: 12.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: CareSyncDesignSystem.surfaceWhite,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: CareSyncDesignSystem.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
