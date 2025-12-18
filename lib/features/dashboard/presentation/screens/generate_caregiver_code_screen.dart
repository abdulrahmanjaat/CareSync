import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/code_provider.dart';
import '../../../../core/providers/auth_provider.dart';

/// Generate Caregiver Code Screen - For patients/managers to generate codes
class GenerateCaregiverCodeScreen extends ConsumerWidget {
  final String patientId;
  final String patientName;

  const GenerateCaregiverCodeScreen({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    // Get or generate code for this patient
    final existingCode = ref.read(codeProvider.notifier).getCaregiverCodeForPatient(patientId);
    final displayCode = existingCode ?? (authState.userId != null
        ? ref.read(codeProvider.notifier).generateCaregiverCode(
            authState.userId!,
            patientId,
          )
        : null);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Text(
                        'Caregiver Code',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: CareSyncDesignSystem.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Code Display Card
                BentoCard(
                  padding: EdgeInsets.all(32.w),
                  backgroundColor: CareSyncDesignSystem.primaryTeal.withAlpha(
                    (0.1 * 255).round(),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Share this code with caregiver',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      if (displayCode != null) ...[
                        Text(
                          displayCode.code,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.primaryTeal,
                            letterSpacing: 4.w,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Expires: ${_formatDate(displayCode.expiresAt)}',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Actions
                Row(
                  children: [
                    Expanded(
                      child: CareSyncButton(
                        text: 'Copy Code',
                        icon: Icons.copy,
                        onPressed: () {
                          if (displayCode != null) {
                            Clipboard.setData(ClipboardData(text: displayCode.code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Code copied to clipboard'),
                                backgroundColor: CareSyncDesignSystem.successEmerald,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CareSyncButton(
                        text: 'Share',
                        icon: Icons.share,
                        isOutlined: true,
                        onPressed: () {
                          if (displayCode != null) {
                            // TODO: Implement share functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Share functionality coming soon'),
                                backgroundColor: CareSyncDesignSystem.primaryTeal,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Instructions
                BentoCard(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20.sp,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'How it works',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _InstructionItem(
                        number: '1',
                        text: 'Share this code with your caregiver',
                      ),
                      SizedBox(height: 12.h),
                      _InstructionItem(
                        number: '2',
                        text: 'Caregiver enters code in their app',
                      ),
                      SizedBox(height: 12.h),
                      _InstructionItem(
                        number: '3',
                        text: 'You approve the caregiver request',
                      ),
                      SizedBox(height: 12.h),
                      _InstructionItem(
                        number: '4',
                        text: 'Caregiver can now assist with your care',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CareSyncDesignSystem.primaryTeal,
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: CareSyncDesignSystem.surfaceWhite,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: CareSyncDesignSystem.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

