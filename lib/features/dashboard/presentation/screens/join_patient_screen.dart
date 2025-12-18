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
import '../../../../core/providers/caregiver_provider.dart';

/// Join Patient Screen - For caregivers to join via code
class JoinPatientScreen extends ConsumerStatefulWidget {
  const JoinPatientScreen({super.key});

  @override
  ConsumerState<JoinPatientScreen> createState() => _JoinPatientScreenState();
}

class _JoinPatientScreenState extends ConsumerState<JoinPatientScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinPatient() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a code'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authState = ref.read(authProvider);
    if (authState.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please login first'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Find the code first
    final codeState = ref.read(codeProvider);
    final accessCode = codeState.codes.firstWhere(
      (c) => c.code == code && c.type == CodeType.caregiverCode,
      orElse: () => AccessCode(
        id: '',
        code: '',
        type: CodeType.caregiverCode,
        generatedByUserId: '',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now(),
      ),
    );

    if (accessCode.id.isEmpty || !accessCode.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid or expired code'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Use the code
    final codeUsed = ref.read(codeProvider.notifier).useCode(code, authState.userId!);
    
    if (!codeUsed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to use code'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    
    if (accessCode.patientId != null) {
      // Find or create caregiver and assign to patient
      final caregivers = ref.read(caregiverProvider).caregivers;
      final caregiver = caregivers.firstWhere(
        (c) => c.id == authState.userId,
        orElse: () => Caregiver(
          id: authState.userId!,
          name: 'Caregiver', // TODO: Get from user profile
          email: authState.email,
        ),
      );
      
      // Add caregiver if doesn't exist
      if (!caregivers.any((c) => c.id == authState.userId)) {
        ref.read(caregiverProvider.notifier).addCaregiver(caregiver);
      }
      
      // Assign caregiver to patient
      ref.read(caregiverProvider.notifier).assignPatientToCaregiver(
        authState.userId!,
        accessCode.patientId!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined patient'),
          backgroundColor: CareSyncDesignSystem.successEmerald,
        ),
      );

      Navigator.of(context).pop();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        'Join Patient',
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
                            'Enter Caregiver Code',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Ask the patient or manager for a 6-digit caregiver code to link your account.',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                // Code Input
                Text(
                  'Caregiver Code',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                BentoCard(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                  child: TextFormField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.primaryTeal,
                      letterSpacing: 8.w,
                    ),
                    decoration: InputDecoration(
                      hintText: '000000',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textSecondary.withAlpha(
                          (0.3 * 255).round(),
                        ),
                        letterSpacing: 8.w,
                      ),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Join Button
                CareSyncButton(
                  text: 'Join Patient',
                  icon: Icons.person_add,
                  onPressed: _isLoading ? null : _joinPatient,
                  width: double.infinity,
                  isLoading: _isLoading,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

