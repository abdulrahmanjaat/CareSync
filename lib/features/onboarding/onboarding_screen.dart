import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/caresync_button.dart';
import '../auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Coordinate',
      description:
          'Visualize household health management with ease. Keep track of everyone\'s wellness in one place.',
      icon: Icons.people_outline,
      gradient: [Color(0xFF0D9488), Color(0xFF14B8A6)],
    ),
    OnboardingPage(
      title: 'Track',
      description:
          'Deep medication and vitals tracking. Never miss a dose with intelligent reminders and insights.',
      icon: Icons.medication_outlined,
      gradient: [Color(0xFF10B981), Color(0xFF34D399)],
    ),
    OnboardingPage(
      title: 'Connect',
      description:
          'Secure code-sharing between Managers and Caregivers. Collaborate seamlessly on health management.',
      icon: Icons.shield_outlined,
      gradient: [Color(0xFF6366F1), Color(0xFF818CF8)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToAuth();
    }
  }

  void _goToAuth() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              if (_currentPage < _pages.length - 1)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: TextButton(
                      onPressed: _goToAuth,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: CareSyncDesignSystem.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _OnboardingPageView(page: _pages[index]);
                  },
                ),
              ),
              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _PageIndicator(isActive: index == _currentPage),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
              SizedBox(height: 32.h),
              // Next Button
              Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CareSyncButton(
                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                      width: double.infinity,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 300.ms)
                  .slideY(begin: 0.3, end: 0, duration: 300.ms, delay: 300.ms),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: page.gradient,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: page.gradient[0].withAlpha((0.3 * 255).round()),
                        blurRadius: 40.r,
                        spreadRadius: 10.r,
                      ),
                    ],
                  ),
                  child: Icon(
                    page.icon,
                    size: 100.sp,
                    color: CareSyncDesignSystem.surfaceWhite,
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 400.ms),
            SizedBox(height: 64.h),
            // Title
            Text(
                  page.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 200.ms),
            SizedBox(height: 24.h),
            // Description
            Text(
                  page.description,
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: CareSyncDesignSystem.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 400.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 400.ms),
          ],
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: CareSyncDesignSystem.animationFast,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: isActive
            ? CareSyncDesignSystem.primaryTeal
            : CareSyncDesignSystem.textSecondary.withAlpha((0.3 * 255).round()),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
