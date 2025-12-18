import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/appointment_provider.dart';

class AppointmentSchedulingScreen extends ConsumerStatefulWidget {
  const AppointmentSchedulingScreen({super.key});

  @override
  ConsumerState<AppointmentSchedulingScreen> createState() =>
      _AppointmentSchedulingScreenState();
}

class _AppointmentSchedulingScreenState
    extends ConsumerState<AppointmentSchedulingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _doctorSpecialtyController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isReminderSet = true;
  int _reminderHoursBefore = 1;
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      dateTime: dateTime,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      doctorName: _doctorNameController.text.trim().isEmpty
          ? null
          : _doctorNameController.text.trim(),
      doctorSpecialty: _doctorSpecialtyController.text.trim().isEmpty
          ? null
          : _doctorSpecialtyController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      isReminderSet: _isReminderSet,
      reminderTime: _isReminderSet
          ? dateTime.subtract(Duration(hours: _reminderHoursBefore))
          : null,
    );

    ref.read(appointmentProvider.notifier).addAppointment(appointment);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment scheduled successfully!'),
          backgroundColor: CareSyncDesignSystem.successEmerald,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _doctorNameController.dispose();
    _doctorSpecialtyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: CareSyncDesignSystem.textPrimary,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          'Schedule Appointment',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideY(begin: -0.2, end: 0, duration: 300.ms),
                  SizedBox(height: 32.h),
                  // Title
                  Text(
                    'Title *',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BentoCard(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Annual Checkup',
                        prefixIcon: Icon(
                          Icons.event,
                          color: CareSyncDesignSystem.primaryTeal,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter appointment title';
                        }
                        return null;
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 100.ms),
                  SizedBox(height: 16.h),
                  // Date & Time
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date *',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: _selectDate,
                              child: BentoCard(
                                padding: EdgeInsets.all(16.w),
                                backgroundColor:
                                    Colors.white.withAlpha((0.9 * 255).round()),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: CareSyncDesignSystem.primaryTeal,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: CareSyncDesignSystem.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time *',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            GestureDetector(
                              onTap: _selectTime,
                              child: BentoCard(
                                padding: EdgeInsets.all(16.w),
                                backgroundColor:
                                    Colors.white.withAlpha((0.9 * 255).round()),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: CareSyncDesignSystem.primaryTeal,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        _selectedTime.format(context),
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: CareSyncDesignSystem.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 16.h),
                  // Location
                  Text(
                    'Location',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BentoCard(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'e.g., City Medical Center',
                        prefixIcon: Icon(
                          Icons.location_on,
                          color: CareSyncDesignSystem.primaryTeal,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Doctor Name
                  Text(
                    'Doctor Name',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BentoCard(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                    child: TextFormField(
                      controller: _doctorNameController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Dr. Smith',
                        prefixIcon: Icon(
                          Icons.person,
                          color: CareSyncDesignSystem.primaryTeal,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Doctor Specialty
                  Text(
                    'Specialty',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BentoCard(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                    child: TextFormField(
                      controller: _doctorSpecialtyController,
                      decoration: InputDecoration(
                        hintText: 'e.g., General Medicine',
                        prefixIcon: Icon(
                          Icons.medical_services,
                          color: CareSyncDesignSystem.primaryTeal,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Description
                  Text(
                    'Description',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BentoCard(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                    child: TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add appointment details...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: Icon(
                            Icons.description,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Reminder Settings
                  BentoCard(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.notifications,
                                  size: 20.sp,
                                  color: CareSyncDesignSystem.primaryTeal,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Set Reminder',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: CareSyncDesignSystem.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _isReminderSet,
                              onChanged: (value) {
                                setState(() {
                                  _isReminderSet = value;
                                });
                              },
                              activeColor: CareSyncDesignSystem.primaryTeal,
                            ),
                          ],
                        ),
                        if (_isReminderSet) ...[
                          SizedBox(height: 16.h),
                          Text(
                            'Remind me',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [1, 2, 3, 6, 12, 24].map((hours) {
                              final isSelected = _reminderHoursBefore == hours;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _reminderHoursBefore = hours;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: hours != 24 ? 4.w : 0,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8.h),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? CareSyncDesignSystem.primaryTeal
                                              .withAlpha((0.1 * 255).round())
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? CareSyncDesignSystem.primaryTeal
                                            : CareSyncDesignSystem.textSecondary
                                                .withAlpha((0.2 * 255).round()),
                                      ),
                                    ),
                                    child: Text(
                                      hours < 24 ? '${hours}h' : '1d',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        fontSize: 12.sp,
                                        color: isSelected
                                            ? CareSyncDesignSystem.primaryTeal
                                            : CareSyncDesignSystem.textPrimary,
                                        fontWeight:
                                            isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Notes
                  Text(
                    'Additional Notes',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BentoCard(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add any additional notes...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: Icon(
                            Icons.note,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  // Submit Button
                  CareSyncButton(
                    text: 'Schedule Appointment',
                    icon: Icons.check,
                    onPressed: _submitAppointment,
                    isLoading: _isLoading,
                    width: double.infinity,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 300.ms, delay: 400.ms),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

