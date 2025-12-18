import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/caregiver_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/access_permission_provider.dart';
import '../screens/generate_caregiver_code_screen.dart';
import '../screens/manage_caregiver_permissions_screen.dart';

/// Patient Caregiver Management - For patients to manage their caregivers
class PatientCaregiverManagement extends ConsumerWidget {
  const PatientCaregiverManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final caregivers = ref.watch(caregiverProvider).caregivers;
    
    // Get caregivers assigned to current patient (using userId as patientId)
    final assignedCaregivers = caregivers.where((c) {
      return c.assignedPatientIds.contains(authState.userId);
    }).toList();

    return BentoCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Caregivers',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CareSyncDesignSystem.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (authState.userId != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GenerateCaregiverCodeScreen(
                          patientId: authState.userId!,
                          patientName: 'You',
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: CareSyncDesignSystem.primaryTeal.withAlpha(
                      (0.1 * 255).round(),
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.qr_code,
                        size: 16.sp,
                        color: CareSyncDesignSystem.primaryTeal,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Generate Code',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
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
          SizedBox(height: 16.h),
          if (assignedCaregivers.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 48.sp,
                    color: CareSyncDesignSystem.textSecondary.withAlpha(
                      (0.5 * 255).round(),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No caregivers assigned',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Generate a code to invite a caregiver',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...assignedCaregivers.map((caregiver) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _CaregiverCard(caregiver: caregiver),
              );
            }),
        ],
      ),
    );
  }
}

class _CaregiverCard extends ConsumerWidget {
  final Caregiver caregiver;

  const _CaregiverCard({required this.caregiver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: CareSyncDesignSystem.primaryTeal.withAlpha(
          (0.1 * 255).round(),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
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
                  CareSyncDesignSystem.primaryTeal.withAlpha((0.7 * 255).round()),
                ],
              ),
            ),
            child: Icon(
              Icons.person,
              color: CareSyncDesignSystem.surfaceWhite,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caregiver.name,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                ),
                if (caregiver.email != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    caregiver.email!,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
              color: CareSyncDesignSystem.textSecondary,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.settings, size: 18.sp),
                    SizedBox(width: 8.w),
                    Text('Manage Permissions'),
                  ],
                ),
                onTap: () {
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ManageCaregiverPermissionsScreen(
                          caregiver: caregiver,
                        ),
                      ),
                    );
                  });
                },
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.remove_circle_outline, size: 18.sp, color: CareSyncDesignSystem.alertRed),
                    SizedBox(width: 8.w),
                    Text('Remove', style: TextStyle(color: CareSyncDesignSystem.alertRed)),
                  ],
                ),
                onTap: () {
                  // TODO: Implement remove functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

