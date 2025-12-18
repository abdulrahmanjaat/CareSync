import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../vitals/vitals_entry_form.dart';

class SmartActionCard extends StatelessWidget {
  const SmartActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    // TODO: Add emergency check logic when vitals monitoring is implemented
    // final isEmergency = _checkCriticalVitals();

    final String actionText;
    final IconData actionIcon;
    final Color actionColor;
    final VoidCallback onAction;
    final Color backgroundColor;

    if (hour < 12) {
      actionText = 'Take Meds';
      actionIcon = Icons.medication;
      actionColor = CareSyncDesignSystem.primaryTeal;
      backgroundColor = Colors.white.withAlpha((0.9 * 255).round());
      onAction = () {
        // Handle morning meds
      };
    } else if (hour < 17) {
      actionText = 'Log Vitals';
      actionIcon = Icons.favorite;
      actionColor = CareSyncDesignSystem.primaryTeal;
      backgroundColor = Colors.white.withAlpha((0.9 * 255).round());
      onAction = () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const VitalsEntryForm()));
      };
    } else {
      actionText = 'Log Vitals';
      actionIcon = Icons.bedtime;
      actionColor = CareSyncDesignSystem.primaryTeal;
      backgroundColor = Colors.white.withAlpha((0.9 * 255).round());
      onAction = () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const VitalsEntryForm()));
      };
    }

    return BentoCard(
          padding: EdgeInsets.all(16.w),
          backgroundColor: backgroundColor,
          onTap: onAction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      actionColor,
                      actionColor.withAlpha((0.7 * 255).round()),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: actionColor.withAlpha((0.3 * 255).round()),
                      blurRadius: 12.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: Icon(
                  actionIcon,
                  color: CareSyncDesignSystem.surfaceWhite,
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                actionText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: CareSyncDesignSystem.textPrimary,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 8.h),
              Text(
                'Tap to action',
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  color: CareSyncDesignSystem.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 300.ms)
        .slideX(begin: 0.2, end: 0, duration: 300.ms, delay: 300.ms);
  }
}
