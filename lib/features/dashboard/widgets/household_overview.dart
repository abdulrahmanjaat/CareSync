import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/widgets/bento_card.dart';

class HouseholdOverview extends StatelessWidget {
  const HouseholdOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Family Members',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        // Patient Cards with Status Glows
        _PatientCard(
          name: 'John Doe',
          role: 'Patient',
          statusGlow: CareSyncDesignSystem.successEmerald, // Green = Good
        ),
        SizedBox(height: 12.h),
        _PatientCard(
          name: 'Sarah Smith',
          role: 'Patient',
          statusGlow: CareSyncDesignSystem.alertRed, // Red = Missed vitals
        ),
        SizedBox(height: 12.h),
        _PatientCard(
          name: 'Michael Johnson',
          role: 'Patient',
          statusGlow: CareSyncDesignSystem.primaryTeal, // Teal = Normal
        ),
      ],
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final String role;
  final Color statusGlow;

  const _PatientCard({
    required this.name,
    required this.role,
    required this.statusGlow,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      onTap: () {
        // Navigate to patient details
      },
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          // Status Glow Indicator
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusGlow,
              boxShadow: [
                BoxShadow(
                  color: statusGlow.withAlpha((0.6 * 255).round()),
                  blurRadius: 8.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // Avatar
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: CareSyncDesignSystem.primaryGradient,
            ),
            child: Icon(
              Icons.person,
              color: CareSyncDesignSystem.surfaceWhite,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  role,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Arrow
          Icon(
            Icons.chevron_right,
            color: CareSyncDesignSystem.textSecondary,
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}
