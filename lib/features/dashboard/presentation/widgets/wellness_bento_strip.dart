import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/wellness_provider.dart';

class WellnessBentoStrip extends ConsumerWidget {
  const WellnessBentoStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wellness = ref.watch(wellnessProvider);
    final waterGoalML = 2000; // 2 liters per day (recommended)
    final progress = (wellness.waterIntake / waterGoalML).clamp(0.0, 1.0);

    return Row(
          children: [
            // Hydration Counter
            Expanded(
              child: BentoCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Water Icon with Progress Ring
                    SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Progress Ring Background
                          Container(
                            width: 56.w,
                            height: 56.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CareSyncDesignSystem.textSecondary
                                  .withAlpha((0.1 * 255).round()),
                            ),
                          ),
                          // Progress Ring
                          SizedBox(
                            width: 56.w,
                            height: 56.w,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 4.w,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ),
                          // Icon
                          Icon(
                            Icons.water_drop,
                            size: 28.sp,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Water Amount
                    Text(
                      wellness.waterIntakeLiters >= 1.0
                          ? '${wellness.waterIntakeLiters.toStringAsFixed(1)}L'
                          : '${wellness.waterIntake}ml',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'of ${(waterGoalML / 1000).toStringAsFixed(1)}L goal',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _WaterButton(
                          icon: Icons.remove,
                          onTap: () {
                            ref
                                .read(wellnessProvider.notifier)
                                .removeWater(250);
                          },
                        ),
                        SizedBox(width: 16.w),
                        _WaterButton(
                          icon: Icons.add,
                          onTap: () {
                            ref.read(wellnessProvider.notifier).addWater(250);
                          },
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Mood Selector - Vertical Layout (matches water card)
            Expanded(
              child: BentoCard(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mood Icon
                    Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _getMoodGradient(wellness.mood),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getMoodColor(
                              wellness.mood,
                            ).withAlpha((0.3 * 255).round()),
                            blurRadius: 12.r,
                            spreadRadius: 2.r,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _getMoodEmoji(wellness.mood),
                          style: TextStyle(fontSize: 32.sp),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Mood Label
                    Text(
                      _getMoodLabel(wellness.mood),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Tap to change',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Mood Options - Horizontal Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _MoodOption(
                          emoji: '😊',
                          mood: 'happy',
                          isSelected: wellness.mood == 'happy',
                          onTap: () {
                            ref
                                .read(wellnessProvider.notifier)
                                .setMood('happy');
                          },
                        ),
                        SizedBox(width: 8.w),
                        _MoodOption(
                          emoji: '😐',
                          mood: 'neutral',
                          isSelected: wellness.mood == 'neutral',
                          onTap: () {
                            ref
                                .read(wellnessProvider.notifier)
                                .setMood('neutral');
                          },
                        ),
                        SizedBox(width: 8.w),
                        _MoodOption(
                          emoji: '😣',
                          mood: 'pain',
                          isSelected: wellness.mood == 'pain',
                          onTap: () {
                            ref.read(wellnessProvider.notifier).setMood('pain');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 400.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 400.ms);
  }

  List<Color> _getMoodGradient(String? mood) {
    switch (mood) {
      case 'happy':
        return [
          CareSyncDesignSystem.successEmerald,
          CareSyncDesignSystem.successEmerald.withAlpha((0.7 * 255).round()),
        ];
      case 'neutral':
        return [
          CareSyncDesignSystem.primaryTeal,
          CareSyncDesignSystem.primaryTeal.withAlpha((0.7 * 255).round()),
        ];
      case 'pain':
        return [
          CareSyncDesignSystem.alertRed,
          CareSyncDesignSystem.alertRed.withAlpha((0.7 * 255).round()),
        ];
      default:
        return [
          CareSyncDesignSystem.textSecondary.withAlpha((0.3 * 255).round()),
          CareSyncDesignSystem.textSecondary.withAlpha((0.1 * 255).round()),
        ];
    }
  }

  Color _getMoodColor(String? mood) {
    switch (mood) {
      case 'happy':
        return CareSyncDesignSystem.successEmerald;
      case 'neutral':
        return CareSyncDesignSystem.primaryTeal;
      case 'pain':
        return CareSyncDesignSystem.alertRed;
      default:
        return CareSyncDesignSystem.textSecondary;
    }
  }

  String _getMoodEmoji(String? mood) {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'neutral':
        return '😐';
      case 'pain':
        return '😣';
      default:
        return '😊';
    }
  }

  String _getMoodLabel(String? mood) {
    switch (mood) {
      case 'happy':
        return 'Happy';
      case 'neutral':
        return 'Neutral';
      case 'pain':
        return 'Pain';
      default:
        return 'Tap to log';
    }
  }
}

class _WaterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _WaterButton({
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPrimary
              ? Colors.blue
              : Colors.blue.withAlpha((0.1 * 255).round()),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: Colors.blue.withAlpha((0.3 * 255).round()),
                    blurRadius: 8.r,
                    spreadRadius: 1.r,
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: isPrimary ? CareSyncDesignSystem.surfaceWhite : Colors.blue,
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  final String emoji;
  final String mood;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodOption({
    required this.emoji,
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? CareSyncDesignSystem.primaryTeal.withAlpha((0.2 * 255).round())
              : Colors.transparent,
          border: isSelected
              ? Border.all(color: CareSyncDesignSystem.primaryTeal, width: 2.w)
              : Border.all(
                  color: CareSyncDesignSystem.textSecondary.withAlpha(
                    (0.1 * 255).round(),
                  ),
                  width: 1.w,
                ),
        ),
        child: Center(
          child: Text(emoji, style: TextStyle(fontSize: 18.sp)),
        ),
      ),
    );
  }
}
