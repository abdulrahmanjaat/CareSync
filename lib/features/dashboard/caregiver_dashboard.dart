import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import 'presentation/widgets/shift_control_panel.dart';
import 'presentation/widgets/smart_task_list.dart';
import 'presentation/widgets/shift_handoff_card.dart';
import 'presentation/widgets/rapid_vitals_dial.dart';
import 'presentation/screens/join_patient_screen.dart';

/// Caregiver Dashboard - Shift protocol & rapid entry
class CaregiverDashboard extends ConsumerWidget {
  const CaregiverDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Caregiver',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Shift Dashboard',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 48.w,
                      height: 48.w,
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
                        Icons.medical_services,
                        color: CareSyncDesignSystem.surfaceWhite,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Join Patient Button
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const JoinPatientScreen(),
                            ),
                          );
                        },
                        child: BentoCard(
                          padding: EdgeInsets.all(16.w),
                          backgroundColor: CareSyncDesignSystem.successEmerald
                              .withAlpha((0.1 * 255).round()),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_add,
                                color: CareSyncDesignSystem.successEmerald,
                                size: 24.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Join a Patient',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: CareSyncDesignSystem.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      'Enter a caregiver code',
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color:
                                            CareSyncDesignSystem.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      // Shift Control Panel
                      ShiftControlPanel(),
                      SizedBox(height: 24.h),
                      // Smart Task List
                      SmartTaskList(),
                      SizedBox(height: 24.h),
                      // Shift Handoff Card (persistent at bottom)
                      ShiftHandoffCard(),
                      SizedBox(height: 100.h), // Space for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Rapid Vitals Dial FAB
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 16.w),
        child: RapidVitalsDial(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
