import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/caresync_design_system.dart';
import '../appointments/appointment_scheduling_screen.dart';
import '../../core/providers/appointment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Schedule Screen - View and manage appointments
class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentState = ref.watch(appointmentProvider);
    final appointments = appointmentState.appointments;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Schedule',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: CareSyncDesignSystem.primaryTeal,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AppointmentSchedulingScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Appointments List
              Expanded(
                child: appointments.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 64.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No appointments scheduled',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Tap + to add an appointment',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: CareSyncDesignSystem.textSecondary
                                    .withAlpha((0.7 * 255).round()),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16.w),
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            color: Colors.white.withAlpha((0.9 * 255).round()),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16.w),
                              leading: Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: BoxDecoration(
                                  color: CareSyncDesignSystem.primaryTeal
                                      .withAlpha((0.1 * 255).round()),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.event,
                                  color: CareSyncDesignSystem.primaryTeal,
                                  size: 28.sp,
                                ),
                              ),
                              title: Text(
                                appointment.title,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: CareSyncDesignSystem.textPrimary,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4.h),
                                  Text(
                                    appointment.description ?? 'No description',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.sp,
                                      color: CareSyncDesignSystem.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 14.sp,
                                        color:
                                            CareSyncDesignSystem.textSecondary,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        '${appointment.dateTime.day}/${appointment.dateTime.month}/${appointment.dateTime.year} at ${appointment.dateTime.hour}:${appointment.dateTime.minute.toString().padLeft(2, '0')}',
                                        style: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          color: CareSyncDesignSystem
                                              .textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
