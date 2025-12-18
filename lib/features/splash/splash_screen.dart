import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/caresync_design_system.dart';
import '../dashboard/dashboard_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Navigate directly to dashboard/home for now
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const DashboardShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: CareSyncDesignSystem.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: CareSyncDesignSystem.primaryTeal.withAlpha(
                            (0.3 * 255).round(),
                          ),
                          blurRadius: 30.r,
                          spreadRadius: 10.r,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 60.sp,
                      color: CareSyncDesignSystem.surfaceWhite,
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
                      color: CareSyncDesignSystem.primaryTeal,
                      letterSpacing: 1.2,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 600.ms),
              SizedBox(height: 8.h),
              Text(
                    'Your Health, Synchronized',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: CareSyncDesignSystem.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 800.ms)
                  .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}
