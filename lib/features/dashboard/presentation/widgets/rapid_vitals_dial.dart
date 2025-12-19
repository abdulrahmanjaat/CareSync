import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/caresync_design_system.dart';
import 'rapid_vitals_dialog.dart';

/// Rapid Vitals Dial - Expandable FAB for quick vitals entry
class RapidVitalsDial extends StatefulWidget {
  const RapidVitalsDial({super.key});

  @override
  State<RapidVitalsDial> createState() => _RapidVitalsDialState();
}

class _RapidVitalsDialState extends State<RapidVitalsDial>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDial() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        HapticFeedback.mediumImpact();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _openVitalsDialog(String vitalType) {
    _toggleDial(); // Close dial first
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RapidVitalsDialog(vitalType: vitalType),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Expanded buttons
        if (_isExpanded) ...[
          // BP Button
          Positioned(
            bottom: 180.h,
            right: 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _VitalButton(
                icon: Icons.favorite,
                label: 'Log BP',
                color: CareSyncDesignSystem.alertRed,
                onTap: () => _openVitalsDialog('BP'),
              ),
            ),
          ),
          // Temp Button
          Positioned(
            bottom: 120.h,
            right: 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _VitalButton(
                icon: Icons.thermostat,
                label: 'Log Temp',
                color: CareSyncDesignSystem.softCoral,
                onTap: () => _openVitalsDialog('Temp'),
              ),
            ),
          ),
          // Sugar Button
          Positioned(
            bottom: 60.h,
            right: 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _VitalButton(
                icon: Icons.cake,
                label: 'Log Sugar',
                color: CareSyncDesignSystem.successEmerald,
                onTap: () => _openVitalsDialog('Sugar'),
              ),
            ),
          ),
        ],
        // Main FAB
        GestureDetector(
          onTap: _toggleDial,
          child: Container(
            width: 64.w,
            height: 64.w,
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
                  color: CareSyncDesignSystem.primaryTeal.withAlpha(
                    (0.3 * 255).round(),
                  ),
                  blurRadius: 12.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Icon(
              _isExpanded ? Icons.close : Icons.add,
              color: CareSyncDesignSystem.surfaceWhite,
              size: 32.sp,
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual Vital Button
class _VitalButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _VitalButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.3 * 255).round()),
              blurRadius: 8.r,
              spreadRadius: 1.r,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: CareSyncDesignSystem.surfaceWhite, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: CareSyncDesignSystem.surfaceWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
