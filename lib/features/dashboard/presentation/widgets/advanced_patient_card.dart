import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/household_provider.dart';

/// Advanced Patient Card with sparklines, geofence, and inventory warnings
class AdvancedPatientCard extends ConsumerStatefulWidget {
  final Patient patient;
  final VoidCallback? onTap;

  const AdvancedPatientCard({super.key, required this.patient, this.onTap});

  @override
  ConsumerState<AdvancedPatientCard> createState() =>
      _AdvancedPatientCardState();
}

class _AdvancedPatientCardState extends ConsumerState<AdvancedPatientCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    switch (widget.patient.status) {
      case PatientStatus.critical:
        return CareSyncDesignSystem.alertRed;
      case PatientStatus.lowStock:
        return CareSyncDesignSystem.softCoral;
      case PatientStatus.stable:
        return CareSyncDesignSystem.successEmerald;
    }
  }

  String _getStatusText() {
    switch (widget.patient.status) {
      case PatientStatus.critical:
        return 'Critical';
      case PatientStatus.lowStock:
        return 'Low Stock';
      case PatientStatus.stable:
        return 'Stable';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCritical = widget.patient.status == PatientStatus.critical;
    final hasLowStock = widget.patient.hasLowStock;

    return GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    CareSyncDesignSystem.cardRadius,
                  ),
                  border: isCritical
                      ? Border.all(
                          color: CareSyncDesignSystem.alertRed.withAlpha(
                            (0.3 + (_pulseController.value * 0.4) * 255)
                                .round(),
                          ),
                          width: 2.w,
                        )
                      : null,
                ),
                child: BentoCard(
                  padding: EdgeInsets.all(16.w),
                  backgroundColor: isCritical
                      ? CareSyncDesignSystem.alertRed.withAlpha(
                          (0.05 * 255).round(),
                        )
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _getStatusColor(),
                                  _getStatusColor().withAlpha(
                                    (0.7 * 255).round(),
                                  ),
                                ],
                              ),
                            ),
                            child: widget.patient.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      widget.patient.avatarUrl!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    color: CareSyncDesignSystem.surfaceWhite,
                                    size: 24.sp,
                                  ),
                          ),
                          SizedBox(width: 12.w),
                          // Name and Status
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.patient.name,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: CareSyncDesignSystem.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor().withAlpha(
                                          (0.2 * 255).round(),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Text(
                                        _getStatusText(),
                                        style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: _getStatusColor(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    // Geofence Indicator
                                    Icon(
                                      widget.patient.isHome
                                          ? Icons.home
                                          : Icons.location_on_outlined,
                                      size: 16.sp,
                                      color: widget.patient.isHome
                                          ? CareSyncDesignSystem.successEmerald
                                          : CareSyncDesignSystem.textSecondary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      widget.patient.isHome ? 'Home' : 'Away',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.sp,
                                        color:
                                            CareSyncDesignSystem.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Inventory Warning Icon
                          if (hasLowStock)
                            Stack(
                              children: [
                                Icon(
                                  Icons.medication,
                                  size: 24.sp,
                                  color: CareSyncDesignSystem.alertRed,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: CareSyncDesignSystem.alertRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Trend Sparkline
                      if (widget.patient.vitalTrends.isNotEmpty) ...[
                        Row(
                          children: [
                            Text(
                              '7-Day Trend',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _SparklineChart(
                                trends: widget.patient.vitalTrends,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                      ],
                      // Medication Inventory Summary
                      if (hasLowStock) ...[
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: CareSyncDesignSystem.alertRed.withAlpha(
                              (0.1 * 255).round(),
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning,
                                size: 16.sp,
                                color: CareSyncDesignSystem.alertRed,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Low stock: ${widget.patient.medications.where((m) => m.daysRemaining < 3).map((m) => m.name).join(', ')}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: CareSyncDesignSystem.alertRed,
                                    fontWeight: FontWeight.w600,
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
              );
            },
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms);
  }
}

/// Mini Sparkline Chart Widget
class _SparklineChart extends StatelessWidget {
  final List<VitalTrend> trends;

  const _SparklineChart({required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) return const SizedBox.shrink();

    // Extract heart rate data for the sparkline
    final heartRateData = trends
        .map((t) => t.heartRate?.toDouble() ?? 0.0)
        .where((v) => v > 0)
        .toList();

    if (heartRateData.isEmpty) return const SizedBox.shrink();

    final minValue = heartRateData.reduce(math.min);
    final maxValue = heartRateData.reduce(math.max);
    final range = maxValue - minValue;

    final maxChartHeight = 40.0;

    return SizedBox(
      height: maxChartHeight,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: heartRateData.asMap().entries.map((entry) {
                final index = entry.key.toDouble();
                final value = entry.value;
                final normalizedValue = range > 0
                    ? ((value - minValue) / range) * maxChartHeight
                    : maxChartHeight / 2;
                return FlSpot(index, normalizedValue);
              }).toList(),
              isCurved: true,
              color: CareSyncDesignSystem.primaryTeal,
              barWidth: 2,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: CareSyncDesignSystem.primaryTeal.withAlpha(
                  (0.1 * 255).round(),
                ),
              ),
            ),
          ],
          minY: 0,
          maxY: maxChartHeight,
        ),
      ),
    );
  }
}
