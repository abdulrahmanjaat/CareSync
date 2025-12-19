import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../design/caresync_design_system.dart';

/// Glassmorphic Button with loading states
class CareSyncButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final IconData? icon;
  final Widget? leadingIcon;
  final bool hasBorder;
  final Color? borderColor;

  const CareSyncButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.icon,
    this.leadingIcon,
    this.hasBorder = false,
    this.borderColor,
  });

  @override
  State<CareSyncButton> createState() => _CareSyncButtonState();
}

class _CareSyncButtonState extends State<CareSyncButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? CareSyncDesignSystem.primaryTeal;
    final txtColor = widget.textColor ?? CareSyncDesignSystem.surfaceWhite;

    return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            if (!widget.isLoading && widget.onPressed != null) {
              widget.onPressed!();
            }
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedContainer(
            duration: CareSyncDesignSystem.animationFast,
            width: widget.width,
            height: widget.height ?? 56.h,
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(_isPressed ? 0.98 : 1.0),
            decoration: BoxDecoration(
              borderRadius: CareSyncDesignSystem.borderRadiusXLarge,
              gradient: widget.isOutlined
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [bgColor, bgColor.withAlpha((0.8 * 255).round())],
                    ),
              border: widget.isOutlined || widget.hasBorder
                  ? Border.all(
                      color: widget.borderColor ?? Colors.grey.shade300,
                      width: CareSyncDesignSystem.cardBorderWidth,
                    )
                  : null,
              boxShadow: widget.isOutlined
                  ? null
                  : CareSyncDesignSystem.buttonShadow,
            ),
            child: ClipRRect(
              borderRadius: CareSyncDesignSystem.borderRadiusXLarge,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.isOutlined ? 0 : 5.0,
                  sigmaY: widget.isOutlined ? 0 : 5.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(txtColor),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.leadingIcon != null) ...[
                              widget.leadingIcon!,
                              SizedBox(width: 8.w),
                            ] else if (widget.icon != null) ...[
                              Icon(widget.icon, color: txtColor, size: 20.sp),
                              SizedBox(width: 8.w),
                            ],
                            Flexible(
                              child: Text(
                                widget.text,
                                style: CareSyncDesignSystem.buttonText(
                                  context,
                                ).copyWith(color: txtColor),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 200.ms)
        .scale(begin: const Offset(0.95, 0.95), duration: 200.ms);
  }
}
