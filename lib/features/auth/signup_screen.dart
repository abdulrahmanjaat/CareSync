import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/role_provider.dart';
import '../dashboard/dashboard_shell.dart';
import 'login_screen.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'widgets/role_dropdown.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;
  UserRole? _selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please agree to terms & conditions'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a role'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text,
            _nameController.text.trim(),
            _selectedRole!,
          );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardShell()),
        );
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
                  // SizedBox(height: 40.h),
                  // Logo
                  Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 200.w,
                          height: 200.w,
                          fit: BoxFit.contain,
                        ),
                      )
                      .animate()
                      .scale(begin: const Offset(0.0, 0.0), duration: 400.ms)
                      .fadeIn(duration: 300.ms),
                  // SizedBox(height: 32.h),
                  // Title
                  Text(
                        'Create Your Account',
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
                    'Join CareSync today',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 40.h),
                  // Full Name Field
                  CustomTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        prefixIcon: Icons.person_outline,
                        validatorType: ValidatorType.name,
                        autovalidateMode: AutovalidateMode.disabled,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 300.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 300.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Email Field
                  CustomTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validatorType: ValidatorType.email,
                        autovalidateMode: AutovalidateMode.disabled,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 400.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 400.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Password Field
                  CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        validatorType: ValidatorType.password,
                        isPasswordField: true,
                        autovalidateMode: AutovalidateMode.disabled,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 500.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 500.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Confirm Password Field
                  CustomTextField(
                        controller: _confirmPasswordController,
                        passwordController: _passwordController,
                        label: 'Confirm Password',
                        prefixIcon: Icons.lock_outline,
                        validatorType: ValidatorType.confirmPassword,
                        isPasswordField: true,
                        autovalidateMode: AutovalidateMode.disabled,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 600.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 600.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Role Dropdown
                  RoleDropdown(
                        selectedRole: _selectedRole,
                        onRoleSelected: (role) {
                          setState(() {
                            _selectedRole = role;
                          });
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 700.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 700.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Terms & Conditions Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: CareSyncDesignSystem.successEmerald,
                        checkColor: CareSyncDesignSystem.surfaceWhite,
                      ),
                      Expanded(
                        child: Text(
                          'I agree to terms & conditions',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 800.ms),
                  SizedBox(height: 32.h),
                  // Sign Up Button
                  CareSyncButton(
                        text: 'Sign Up',
                        onPressed: _handleSignUp,
                        isLoading: _isLoading,
                        width: double.infinity,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 900.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 300.ms,
                        delay: 900.ms,
                      ),
                  SizedBox(height: 24.h),
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 1000.ms),
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
