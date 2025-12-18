import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';

class SafetySlider extends StatefulWidget {
  const SafetySlider({super.key});

  @override
  State<SafetySlider> createState() => _SafetySliderState();
}

class _SafetySliderState extends State<SafetySlider> {
  double _sliderValue = 0.0;
  bool _isActivated = false;

  void _handleSlideComplete() {
    if (_sliderValue >= 0.9) {
      setState(() {
        _isActivated = true;
      });
      // Trigger alert to Manager/Caregiver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Emergency alert sent to your caregivers'),
          backgroundColor: CareSyncDesignSystem.alertRed,
          duration: Duration(seconds: 3),
        ),
      );
      // Reset after delay
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _sliderValue = 0.0;
            _isActivated = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BentoCard(
          padding: EdgeInsets.all(20.w),
          backgroundColor: CareSyncDesignSystem.alertRed.withAlpha(
            (0.1 * 255).round(),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emergency,
                    color: CareSyncDesignSystem.alertRed,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Alert',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.alertRed,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Slide to send alert',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Slider
              Container(
                height: 56.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28.r),
                  color: Colors.white.withAlpha((0.9 * 255).round()),
                  boxShadow: [
                    BoxShadow(
                      color: CareSyncDesignSystem.alertRed.withAlpha(
                        (0.3 * 255).round(),
                      ),
                      blurRadius: 10.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Stack(
                      children: [
                        // Background fill
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width:
                              MediaQuery.of(context).size.width * _sliderValue,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                CareSyncDesignSystem.alertRed,
                                CareSyncDesignSystem.alertRed.withAlpha(
                                  (0.8 * 255).round(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Slider thumb
                        Positioned(
                          left:
                              _sliderValue *
                              (MediaQuery.of(context).size.width - 80.w - 48.w),
                          top: 4.h,
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                _sliderValue =
                                    (_sliderValue +
                                            details.delta.dx /
                                                (MediaQuery.of(
                                                      context,
                                                    ).size.width -
                                                    80.w))
                                        .clamp(0.0, 1.0);
                              });
                            },
                            onHorizontalDragEnd: (_) {
                              _handleSlideComplete();
                            },
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                                    blurRadius: 8.r,
                                    offset: Offset(0, 2.h),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: CareSyncDesignSystem.alertRed,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                        // Text overlay
                        Center(
                          child: Text(
                            _isActivated ? 'Alert Sent!' : 'Slide →',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: _sliderValue > 0.5
                                  ? Colors.white
                                  : CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 500.ms);
  }
}
