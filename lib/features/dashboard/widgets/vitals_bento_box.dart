import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/widgets/bento_card.dart';
import '../../../core/widgets/responsive_icon.dart';
import '../../../core/providers/vitals_provider.dart';
import '../../vitals/vitals_entry_form.dart';

class VitalsBentoBox extends ConsumerWidget {
  const VitalsBentoBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vitals = ref.watch(vitalsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Vitals',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        // Bento Grid - First Row
        Row(
          children: [
            Expanded(
              child: BentoCard(
                height: 120.h,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VitalsEntryForm()),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveIcon(
                      icon: Icons.favorite,
                      size: 28,
                      color: CareSyncDesignSystem.alertRed,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Heart Rate',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vitals.heartRate != null
                          ? '${vitals.heartRate} bpm'
                          : '-- bpm',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: vitals.heartRate != null
                            ? CareSyncDesignSystem.textPrimary
                            : CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                height: 120.h,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VitalsEntryForm()),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveIcon(
                      icon: Icons.monitor_heart,
                      size: 28,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Blood Pressure',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vitals.bloodPressure ?? '-- mmHg',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: vitals.bloodPressure != null
                            ? CareSyncDesignSystem.textPrimary
                            : CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                height: 120.h,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VitalsEntryForm()),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveIcon(
                      icon: Icons.thermostat,
                      size: 28,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Temperature',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vitals.temperature != null
                          ? '${vitals.temperature!.toStringAsFixed(1)}°F'
                          : '--°F',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: vitals.temperature != null
                            ? CareSyncDesignSystem.textPrimary
                            : CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Bento Grid - Second Row
        Row(
          children: [
            Expanded(
              child: BentoCard(
                height: 120.h,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VitalsEntryForm()),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveIcon(
                      icon: Icons.monitor_weight,
                      size: 28,
                      color: CareSyncDesignSystem.softCoral,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Weight',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vitals.weight != null
                          ? '${vitals.weight!.toStringAsFixed(1)} lbs'
                          : '-- lbs',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: vitals.weight != null
                            ? CareSyncDesignSystem.textPrimary
                            : CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                height: 120.h,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VitalsEntryForm()),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveIcon(
                      icon: Icons.cake,
                      size: 28,
                      color: CareSyncDesignSystem.successEmerald,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Glucose',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vitals.glucose != null
                          ? '${vitals.glucose!.toStringAsFixed(0)} mg/dL'
                          : '-- mg/dL',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: vitals.glucose != null
                            ? CareSyncDesignSystem.textPrimary
                            : CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BentoCard(
                height: 120.h,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VitalsEntryForm()),
                  );
                },
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveIcon(
                      icon: Icons.air,
                      size: 28,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'SpO2',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vitals.oxygenSaturation != null
                          ? '${vitals.oxygenSaturation}%'
                          : '--%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: vitals.oxygenSaturation != null
                            ? CareSyncDesignSystem.textPrimary
                            : CareSyncDesignSystem.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
