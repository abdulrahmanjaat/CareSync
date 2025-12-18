import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/caregiver_shift_provider.dart';
import 'flag_issue_dialog.dart';

/// Smart Task List - Tasks sorted by time with overdue logic and swipe to flag
class SmartTaskList extends ConsumerWidget {
  const SmartTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftState = ref.watch(caregiverShiftProvider);
    final tasks = shiftState.sortedTasks;

    if (tasks.isEmpty) {
      return BentoCard(
        padding: EdgeInsets.all(32.w),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 64.sp,
                color: CareSyncDesignSystem.textSecondary.withAlpha(
                  (0.5 * 255).round(),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'All tasks completed!',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: CareSyncDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...tasks.map((task) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _TaskCard(task: task),
          );
        }),
      ],
    );
  }
}

/// Individual Task Card with swipe to flag
class _TaskCard extends ConsumerStatefulWidget {
  final CaregiverTask task;

  const _TaskCard({required this.task});

  @override
  ConsumerState<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<_TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _vibrationController;
  bool _hasVibrated = false;

  @override
  void initState() {
    super.initState();
    _vibrationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    );

    // Vibrate if overdue
    if (widget.task.isOverdue && widget.task.status != TaskStatus.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasVibrated) {
          HapticFeedback.mediumImpact();
          _vibrationController.repeat(reverse: true);
          Future.delayed(Duration(seconds: 1), () {
            if (mounted) {
              _vibrationController.stop();
              _vibrationController.reset();
              _hasVibrated = true;
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _vibrationController.dispose();
    super.dispose();
  }

  void _completeTask() {
    HapticFeedback.mediumImpact();
    ref.read(caregiverShiftProvider.notifier).completeTask(widget.task.id);
  }

  void _flagTask() async {
    final note = await showDialog<String>(
      context: context,
      builder: (_) => FlagIssueDialog(),
    );

    if (note != null && note.isNotEmpty) {
      ref.read(caregiverShiftProvider.notifier).flagTask(widget.task.id, note);
      HapticFeedback.mediumImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue = widget.task.isOverdue;
    final isCompleted = widget.task.status == TaskStatus.completed;
    final isFlagged = widget.task.status == TaskStatus.flagged;

    return Dismissible(
      key: Key(widget.task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: CareSyncDesignSystem.alertRed,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.flag,
              color: CareSyncDesignSystem.surfaceWhite,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Flag Issue',
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: CareSyncDesignSystem.surfaceWhite,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => _flagTask(),
      child: GestureDetector(
        onTap: isCompleted ? null : _completeTask,
        child: BentoCard(
          padding: EdgeInsets.all(16.w),
          backgroundColor: isOverdue && !isCompleted
              ? CareSyncDesignSystem.softCoral.withAlpha((0.2 * 255).round())
              : isFlagged
              ? CareSyncDesignSystem.alertRed.withAlpha((0.1 * 255).round())
              : null,
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? CareSyncDesignSystem.successEmerald
                      : isOverdue
                      ? CareSyncDesignSystem.softCoral
                      : CareSyncDesignSystem.primaryTeal.withAlpha(
                          (0.1 * 255).round(),
                        ),
                  border: isCompleted
                      ? null
                      : Border.all(
                          color: isOverdue
                              ? CareSyncDesignSystem.softCoral
                              : CareSyncDesignSystem.primaryTeal,
                          width: 2.w,
                        ),
                ),
                child: isCompleted
                    ? Icon(
                        Icons.check,
                        color: CareSyncDesignSystem.surfaceWhite,
                        size: 24.sp,
                      )
                    : null,
              ),
              SizedBox(width: 16.w),
              // Task Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.task.description,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: CareSyncDesignSystem.textPrimary,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        if (isFlagged)
                          Icon(
                            Icons.flag,
                            color: CareSyncDesignSystem.alertRed,
                            size: 16.sp,
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.task.patientName,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12.sp,
                          color: isOverdue && !isCompleted
                              ? CareSyncDesignSystem.softCoral
                              : CareSyncDesignSystem.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          DateFormat(
                            'h:mm a',
                          ).format(widget.task.scheduledTime),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: isOverdue && !isCompleted
                                ? CareSyncDesignSystem.softCoral
                                : CareSyncDesignSystem.textSecondary,
                            fontWeight: isOverdue && !isCompleted
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (isOverdue && !isCompleted) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: CareSyncDesignSystem.softCoral,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '${widget.task.minutesOverdue}m overdue',
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: CareSyncDesignSystem.surfaceWhite,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (isFlagged && widget.task.flagNote != null) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: CareSyncDesignSystem.alertRed.withAlpha(
                            (0.1 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14.sp,
                              color: CareSyncDesignSystem.alertRed,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                widget.task.flagNote!,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  color: CareSyncDesignSystem.alertRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
