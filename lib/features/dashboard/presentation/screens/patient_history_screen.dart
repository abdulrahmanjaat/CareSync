import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/household_provider.dart';

/// Patient History Screen - Full history view
class PatientHistoryScreen extends ConsumerWidget {
  final Patient patient;

  const PatientHistoryScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate extended history (30 days) for demonstration
    final extendedHistory = _generateExtendedHistory();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _HistoryHeader(patient: patient),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Card
                      _HistorySummaryCard(history: extendedHistory),
                      SizedBox(height: 16.h),
                      // History Timeline
                      Text(
                        'Vitals History',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: CareSyncDesignSystem.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...extendedHistory.asMap().entries.map((entry) {
                        final index = entry.key;
                        final vital = entry.value;
                        final isLast = index == extendedHistory.length - 1;
                        return _HistoryTimelineItem(
                          vital: vital,
                          isLast: isLast,
                        );
                      }),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<VitalTrend> _generateExtendedHistory() {
    final now = DateTime.now();
    return List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      return VitalTrend(
        date: date,
        heartRate: 65 + (index % 15) + (index % 7),
        bloodPressure: '${115 + (index % 10)}/${75 + (index % 8)}',
      );
    });
  }
}

/// History Header
class _HistoryHeader extends StatelessWidget {
  final Patient patient;

  const _HistoryHeader({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(24.w),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: CareSyncDesignSystem.textPrimary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient.name}\'s History',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Last 30 days',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }
}

/// History Summary Card
class _HistorySummaryCard extends StatelessWidget {
  final List<VitalTrend> history;

  const _HistorySummaryCard({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    final heartRates = history
        .where((v) => v.heartRate != null)
        .map((v) => v.heartRate!)
        .toList();

    if (heartRates.isEmpty) {
      return const SizedBox.shrink();
    }

    final avgHeartRate =
        (heartRates.reduce((a, b) => a + b) / heartRates.length).round();
    final minHeartRate = heartRates.reduce((a, b) => a < b ? a : b);
    final maxHeartRate = heartRates.reduce((a, b) => a > b ? a : b);

    return BentoCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Summary',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CareSyncDesignSystem.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: 'Average',
                      value: '$avgHeartRate bpm',
                      icon: Icons.trending_up,
                      color: CareSyncDesignSystem.primaryTeal,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SummaryItem(
                      label: 'Min',
                      value: '$minHeartRate bpm',
                      icon: Icons.arrow_downward,
                      color: CareSyncDesignSystem.successEmerald,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _SummaryItem(
                      label: 'Max',
                      value: '$maxHeartRate bpm',
                      icon: Icons.arrow_upward,
                      color: CareSyncDesignSystem.alertRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 100.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms, delay: 100.ms);
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: color),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
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

/// History Timeline Item
class _HistoryTimelineItem extends StatelessWidget {
  final VitalTrend vital;
  final bool isLast;

  const _HistoryTimelineItem({required this.vital, required this.isLast});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return DateFormat('MMM d').format(date); // Month day
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Indicator
        Column(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CareSyncDesignSystem.primaryTeal,
                border: Border.all(
                  color: CareSyncDesignSystem.surfaceWhite,
                  width: 2.w,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 80.h,
                color: CareSyncDesignSystem.textSecondary.withAlpha(
                  (0.2 * 255).round(),
                ),
              ),
          ],
        ),
        SizedBox(width: 16.w),
        // Content Card
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 12.h),
            child: BentoCard(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(vital.date),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: CareSyncDesignSystem.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(vital.date),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _VitalDisplayItem(
                          icon: Icons.favorite,
                          label: 'Heart Rate',
                          value: vital.heartRate != null
                              ? '${vital.heartRate} bpm'
                              : '--',
                          color: CareSyncDesignSystem.alertRed,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _VitalDisplayItem(
                          icon: Icons.monitor_heart,
                          label: 'Blood Pressure',
                          value: vital.bloodPressure ?? '--',
                          color: CareSyncDesignSystem.primaryTeal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VitalDisplayItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _VitalDisplayItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                color: CareSyncDesignSystem.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: CareSyncDesignSystem.textPrimary,
          ),
        ),
      ],
    );
  }
}
