import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/role_provider.dart';
import '../../core/models/user_model.dart';
import '../../core/utils/local_storage.dart';
import '../../core/widgets/custom_text_field.dart';
import '../dashboard/dashboard_shell.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

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
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final rememberMe = await LocalStorage.getRememberMe();
    if (rememberMe) {
      final email = await LocalStorage.getRememberedEmail();
      final password = await LocalStorage.getRememberedPassword();
      if (mounted && email != null && password != null) {
        setState(() {
          _rememberMe = true;
          _emailController.text = email;
          _passwordController.text = password;
        });
      }
    }
  }

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

      // Save credentials if remember me is checked
      if (_rememberMe) {
        await LocalStorage.saveRememberedCredentials(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await LocalStorage.clearRememberedCredentials();
      }

      // Load registered roles after login
      final registeredRoles = await ref
          .read(authProvider.notifier)
          .getRegisteredRoles();

      // Register roles in RoleProvider
      for (final role in registeredRoles) {
        await ref.read(roleProvider.notifier).registerRole(role);
      }

      // If user has only one role, set it as active automatically
      if (registeredRoles.length == 1) {
        await ref
            .read(roleProvider.notifier)
            .setActiveRole(registeredRoles.first);
      }

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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authProvider.notifier).signInWithGoogle();

      // Load registered roles after Google sign-in
      final registeredRoles = await ref
          .read(authProvider.notifier)
          .getRegisteredRoles();

      // Register roles in RoleProvider
      for (final role in registeredRoles) {
        await ref.read(roleProvider.notifier).registerRole(role);
      }

      // If user has only one role, set it as active automatically
      if (registeredRoles.length == 1) {
        await ref
            .read(roleProvider.notifier)
            .setActiveRole(registeredRoles.first);
      } else if (registeredRoles.isEmpty) {
        // If no roles registered, default to Patient
        await ref.read(roleProvider.notifier).registerRole(UserRole.patient);
        await ref.read(roleProvider.notifier).setActiveRole(UserRole.patient);
      }

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
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10.h),
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
                          'Welcome Back !',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w700,
                            color: CareSyncDesignSystem.primaryTeal,
                            height: 40 / 36,
                          ),
                          textAlign: TextAlign.left,
                        )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 100.ms)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 300.ms,
                          delay: 100.ms,
                        ),
                    SizedBox(height: 4.h),
                    Text(
                      'Hey there! Continue your growth journey',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: CareSyncDesignSystem.textPrimary.withAlpha(
                          (0.6 * 255).round(),
                        ),
                        height: 20 / 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.left,
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
                    SizedBox(height: 40.h),
                    // Email Field
                    CustomTextField(
                          controller: _emailController,
                          label: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validatorType: ValidatorType.email,
                          autovalidateMode: AutovalidateMode.disabled,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
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
                    // Password Field
                    CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          prefixIcon: Icons.lock_outline,
                          validatorType: ValidatorType.password,
                          isPasswordField: true,
                          autovalidateMode: AutovalidateMode.disabled,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                        )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 400.ms)
                        .slideX(
                          begin: -0.2,
                          end: 0,
                          duration: 300.ms,
                          delay: 400.ms,
                        ),
                    SizedBox(height: 28.h),
                    // Remember + Forgot Password
                    SizedBox(
                      height: 21.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _rememberMe = !_rememberMe;
                                  });
                                  // If unchecking remember me, clear saved credentials
                                  if (!_rememberMe) {
                                    await LocalStorage.clearRememberedCredentials();
                                  }
                                },
                                child: Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _rememberMe
                                          ? CareSyncDesignSystem.primaryTeal
                                          : CareSyncDesignSystem.textSecondary,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                    color: _rememberMe
                                        ? CareSyncDesignSystem.primaryTeal
                                        : Colors.transparent,
                                  ),
                                  child: _rememberMe
                                      ? Icon(
                                          Icons.check,
                                          size: 14.sp,
                                          color:
                                              CareSyncDesignSystem.surfaceWhite,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Remember me',
                                style: GoogleFonts.inter(
                                  color: CareSyncDesignSystem.textPrimary
                                      .withAlpha((0.6 * 255).round()),
                                  fontSize: 16.sp,
                                  height: 20 / 16,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.inter(
                                color: CareSyncDesignSystem.textPrimary
                                    .withAlpha((0.6 * 255).round()),
                                fontSize: 16.sp,
                                height: 20 / 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 450.ms),
                    SizedBox(height: 40.h),
                    // Login Button
                    CareSyncButton(
                          text: _isLoading ? 'Logging in...' : 'Login',
                          backgroundColor: CareSyncDesignSystem.primaryTeal,
                          textColor: CareSyncDesignSystem.surfaceWhite,
                          onPressed: _isLoading ? null : _handleLogin,
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
                    SizedBox(height: 40.h),
                    // OR Divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Or',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            height: 16 / 14,
                            fontWeight: FontWeight.w400,
                            color: CareSyncDesignSystem.textPrimary.withAlpha(
                              (0.4 * 255).round(),
                            ),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 300.ms, delay: 600.ms),
                    SizedBox(height: 12.h),
                    // Google Button
                    CareSyncButton(
                          height: 56,
                          text: 'Continue with Google',
                          // backgroundColor: Colors.transparent,
                          textColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ).withAlpha((0.6 * 255).round()),
                          hasBorder: true,
                          borderColor: Colors.grey.shade300,
                          leadingIcon: SvgPicture.asset(
                            'assets/icons/google_icon.svg',
                            width: 24.w,
                            height: 24.h,
                          ),
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          width: double.infinity,
                        )
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 700.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 300.ms,
                          delay: 700.ms,
                        ),
                    SizedBox(height: 39.h),
                    // Signup Text
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.inter(
                              color: CareSyncDesignSystem.textPrimary,
                              fontSize: 12.sp,
                              height: 16 / 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Signup',
                              style: GoogleFonts.inter(
                                color: CareSyncDesignSystem.primaryTeal,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 16 / 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms, delay: 800.ms),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
