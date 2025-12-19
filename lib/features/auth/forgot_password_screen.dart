import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .resetPassword(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset link sent to ${_emailController.text}',
            ),
            backgroundColor: CareSyncDesignSystem.successEmerald,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: CareSyncDesignSystem.alertRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40.h),
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Logo
                  Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.contain,
                        ),
                      )
                      .animate()
                      .scale(begin: const Offset(0.0, 0.0), duration: 400.ms)
                      .fadeIn(duration: 300.ms),
                  SizedBox(height: 32.h),
                  // Title
                  Text(
                        'Forgot Password?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: CareSyncDesignSystem.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 100.ms,
                      ),
                  SizedBox(height: 8.h),
                  Text(
                    'Enter your email to receive a reset link.',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 40.h),
                  // Email Field
                  CustomTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validatorType: ValidatorType.email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        suffixIcon: Icon(
                          Icons.info_outline,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 300.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 300.ms,
                      ),
                  SizedBox(height: 32.h),
                  // Reset Button
                  CareSyncButton(
                        text: 'Send Reset Link',
                        onPressed: _handleResetPassword,
                        isLoading: _isLoading,
                        width: double.infinity,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 400.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 300.ms,
                        delay: 400.ms,
                      ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
