import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/caregiver_shift_provider.dart';

/// Shift Control Panel - Timer and break controls
class ShiftControlPanel extends ConsumerStatefulWidget {
  const ShiftControlPanel({super.key});

  @override
  ConsumerState<ShiftControlPanel> createState() => _ShiftControlPanelState();
}

class _ShiftControlPanelState extends ConsumerState<ShiftControlPanel> {
  @override
  void initState() {
    super.initState();
    // Update timer every second
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTimer();
    });
  }

  void _updateTimer() {
    if (mounted) {
      setState(() {});
      Future.delayed(Duration(seconds: 1), _updateTimer);
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final shiftState = ref.watch(caregiverShiftProvider);
    final elapsed = shiftState.elapsedDuration;
    final isOnBreak = shiftState.status == ShiftStatus.onBreak;

    return BentoCard(
      padding: EdgeInsets.all(24.w),
      backgroundColor: CareSyncDesignSystem.primaryTeal.withAlpha(
        (0.1 * 255).round(),
      ),
      child: Column(
        children: [
          // Timer Display
          Text(
            _formatDuration(elapsed),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 56.sp,
              fontWeight: FontWeight.bold,
              color: CareSyncDesignSystem.primaryTeal,
              letterSpacing: 2.w,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isOnBreak ? 'On Break' : 'Shift Duration',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: CareSyncDesignSystem.textSecondary,
            ),
          ),
          SizedBox(height: 24.h),
          // Break Button
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              if (isOnBreak) {
                ref.read(caregiverShiftProvider.notifier).endBreak();
              } else {
                ref.read(caregiverShiftProvider.notifier).startBreak();
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: isOnBreak
                    ? CareSyncDesignSystem.successEmerald
                    : CareSyncDesignSystem.softCoral,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isOnBreak ? Icons.play_arrow : Icons.pause,
                      color: CareSyncDesignSystem.surfaceWhite,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      isOnBreak ? 'End Break' : 'Start Break',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.surfaceWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
