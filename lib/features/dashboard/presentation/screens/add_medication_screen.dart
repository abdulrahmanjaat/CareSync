import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/household_provider.dart';
import '../../../../core/providers/medication_provider.dart';
import '../../../../core/widgets/responsive_icon.dart';

/// Add Medication Screen - Full medication form (same as patient dashboard)
class AddMedicationScreen extends ConsumerStatefulWidget {
  final Patient patient;

  const AddMedicationScreen({super.key, required this.patient});

  @override
  ConsumerState<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _daysRemainingController = TextEditingController();

  String _selectedType = 'Tablet';
  List<String> _selectedDays = [];
  List<TimeOfDay> _selectedTimes = [];
  String _foodTiming = 'After';

  final List<String> _medicationTypes = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Drops',
    'Inhaler',
  ];

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _foodTimings = ['Before', 'With', 'After'];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _daysRemainingController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes.length > index
          ? _selectedTimes[index]
          : TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: CareSyncDesignSystem.primaryTeal,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (_selectedTimes.length > index) {
          _selectedTimes[index] = picked;
        } else {
          _selectedTimes.add(picked);
        }
      });
    }
  }

  void _addTimeSlot() {
    setState(() {
      _selectedTimes.add(TimeOfDay.now());
    });
  }

  void _removeTimeSlot(int index) {
    setState(() {
      _selectedTimes.removeAt(index);
    });
  }

  void _toggleDay(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  Future<void> _saveMedication() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one day'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    if (_selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please add at least one time slot'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    if (_daysRemainingController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter days remaining'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    final daysRemaining = int.tryParse(_daysRemainingController.text.trim());
    if (daysRemaining == null || daysRemaining < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid number for days remaining'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    // Create full Medication object (for medicationProvider)
    final medication = Medication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      type: _selectedType,
      dosage: _dosageController.text.trim(),
      frequency: _selectedDays,
      times: _selectedTimes
          .map((t) => '${t.hour}:${t.minute.toString().padLeft(2, '0')}')
          .toList(),
      foodTiming: _foodTiming,
      createdAt: DateTime.now(),
    );

    // Add to medicationProvider (for patient dashboard timeline)
    ref.read(medicationProvider.notifier).addMedication(medication);

    // Create MedicationInventory for patient's medication list
    final medicationInventory = MedicationInventory(
      id: medication.id,
      name: medication.name,
      daysRemaining: daysRemaining,
    );

    // Update patient with new medication inventory
    final updatedMedications = [
      ...widget.patient.medications,
      medicationInventory,
    ];
    final updatedPatient = widget.patient.copyWith(
      medications: updatedMedications,
    );

    ref
        .read(householdProvider.notifier)
        .updatePatient(widget.patient.id, updatedPatient);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medication added successfully'),
          backgroundColor: CareSyncDesignSystem.successEmerald,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Medication',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'For ${widget.patient.name}',
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
                ),
                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medication Name
                        Text(
                          'Medication Name',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        BentoCard(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white.withAlpha(
                            (0.9 * 255).round(),
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter medication name';
                              }
                              return null;
                            },
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g., Aspirin',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Medication Type
                        Text(
                          'Type',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        BentoCard(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          backgroundColor: Colors.white.withAlpha(
                            (0.9 * 255).round(),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedType,
                            isExpanded: true,
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            items: _medicationTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Row(
                                  children: [
                                    ResponsiveIcon(
                                      icon: _getTypeIcon(type),
                                      size: 20,
                                      color: CareSyncDesignSystem.primaryTeal,
                                    ),
                                    SizedBox(width: 12.w),
                                    Text(
                                      type,
                                      style: GoogleFonts.inter(
                                        fontSize: 16.sp,
                                        color: CareSyncDesignSystem.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedType = value;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Dosage
                        Text(
                          'Dosage',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        BentoCard(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white.withAlpha(
                            (0.9 * 255).round(),
                          ),
                          child: TextFormField(
                            controller: _dosageController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter dosage';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g., 100mg, 1 tablet',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Days Remaining (Inventory)
                        Text(
                          'Days Remaining',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        BentoCard(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.white.withAlpha(
                            (0.9 * 255).round(),
                          ),
                          child: TextFormField(
                            controller: _daysRemainingController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter days remaining';
                              }
                              final days = int.tryParse(value.trim());
                              if (days == null || days < 0) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g., 7, 14, 30',
                              prefixIcon: Icon(
                                Icons.calendar_today,
                                color: CareSyncDesignSystem.primaryTeal,
                              ),
                              suffixText: 'days',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 16.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // Frequency (Days)
                        Text(
                          'Frequency (Select Days)',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: _daysOfWeek.map((day) {
                            final isSelected = _selectedDays.contains(day);
                            return GestureDetector(
                              onTap: () => _toggleDay(day),
                              child: BentoCard(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                backgroundColor: isSelected
                                    ? CareSyncDesignSystem.primaryTeal
                                          .withAlpha((0.1 * 255).round())
                                    : Colors.white.withAlpha(
                                        (0.9 * 255).round(),
                                      ),
                                child: Text(
                                  day.substring(0, 3),
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? CareSyncDesignSystem.primaryTeal
                                        : CareSyncDesignSystem.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 24.h),
                        // Time Slots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Time Slots',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _addTimeSlot,
                              icon: Icon(
                                Icons.add,
                                size: 18.sp,
                                color: CareSyncDesignSystem.primaryTeal,
                              ),
                              label: Text(
                                'Add Time',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: CareSyncDesignSystem.primaryTeal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        if (_selectedTimes.isEmpty)
                          BentoCard(
                            padding: EdgeInsets.all(20.w),
                            backgroundColor: Colors.white.withAlpha(
                              (0.5 * 255).round(),
                            ),
                            child: Center(
                              child: Text(
                                'No time slots added. Tap "Add Time" to add one.',
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: CareSyncDesignSystem.textSecondary,
                                ),
                              ),
                            ),
                          )
                        else
                          ...List.generate(_selectedTimes.length, (index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: BentoCard(
                                padding: EdgeInsets.all(16.w),
                                backgroundColor: Colors.white.withAlpha(
                                  (0.9 * 255).round(),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => _selectTime(index),
                                        child: Row(
                                          children: [
                                            ResponsiveIcon(
                                              icon: Icons.access_time,
                                              size: 20,
                                              color: CareSyncDesignSystem
                                                  .primaryTeal,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              _selectedTimes[index].format(
                                                context,
                                              ),
                                              style: GoogleFonts.inter(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                                color: CareSyncDesignSystem
                                                    .textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_selectedTimes.length > 1)
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: CareSyncDesignSystem.alertRed,
                                        ),
                                        onPressed: () => _removeTimeSlot(index),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        SizedBox(height: 24.h),
                        // Food Timing
                        Text(
                          'Food Timing',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: _foodTimings.map((timing) {
                            final isSelected = _foodTiming == timing;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _foodTiming = timing;
                                    });
                                  },
                                  child: BentoCard(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    backgroundColor: isSelected
                                        ? CareSyncDesignSystem.primaryTeal
                                              .withAlpha((0.1 * 255).round())
                                        : Colors.white.withAlpha(
                                            (0.9 * 255).round(),
                                          ),
                                    child: Center(
                                      child: Text(
                                        timing,
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? CareSyncDesignSystem.primaryTeal
                                              : CareSyncDesignSystem
                                                    .textPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 32.h),
                        // Save Button
                        CareSyncButton(
                          text: 'Save Medication',
                          onPressed: _saveMedication,
                          width: double.infinity,
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Tablet':
        return Icons.medication;
      case 'Capsule':
        return Icons.circle;
      case 'Syrup':
        return Icons.local_drink;
      case 'Injection':
        return Icons.medical_services;
      case 'Drops':
        return Icons.water_drop;
      case 'Inhaler':
        return Icons.air;
      default:
        return Icons.medication;
    }
  }
}

extension TimeOfDayExtension on TimeOfDay {
  String format(BuildContext context) {
    final displayHour = hourOfPeriod == 0
        ? 12
        : hour > 12
        ? hour - 12
        : hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    return '$displayHour:$minute $period';
  }
}
