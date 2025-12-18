import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/responsive_icon.dart';
import '../../../symptoms/symptom_logging_form.dart';
import '../../../habits/habit_tracking_form.dart';
import '../../../appointments/appointment_scheduling_screen.dart';
import '../../../notifications/notification_list_screen.dart';
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
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: BentoCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SymptomLoggingForm(),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ResponsiveIcon(
                      icon: Icons.medical_services,
                      size: 32,
                      color: CareSyncDesignSystem.alertRed,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Log Symptom',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HabitTrackingForm(
                        habitType: HabitType.exercise,
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ResponsiveIcon(
                      icon: Icons.fitness_center,
                      size: 32,
                      color: CareSyncDesignSystem.successEmerald,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Exercise',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HabitTrackingForm(
                        habitType: HabitType.sleep,
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ResponsiveIcon(
                      icon: Icons.bedtime,
                      size: 32,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sleep',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppointmentSchedulingScreen(),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ResponsiveIcon(
                      icon: Icons.calendar_today,
                      size: 32,
                      color: CareSyncDesignSystem.softCoral,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Appointment',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: BentoCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HabitTrackingForm(
                        habitType: HabitType.dietary,
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    ResponsiveIcon(
                      icon: Icons.restaurant,
                      size: 32,
                      color: CareSyncDesignSystem.softCoral,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Meal',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              flex: 3,
              child: BentoCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationListScreen(),
                    ),
                  );
                },
                padding: EdgeInsets.all(16.w),
                backgroundColor: CareSyncDesignSystem.primaryTeal.withAlpha(
                  (0.1 * 255).round(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 24.sp,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'View All Notifications',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.primaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

