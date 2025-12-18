import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

/// CareSync Design System
/// Global constants for colors, spacing, typography, and glassmorphic effects
class CareSyncDesignSystem {
  // Private constructor to prevent instantiation
  CareSyncDesignSystem._();

  // ==================== Colors ====================
  static const Color primaryTeal = Color(0xFF0D9488);
  static const Color alertRed = Color(0xFFEF4444);
  static const Color successEmerald = Color(0xFF10B981);
  static const Color softCoral = Color(0xFFFF6B6B);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color glassWhite = Color(0xFFFFFFFF);

  // ==================== Glassmorphic Card Properties ====================
  static double get cardRadius => 32.r;
  static double get cardBorderWidth => 1.w;
  static Color get cardBorderColor =>
      Colors.white.withAlpha((0.18 * 255).round());
  static Color get cardBackgroundColor =>
      Colors.white.withAlpha((0.7 * 255).round());
  static double get cardBlurSigma => 10.0;

  // ==================== Spacing ====================
  static double get spacingXS => 4.w;
  static double get spacingS => 8.w;
  static double get spacingM => 16.w;
  static double get spacingL => 24.w;
  static double get spacingXL => 32.w;
  static double get spacingXXL => 48.w;

  // ==================== Typography ====================
  static String get fontBody => 'Inter';
  static String get fontHeading => 'Plus Jakarta Sans';

  // ==================== Shadows ====================
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withAlpha((0.05 * 255).round()),
      blurRadius: 20.r,
      offset: Offset(0, 4.h),
    ),
    BoxShadow(
      color: Colors.black.withAlpha((0.03 * 255).round()),
      blurRadius: 10.r,
      offset: Offset(0, 2.h),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primaryTeal.withAlpha((0.3 * 255).round()),
      blurRadius: 15.r,
      offset: Offset(0, 5.h),
    ),
  ];

  // ==================== Text Styles ====================
  static TextStyle heading1(BuildContext context) => TextStyle(
    fontFamily: fontHeading,
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontFamily: fontHeading,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle heading3(BuildContext context) => TextStyle(
    fontFamily: fontHeading,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static TextStyle bodyLarge(BuildContext context) => TextStyle(
    fontFamily: fontBody,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontFamily: fontBody,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
    fontFamily: fontBody,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontFamily: fontBody,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: surfaceWhite,
    letterSpacing: 0.5,
  );

  // ==================== Gradients ====================
  static LinearGradient get meshGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryTeal.withAlpha((0.1 * 255).round()),
      softCoral.withAlpha((0.1 * 255).round()),
      Colors.white,
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  static LinearGradient get primaryGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryTeal, primaryTeal.withAlpha((0.8 * 255).round())],
  );

  // ==================== Border Radius ====================
  static BorderRadius get borderRadiusSmall => BorderRadius.circular(8.r);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(16.r);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(24.r);
  static BorderRadius get borderRadiusXLarge => BorderRadius.circular(32.r);
  static BorderRadius get borderRadiusCard => BorderRadius.circular(cardRadius);

  // ==================== Animation Durations ====================
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
