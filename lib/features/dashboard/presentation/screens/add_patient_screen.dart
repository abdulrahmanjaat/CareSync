import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/household_provider.dart';
import 'manager_medication_entry_form.dart';

/// Add Patient Screen - Form to add a new patient
class AddPatientScreen extends ConsumerStatefulWidget {
  const AddPatientScreen({super.key});

  @override
  ConsumerState<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends ConsumerState<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  PatientStatus _selectedStatus = PatientStatus.stable;
  bool _isHome = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final patientName = _nameController.text.trim();
      final household = ref.read(householdProvider);

      // Check if patient already exists
      final existingPatient = household.patients.firstWhere(
        (p) => p.name.toLowerCase() == patientName.toLowerCase(),
        orElse: () => Patient(id: '', name: '', status: PatientStatus.stable),
      );

      if (existingPatient.id.isNotEmpty) {
        // Patient already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Patient "$patientName" already exists'),
            backgroundColor: CareSyncDesignSystem.alertRed,
          ),
        );
        return;
      }

      // Create new patient
      final newPatient = Patient(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: patientName,
        status: _selectedStatus,
        isHome: _isHome,
        vitalTrends: [],
        medications: [],
      );

      // Add patient
      ref.read(householdProvider.notifier).addPatient(newPatient);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newPatient.name} added successfully'),
          backgroundColor: CareSyncDesignSystem.successEmerald,
        ),
      );

      // Navigate to medication entry form
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ManagerMedicationEntryForm(patient: newPatient),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
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
                              'Add Patient',
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
                  // Name Field
                  Text(
                    'Patient Name',
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
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter patient name',
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
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter patient name';
                            }
                            return null;
                          },
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideX(
                        begin: -0.1,
                        end: 0,
                        duration: 300.ms,
                        delay: 100.ms,
                      ),
                  SizedBox(height: 24.h),
                  // Status Selection
                  Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                        children: [
                          Expanded(
                            child: _StatusOption(
                              status: PatientStatus.stable,
                              label: 'Stable',
                              isSelected:
                                  _selectedStatus == PatientStatus.stable,
                              onTap: () {
                                setState(() {
                                  _selectedStatus = PatientStatus.stable;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatusOption(
                              status: PatientStatus.lowStock,
                              label: 'Low Stock',
                              isSelected:
                                  _selectedStatus == PatientStatus.lowStock,
                              onTap: () {
                                setState(() {
                                  _selectedStatus = PatientStatus.lowStock;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatusOption(
                              status: PatientStatus.critical,
                              label: 'Critical',
                              isSelected:
                                  _selectedStatus == PatientStatus.critical,
                              onTap: () {
                                setState(() {
                                  _selectedStatus = PatientStatus.critical;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideX(
                        begin: -0.1,
                        end: 0,
                        duration: 300.ms,
                        delay: 200.ms,
                      ),
                  SizedBox(height: 24.h),
                  // Location Toggle
                  Text(
                    'Location',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  BentoCard(
                        padding: EdgeInsets.all(16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isHome
                                      ? Icons.home
                                      : Icons.location_on_outlined,
                                  color: _isHome
                                      ? CareSyncDesignSystem.successEmerald
                                      : CareSyncDesignSystem.textSecondary,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  _isHome ? 'At Home' : 'Away',
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: CareSyncDesignSystem.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _isHome,
                              onChanged: (value) {
                                setState(() {
                                  _isHome = value;
                                });
                              },
                              activeColor: CareSyncDesignSystem.successEmerald,
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 300.ms)
                      .slideX(
                        begin: -0.1,
                        end: 0,
                        duration: 300.ms,
                        delay: 300.ms,
                      ),
                  SizedBox(height: 32.h),
                  // Submit Button
                  CareSyncButton(
                        text: 'Add Patient',
                        icon: Icons.person_add,
                        onPressed: _submitForm,
                        width: double.infinity,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 400.ms)
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        duration: 300.ms,
                        delay: 400.ms,
                      ),
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

class _StatusOption extends StatelessWidget {
  final PatientStatus status;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOption({
    required this.status,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case PatientStatus.critical:
        return CareSyncDesignSystem.alertRed;
      case PatientStatus.lowStock:
        return CareSyncDesignSystem.softCoral;
      case PatientStatus.stable:
        return CareSyncDesignSystem.successEmerald;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BentoCard(
        padding: EdgeInsets.all(16.w),
        backgroundColor: isSelected
            ? _getStatusColor().withAlpha((0.1 * 255).round())
            : null,
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? _getStatusColor()
                    : _getStatusColor().withAlpha((0.2 * 255).round()),
              ),
              child: Icon(
                Icons.check,
                color: isSelected
                    ? CareSyncDesignSystem.surfaceWhite
                    : _getStatusColor(),
                size: 20.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? _getStatusColor()
                    : CareSyncDesignSystem.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
