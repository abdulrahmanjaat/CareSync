import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/widgets/bento_card.dart';

class DutyChecklist extends StatefulWidget {
  const DutyChecklist({super.key});

  @override
  State<DutyChecklist> createState() => _DutyChecklistState();
}

class _DutyChecklistState extends State<DutyChecklist> {
  final Map<String, bool> _tasks = {
    'Administer Amlodipine': false,
    'Medication Dose': false,
    'Log Patient\'s BP': false,
    'Test Blood Sugar': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tasks Due Today',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ..._tasks.entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: BentoCard(
              onTap: () {
                setState(() {
                  _tasks[entry.key] = !_tasks[entry.key]!;
                });
              },
              padding: EdgeInsets.all(20.w),
              backgroundColor: entry.value
                  ? CareSyncDesignSystem.successEmerald.withAlpha(
                      (0.1 * 255).round(),
                    )
                  : Colors.white.withAlpha((0.9 * 255).round()),
              child: Row(
                children: [
                  // Large Touch Target Checkbox
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: entry.value
                          ? CareSyncDesignSystem.successEmerald
                          : Colors.transparent,
                      border: Border.all(
                        color: entry.value
                            ? CareSyncDesignSystem.successEmerald
                            : CareSyncDesignSystem.textSecondary.withAlpha(
                                (0.3 * 255).round(),
                              ),
                        width: 2.w,
                      ),
                    ),
                    child: entry.value
                        ? Icon(
                            Icons.check,
                            size: 20.sp,
                            color: CareSyncDesignSystem.surfaceWhite,
                          )
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  // Task Text
                  Expanded(
                    child: Text(
                      entry.key,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                        decoration: entry.value
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: entry.value
                          ? CareSyncDesignSystem.successEmerald.withAlpha(
                              (0.2 * 255).round(),
                            )
                          : CareSyncDesignSystem.alertRed.withAlpha(
                              (0.2 * 255).round(),
                            ),
                    ),
                    child: Text(
                      entry.value ? 'Done' : 'Pending',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: entry.value
                            ? CareSyncDesignSystem.successEmerald
                            : CareSyncDesignSystem.alertRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
