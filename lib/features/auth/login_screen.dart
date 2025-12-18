import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/auth_provider.dart';
import '../dashboard/dashboard_shell.dart';
import 'signup_screen.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

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
                  // Logo
                  Center(
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: CareSyncDesignSystem.primaryGradient,
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 40.sp,
                            color: CareSyncDesignSystem.surfaceWhite,
                          ),
                        ),
                      )
                      .animate()
                      .scale(begin: const Offset(0.0, 0.0), duration: 400.ms)
                      .fadeIn(duration: 300.ms),
                  SizedBox(height: 32.h),
                  // Title
                  Text(
                        'Welcome Back',
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
                    'Sign in to continue',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 40.h),
                  // Email Field
                  AuthTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
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
                  // Password Field
                  AuthTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        isObscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 400.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 400.ms,
                      ),
                  SizedBox(height: 32.h),
                  // Login Button
                  CareSyncButton(
                        text: 'Sign In',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        width: double.infinity,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 500.ms)
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        duration: 300.ms,
                        delay: 500.ms,
                      ),
                  SizedBox(height: 24.h),
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms, delay: 600.ms),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
