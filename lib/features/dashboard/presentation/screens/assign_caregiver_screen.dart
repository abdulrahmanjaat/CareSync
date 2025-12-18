import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/household_provider.dart';
import '../../../../core/providers/caregiver_provider.dart';

/// Assign Caregiver Screen - Assign/unassign caregivers to a patient
class AssignCaregiverScreen extends ConsumerWidget {
  final Patient patient;

  const AssignCaregiverScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caregivers = ref.watch(caregiverProvider).caregivers;
    final assignedCaregivers = ref
        .read(caregiverProvider.notifier)
        .getCaregiversForPatient(patient.id);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _CaregiverHeader(patient: patient),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Assigned Caregivers Section
                      if (assignedCaregivers.isNotEmpty) ...[
                        Text(
                          'Assigned Caregivers',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...assignedCaregivers.map((caregiver) {
                          return _CaregiverCard(
                            caregiver: caregiver,
                            patient: patient,
                            isAssigned: true,
                          );
                        }),
                        SizedBox(height: 24.h),
                      ],
                      // Available Caregivers Section
                      Text(
                        'Available Caregivers',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: CareSyncDesignSystem.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      if (caregivers.isEmpty)
                        BentoCard(
                          padding: EdgeInsets.all(20.w),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 48.sp,
                                  color: CareSyncDesignSystem.textSecondary
                                      .withAlpha((0.5 * 255).round()),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'No caregivers available',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: CareSyncDesignSystem.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ...caregivers
                            .where((c) => !assignedCaregivers.contains(c))
                            .map((caregiver) {
                              return _CaregiverCard(
                                caregiver: caregiver,
                                patient: patient,
                                isAssigned: false,
                              );
                            }),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Caregiver Header
class _CaregiverHeader extends StatelessWidget {
  final Patient patient;

  const _CaregiverHeader({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(24.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: CareSyncDesignSystem.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assign Caregivers',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'For ${patient.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }
}

/// Caregiver Card
class _CaregiverCard extends ConsumerWidget {
  final Caregiver caregiver;
  final Patient patient;
  final bool isAssigned;

  const _CaregiverCard({
    required this.caregiver,
    required this.patient,
    required this.isAssigned,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: BentoCard(
            padding: EdgeInsets.all(16.w),
            backgroundColor: isAssigned
                ? CareSyncDesignSystem.successEmerald.withAlpha(
                    (0.1 * 255).round(),
                  )
                : null,
            child: Row(
              children: [
                // Avatar
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
                  child: caregiver.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            caregiver.avatarUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: CareSyncDesignSystem.surfaceWhite,
                          size: 24.sp,
                        ),
                ),
                SizedBox(width: 12.w),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caregiver.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: CareSyncDesignSystem.textPrimary,
                        ),
                      ),
                      if (caregiver.email != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          caregiver.email!,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                      if (caregiver.phone != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          caregiver.phone!,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Action Button
                GestureDetector(
                  onTap: () {
                    if (isAssigned) {
                      ref
                          .read(caregiverProvider.notifier)
                          .unassignPatientFromCaregiver(
                            caregiver.id,
                            patient.id,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${caregiver.name} unassigned'),
                          backgroundColor: CareSyncDesignSystem.primaryTeal,
                        ),
                      );
                    } else {
                      ref
                          .read(caregiverProvider.notifier)
                          .assignPatientToCaregiver(caregiver.id, patient.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${caregiver.name} assigned'),
                          backgroundColor: CareSyncDesignSystem.successEmerald,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isAssigned
                          ? CareSyncDesignSystem.alertRed
                          : CareSyncDesignSystem.successEmerald,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAssigned ? Icons.remove : Icons.add,
                          color: CareSyncDesignSystem.surfaceWhite,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isAssigned ? 'Remove' : 'Assign',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.surfaceWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms);
  }
}
