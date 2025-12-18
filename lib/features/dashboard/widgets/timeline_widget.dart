import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/widgets/bento_card.dart';
import '../../../core/providers/medication_provider.dart';

class TimelineWidget extends ConsumerWidget {
  const TimelineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicationProvider);
    final today = DateTime.now();
    final dayName = _getDayName(today.weekday);

    // Get today's medications
    final todayMedications = medications.where((med) {
      return med.frequency.contains(dayName);
    }).toList();

    // Create timeline items from medications
    final timelineItems = <_MedicationTimeSlot>[];
    for (final med in todayMedications) {
      for (final timeStr in med.times) {
        final timeParts = timeStr.split(':');
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = int.tryParse(timeParts[1]) ?? 0;
        final time = TimeOfDay(hour: hour, minute: minute);

        timelineItems.add(_MedicationTimeSlot(medication: med, time: time));
      }
    }

    // Sort by time
    timelineItems.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });

    return BentoCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Medication",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: CareSyncDesignSystem.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          if (timelineItems.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'No medications scheduled for today',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                ),
              ),
            )
          else
            ...timelineItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == timelineItems.length - 1;

              return Column(
                children: [
                  _TimelineItem(
                    time: _formatTime(item.time),
                    medication: item.medication.name,
                    dosage: '${item.medication.dosage} ${item.medication.type}',
                    isCompleted: false,
                  ),
                  if (!isLast) SizedBox(height: 12.h),
                ],
              );
            }).toList(),
        ],
      ),
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

  String _formatTime(TimeOfDay time) {
    final hour12 = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }
}

class _MedicationTimeSlot {
  final Medication medication;
  final TimeOfDay time;

  _MedicationTimeSlot({required this.medication, required this.time});
}

class _TimelineItem extends StatelessWidget {
  final String time;
  final String medication;
  final String dosage;
  final bool isCompleted;

  const _TimelineItem({
    required this.time,
    required this.medication,
    required this.dosage,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Time
        Container(
          width: 60.w,
          child: Text(
            time,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: CareSyncDesignSystem.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? CareSyncDesignSystem.successEmerald
                    : CareSyncDesignSystem.primaryTeal,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
            ),
            if (!isCompleted)
              Container(
                width: 2.w,
                height: 30.h,
                color: CareSyncDesignSystem.textSecondary.withAlpha(
                  (0.2 * 255).round(),
                ),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        // Medication info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medication,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: CareSyncDesignSystem.textPrimary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                dosage,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: CareSyncDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Checkbox
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? CareSyncDesignSystem.successEmerald
                : Colors.transparent,
            border: Border.all(
              color: isCompleted
                  ? CareSyncDesignSystem.successEmerald
                  : CareSyncDesignSystem.textSecondary.withAlpha(
                      (0.3 * 255).round(),
                    ),
              width: 2.w,
            ),
          ),
          child: isCompleted
              ? Icon(
                  Icons.check,
                  size: 16.sp,
                  color: CareSyncDesignSystem.surfaceWhite,
                )
              : null,
        ),
      ],
    );
  }
}
