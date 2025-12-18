import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/household_provider.dart';
import '../../../../core/providers/caregiver_provider.dart';
import 'patient_history_screen.dart';
import 'add_medication_screen.dart';
import 'assign_caregiver_screen.dart';

/// Patient Detail Screen - Full view of patient information
class PatientDetailScreen extends ConsumerWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for patient updates
    final household = ref.watch(householdProvider);
    final currentPatient = household.patients.firstWhere(
      (p) => p.id == patient.id,
      orElse: () => patient,
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _PatientHeader(patient: currentPatient),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status & Location Card
                      _StatusLocationCard(patient: currentPatient),
                      SizedBox(height: 16.h),
                      // Vitals Trends Section
                      _VitalsTrendsSection(patient: currentPatient),
                      SizedBox(height: 16.h),
                      // Medications Section
                      _MedicationsSection(patient: currentPatient),
                      SizedBox(height: 16.h),
                      // Caregivers Section
                      _CaregiversSection(patient: currentPatient),
                      SizedBox(height: 16.h),
                      // Quick Actions
                      _QuickActionsSection(patient: currentPatient),
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
}

/// Patient Header with Avatar and Name
class _PatientHeader extends StatelessWidget {
  final Patient patient;

  const _PatientHeader({required this.patient});

  Color _getStatusColor() {
    switch (patient.status) {
      case PatientStatus.critical:
        return CareSyncDesignSystem.alertRed;
      case PatientStatus.lowStock:
        return CareSyncDesignSystem.softCoral;
      case PatientStatus.stable:
        return CareSyncDesignSystem.successEmerald;
    }
  }

  String _getStatusText() {
    switch (patient.status) {
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
              // Avatar
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getStatusColor(),
                      _getStatusColor().withAlpha((0.7 * 255).round()),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor().withAlpha((0.3 * 255).round()),
                      blurRadius: 12.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: patient.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          patient.avatarUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: CareSyncDesignSystem.surfaceWhite,
                        size: 32.sp,
                      ),
              ),
              SizedBox(width: 16.w),
              // Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withAlpha((0.2 * 255).round()),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
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

/// Status & Location Card
class _StatusLocationCard extends StatelessWidget {
  final Patient patient;

  const _StatusLocationCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    return BentoCard(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              // Geofence Status
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      patient.isHome ? Icons.home : Icons.location_on_outlined,
                      size: 32.sp,
                      color: patient.isHome
                          ? CareSyncDesignSystem.successEmerald
                          : CareSyncDesignSystem.textSecondary,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      patient.isHome ? 'At Home' : 'Away',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Last updated: ${_formatTime(patient.lastVitalsUpdate)}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1.w,
                height: 60.h,
                color: CareSyncDesignSystem.textSecondary.withAlpha(
                  (0.2 * 255).round(),
                ),
              ),
              // Health Summary
              Expanded(
                child: Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 32.sp,
                      color: CareSyncDesignSystem.alertRed,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Vitals',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      patient.vitalTrends.isNotEmpty
                          ? '${patient.vitalTrends.last.heartRate ?? '--'} bpm'
                          : 'No data',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
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
        .fadeIn(duration: 300.ms, delay: 100.ms)
        .slideX(begin: -0.1, end: 0, duration: 300.ms, delay: 100.ms);
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Vitals Trends Section with Full Chart
class _VitalsTrendsSection extends StatelessWidget {
  final Patient patient;

  const _VitalsTrendsSection({required this.patient});

  @override
  Widget build(BuildContext context) {
    if (patient.vitalTrends.isEmpty) {
      return BentoCard(
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.show_chart,
                size: 48.sp,
                color: CareSyncDesignSystem.textSecondary.withAlpha(
                  (0.5 * 255).round(),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'No vitals data available',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: CareSyncDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BentoCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '7-Day Vitals Trend',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CareSyncDesignSystem.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 200.h,
                child: _FullTrendChart(patient: patient),
              ),
              SizedBox(height: 16.h),
              // Vitals Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _VitalSummaryItem(
                    label: 'Heart Rate',
                    value: patient.vitalTrends.last.heartRate != null
                        ? '${patient.vitalTrends.last.heartRate} bpm'
                        : '--',
                    icon: Icons.favorite,
                    color: CareSyncDesignSystem.alertRed,
                  ),
                  _VitalSummaryItem(
                    label: 'Blood Pressure',
                    value: patient.vitalTrends.last.bloodPressure ?? '--',
                    icon: Icons.monitor_heart,
                    color: CareSyncDesignSystem.primaryTeal,
                  ),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 200.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 200.ms);
  }
}

/// Full Trend Chart Widget
class _FullTrendChart extends StatelessWidget {
  final Patient patient;

  const _FullTrendChart({required this.patient});

  @override
  Widget build(BuildContext context) {
    final heartRateData = patient.vitalTrends
        .map((t) => t.heartRate?.toDouble() ?? 0.0)
        .where((v) => v > 0)
        .toList();

    if (heartRateData.isEmpty) {
      return const SizedBox.shrink();
    }

    final minValue = heartRateData.reduce((a, b) => a < b ? a : b);
    final maxValue = heartRateData.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final padding = range > 0 ? range * 0.1 : 10.0; // Add 10% padding
    final chartMinY = (minValue - padding).clamp(0.0, double.infinity);
    final chartMaxY = maxValue + padding;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: range > 0 ? range / 4 : 10,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: CareSyncDesignSystem.textSecondary.withAlpha(
                (0.1 * 255).round(),
              ),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= patient.vitalTrends.length ||
                    value.toInt() < 0) {
                  return const Text('');
                }
                final date = patient.vitalTrends[value.toInt()].date;
                return Text(
                  '${date.day}/${date.month}',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(
              color: CareSyncDesignSystem.textSecondary.withAlpha(
                (0.2 * 255).round(),
              ),
            ),
            left: BorderSide(
              color: CareSyncDesignSystem.textSecondary.withAlpha(
                (0.2 * 255).round(),
              ),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: heartRateData.asMap().entries.map((entry) {
              final index = entry.key.toDouble();
              final value = entry.value;
              return FlSpot(index, value);
            }).toList(),
            isCurved: true,
            color: CareSyncDesignSystem.primaryTeal,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: CareSyncDesignSystem.primaryTeal,
                  strokeWidth: 2,
                  strokeColor: CareSyncDesignSystem.surfaceWhite,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: CareSyncDesignSystem.primaryTeal.withAlpha(
                (0.1 * 255).round(),
              ),
            ),
          ),
        ],
        minY: chartMinY,
        maxY: chartMaxY,
      ),
    );
  }
}

/// Vital Summary Item
class _VitalSummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _VitalSummaryItem({
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
            fontSize: 18.sp,
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

/// Medications Section
class _MedicationsSection extends StatelessWidget {
  final Patient patient;

  const _MedicationsSection({required this.patient});

  @override
  Widget build(BuildContext context) {
    if (patient.medications.isEmpty) {
      return BentoCard(
        padding: EdgeInsets.all(20.w),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.medication,
                size: 48.sp,
                color: CareSyncDesignSystem.textSecondary.withAlpha(
                  (0.5 * 255).round(),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'No medications',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: CareSyncDesignSystem.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return BentoCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Medications',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${patient.medications.length} total',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddMedicationScreen(patient: patient),
                            ),
                          );
                        },
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                          child: Icon(
                            Icons.add,
                            color: CareSyncDesignSystem.surfaceWhite,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...patient.medications.map((med) {
                final isLowStock = med.daysRemaining < 3;
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? CareSyncDesignSystem.alertRed.withAlpha(
                            (0.1 * 255).round(),
                          )
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isLowStock
                        ? Border.all(
                            color: CareSyncDesignSystem.alertRed.withAlpha(
                              (0.3 * 255).round(),
                            ),
                            width: 1.w,
                          )
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.medication,
                        size: 24.sp,
                        color: isLowStock
                            ? CareSyncDesignSystem.alertRed
                            : CareSyncDesignSystem.primaryTeal,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.name,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              '${med.daysRemaining} days remaining',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: isLowStock
                                    ? CareSyncDesignSystem.alertRed
                                    : CareSyncDesignSystem.textSecondary,
                                fontWeight: isLowStock
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isLowStock)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: CareSyncDesignSystem.alertRed,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Low',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.surfaceWhite,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 300.ms);
  }
}

/// Caregivers Section
class _CaregiversSection extends ConsumerWidget {
  final Patient patient;

  const _CaregiversSection({required this.patient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedCaregivers = ref
        .read(caregiverProvider.notifier)
        .getCaregiversForPatient(patient.id);

    return BentoCard(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assigned Caregivers',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignCaregiverScreen(patient: patient),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: CareSyncDesignSystem.primaryTeal.withAlpha(
                          (0.1 * 255).round(),
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_add,
                            size: 16.sp,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Manage',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: CareSyncDesignSystem.primaryTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (assignedCaregivers.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48.sp,
                        color: CareSyncDesignSystem.textSecondary.withAlpha(
                          (0.5 * 255).round(),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No caregivers assigned',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...assignedCaregivers.map((caregiver) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: CareSyncDesignSystem.primaryTeal.withAlpha(
                        (0.1 * 255).round(),
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                CareSyncDesignSystem.primaryTeal,
                                CareSyncDesignSystem.primaryTeal.withAlpha(
                                  (0.7 * 255).round(),
                                ),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: CareSyncDesignSystem.surfaceWhite,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                caregiver.name,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: CareSyncDesignSystem.textPrimary,
                                ),
                              ),
                              if (caregiver.email != null) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  caregiver.email!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: CareSyncDesignSystem.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 400.ms);
  }
}

/// Quick Actions Section
class _QuickActionsSection extends StatelessWidget {
  final Patient patient;

  const _QuickActionsSection({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: CareSyncDesignSystem.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CareSyncButton(
                    text: 'Call',
                    icon: Icons.phone,
                    onPressed: () {
                      // TODO: Implement phone call
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${patient.name}...'),
                          backgroundColor: CareSyncDesignSystem.primaryTeal,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CareSyncButton(
                    text: 'Message',
                    icon: Icons.message,
                    isOutlined: true,
                    onPressed: () {
                      // TODO: Implement messaging
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Opening messages...'),
                          backgroundColor: CareSyncDesignSystem.primaryTeal,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CareSyncButton(
                    text: 'Add Medication',
                    icon: Icons.medication,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddMedicationScreen(patient: patient),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CareSyncButton(
                    text: 'Assign Caregiver',
                    icon: Icons.person_add,
                    isOutlined: true,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              AssignCaregiverScreen(patient: patient),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            CareSyncButton(
              text: 'View Full History',
              icon: Icons.history,
              width: double.infinity,
              isOutlined: true,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PatientHistoryScreen(patient: patient),
                  ),
                );
              },
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 300.ms, delay: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 300.ms, delay: 400.ms);
  }
}
