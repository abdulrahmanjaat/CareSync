import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../design/caresync_design_system.dart';

/// Responsive Icon scaled via ScreenUtil
class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final double? scale;

  const ResponsiveIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = (size ?? 24.0) * (scale ?? 1.0);
    final iconColor = color ?? CareSyncDesignSystem.textPrimary;

    return Icon(icon, size: iconSize.sp, color: iconColor);
  }
}
