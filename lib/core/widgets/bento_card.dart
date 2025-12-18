import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../design/caresync_design_system.dart';

/// Glassmorphic Bento Card with scale-on-tap animation
class BentoCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final int? flex;
  final bool enableAnimation;

  const BentoCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.width,
    this.height,
    this.flex,
    this.enableAnimation = true,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        widget.backgroundColor ?? CareSyncDesignSystem.cardBackgroundColor;

    Widget card = GestureDetector(
      onTapDown: widget.onTap != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onTap!();
            }
          : null,
      onTapCancel: widget.onTap != null
          ? () => setState(() => _isPressed = false)
          : null,
      child: AnimatedContainer(
        duration: CareSyncDesignSystem.animationFast,
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CareSyncDesignSystem.cardRadius),
          border: Border.all(
            color: CareSyncDesignSystem.cardBorderColor,
            width: CareSyncDesignSystem.cardBorderWidth,
          ),
          boxShadow: CareSyncDesignSystem.cardShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CareSyncDesignSystem.cardRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: CareSyncDesignSystem.cardBlurSigma,
              sigmaY: CareSyncDesignSystem.cardBlurSigma,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(
                  CareSyncDesignSystem.cardRadius,
                ),
              ),
              padding:
                  widget.padding ??
                  EdgeInsets.all(CareSyncDesignSystem.spacingL),
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    if (widget.enableAnimation) {
      card = card
          .animate()
          .fadeIn(duration: 300.ms, delay: 50.ms)
          .scale(begin: const Offset(0.9, 0.9), duration: 300.ms, delay: 50.ms);
    }

    if (widget.flex != null) {
      return Expanded(flex: widget.flex!, child: card);
    }

    return card;
  }
}
