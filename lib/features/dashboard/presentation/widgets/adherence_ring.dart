import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/medication_provider.dart';

class AdherenceRing extends ConsumerStatefulWidget {
  const AdherenceRing({super.key});

  @override
  ConsumerState<AdherenceRing> createState() => _AdherenceRingState();
}

class _AdherenceRingState extends ConsumerState<AdherenceRing> {
  bool _hasShownCelebration = false;

  @override
  Widget build(BuildContext context) {
    final medications = ref.watch(medicationProvider);

    // Calculate adherence based on actual medication times
    // Count total doses scheduled for today
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);

    int totalDoses = 0;
    for (final med in medications) {
      if (med.frequency.contains(dayName)) {
        totalDoses += med.times.length;
      }
    }

    // For now, show 0% adherence (no completion tracking yet)
    // TODO: Implement medication completion tracking
    final completedDoses = 0;
    final adherencePercentage = totalDoses > 0
        ? (completedDoses / totalDoses * 100).round()
        : 0;

    final isPerfect = adherencePercentage >= 100;

    // Trigger celebration animation when reaching 100%
    if (isPerfect && !_hasShownCelebration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _hasShownCelebration = true;
        });
      });
    }

    return BentoCard(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              // Circular Progress Ring
              SizedBox(
                    width: 200.w,
                    height: 200.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background Circle
                        Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CareSyncDesignSystem.textSecondary.withAlpha(
                              (0.1 * 255).round(),
                            ),
                          ),
                        ),
                        // Progress Ring
                        CustomPaint(
                          size: Size(200.w, 200.w),
                          painter: _CircularProgressPainter(
                            progress: (adherencePercentage / 100).clamp(
                              0.0,
                              1.0,
                            ),
                            color: isPerfect
                                ? CareSyncDesignSystem.successEmerald
                                : CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                        // Center Content
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$adherencePercentage%',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 48.sp,
                                fontWeight: FontWeight.bold,
                                color: isPerfect
                                    ? CareSyncDesignSystem.successEmerald
                                    : CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              isPerfect ? 'Perfect! 🎉' : 'Adherence',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: CareSyncDesignSystem.textSecondary,
                                fontWeight: isPerfect
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        // Confetti Effect Overlay (when 100%)
                        if (isPerfect && _hasShownCelebration)
                          ...List.generate(20, (index) {
                            return Positioned(
                              left: (math.Random().nextDouble() * 200.w),
                              top: (math.Random().nextDouble() * 200.w),
                              child:
                                  Icon(
                                        Icons.celebration,
                                        size: 16.sp,
                                        color: [
                                          CareSyncDesignSystem.successEmerald,
                                          CareSyncDesignSystem.primaryTeal,
                                          CareSyncDesignSystem.softCoral,
                                        ][index % 3],
                                      )
                                      .animate()
                                      .fadeOut(duration: 1000.ms, delay: 500.ms)
                                      .moveY(
                                        begin: 0,
                                        end: 50.h,
                                        duration: 1000.ms,
                                        delay: 500.ms,
                                      )
                                      .scale(
                                        begin: const Offset(1, 1),
                                        end: const Offset(0, 0),
                                      ),
                            );
                          }),
                      ],
                    ),
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),
              SizedBox(height: 16.h),
              // Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    label: 'Completed',
                    value: '$completedDoses',
                    color: CareSyncDesignSystem.successEmerald,
                  ),
                  _StatItem(
                    label: 'Total',
                    value: '$totalDoses',
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 200.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          duration: 300.ms,
          delay: 200.ms,
        );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Validate size
    if (size.width <= 0 || size.height <= 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2 - 10).clamp(1.0, double.infinity);

    // Clamp progress between 0 and 1
    final clampedProgress = progress.clamp(0.0, 1.0);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Only create gradient if progress > 0
    if (clampedProgress > 0) {
      try {
        // Create gradient shader with valid rect
        final rect = Rect.fromCircle(center: center, radius: radius);
        if (rect.width > 0 && rect.height > 0) {
          final gradient = SweepGradient(
            startAngle: -math.pi / 2,
            endAngle: -math.pi / 2 + (2 * math.pi * clampedProgress),
            colors: [color, color.withAlpha((0.6 * 255).round())],
          );
          paint.shader = gradient.createShader(rect);
        }
      } catch (e) {
        // Fallback to solid color if gradient fails
        paint.shader = null;
      }
    }

    // Draw arc
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    if (arcRect.width > 0 && arcRect.height > 0) {
      canvas.drawArc(
        arcRect,
        -math.pi / 2,
        2 * math.pi * clampedProgress,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: CareSyncDesignSystem.textSecondary,
          ),
        ),
      ],
    );
  }
}
