import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/role_provider.dart';
import '../dashboard/dashboard_shell.dart';
import '../auth/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    // Check authentication state
    final authState = ref.read(authProvider);

    if (!authState.isAuthenticated) {
      // Not authenticated - go to login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
      return;
    }

    // Authenticated - load roles and navigate to dashboard
    try {
      // Load registered roles from user account
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
      // If error loading roles, go to login
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                            width: 150.w,
                            height: 150.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  CareSyncDesignSystem.primaryTeal,
                                  CareSyncDesignSystem.primaryTeal.withAlpha(
                                    (0.8 * 255).round(),
                                  ),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: CareSyncDesignSystem.primaryTeal
                                      .withAlpha((0.3 * 255).round()),
                                  blurRadius: 20.r,
                                  spreadRadius: 5.r,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(25.w),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                            ),
                          )
                          .animate()
                          .scale(
                            begin: const Offset(0.0, 0.0),
                            end: const Offset(1.0, 1.0),
                            duration: 800.ms,
                            curve: Curves.elasticOut,
                          )
                          .fadeIn(duration: 600.ms),
                      SizedBox(height: 32.h),
                      // App Name
                      Text(
                            'CareSync',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 600.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 400.ms,
                            delay: 600.ms,
                          ),
                      SizedBox(height: 8.h),
                      Text(
                            'Your Integrated Health Hub',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: Colors.white.withAlpha(
                                (0.9 * 255).round(),
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 800.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 400.ms,
                            delay: 800.ms,
                          ),
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
