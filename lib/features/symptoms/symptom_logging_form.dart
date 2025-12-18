import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/symptom_provider.dart';

class SymptomLoggingForm extends ConsumerStatefulWidget {
  const SymptomLoggingForm({super.key});

  @override
  ConsumerState<SymptomLoggingForm> createState() => _SymptomLoggingFormState();
}

class _SymptomLoggingFormState extends ConsumerState<SymptomLoggingForm> {
  final _formKey = GlobalKey<FormState>();
  final _symptomController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();
  
  String? _selectedSeverity;
  final List<String> _selectedTags = [];
  bool _isLoading = false;

  final List<String> _severityOptions = ['Mild', 'Moderate', 'Severe'];
  final List<String> _commonSymptoms = [
    'Headache',
    'Nausea',
    'Dizziness',
    'Fatigue',
    'Pain',
    'Fever',
    'Cough',
    'Shortness of breath',
    'Chest pain',
    'Joint pain',
  ];

  final List<String> _bodyLocations = [
    'Head',
    'Neck',
    'Chest',
    'Back',
    'Abdomen',
    'Arms',
    'Legs',
    'Joints',
    'General',
  ];

  @override
  void dispose() {
    _symptomController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitSymptom() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSeverity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select severity'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final symptom = SymptomEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symptom: _symptomController.text.trim(),
      severity: _selectedSeverity!,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      timestamp: DateTime.now(),
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      tags: _selectedTags.isEmpty ? null : List.from(_selectedTags),
    );

    ref.read(symptomProvider.notifier).addSymptom(symptom);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Symptom logged successfully!'),
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
                          'Log Symptom',
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
                  // Symptom Input
                  Text(
                    'Symptom',
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
                      controller: _symptomController,
                      decoration: InputDecoration(
                        hintText: 'Enter symptom name',
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a symptom';
                        }
                        return null;
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 100.ms),
                  SizedBox(height: 12.h),
                  // Quick Select Symptoms
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _commonSymptoms.map((symptom) {
                      final isSelected = _symptomController.text == symptom;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _symptomController.text = symptom;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? CareSyncDesignSystem.primaryTeal.withAlpha(
                                    (0.1 * 255).round(),
                                  )
                                : Colors.white.withAlpha((0.9 * 255).round()),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? CareSyncDesignSystem.primaryTeal
                                  : CareSyncDesignSystem.textSecondary.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                            ),
                          ),
                          child: Text(
                            symptom,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: isSelected
                                  ? CareSyncDesignSystem.primaryTeal
                                  : CareSyncDesignSystem.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  // Severity Selection
                  Text(
                    'Severity',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: _severityOptions.map((severity) {
                      final isSelected = _selectedSeverity == severity;
                      Color severityColor;
                      switch (severity) {
                        case 'Mild':
                          severityColor = CareSyncDesignSystem.successEmerald;
                          break;
                        case 'Moderate':
                          severityColor = CareSyncDesignSystem.softCoral;
                          break;
                        case 'Severe':
                          severityColor = CareSyncDesignSystem.alertRed;
                          break;
                        default:
                          severityColor = CareSyncDesignSystem.textSecondary;
                      }
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSeverity = severity;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: severity != _severityOptions.last ? 8.w : 0,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? severityColor.withAlpha((0.1 * 255).round())
                                  : Colors.white.withAlpha((0.9 * 255).round()),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? severityColor
                                    : CareSyncDesignSystem.textSecondary.withAlpha(
                                        (0.2 * 255).round(),
                                      ),
                                width: isSelected ? 2.w : 1.w,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 24.sp,
                                  color: severityColor,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  severity,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                    color: isSelected
                                        ? severityColor
                                        : CareSyncDesignSystem.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 24.h),
                  // Body Location
                  Text(
                    'Body Location (Optional)',
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
                    children: _bodyLocations.map((location) {
                      final isSelected = _locationController.text == location;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _locationController.text = location;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? CareSyncDesignSystem.primaryTeal.withAlpha(
                                    (0.1 * 255).round(),
                                  )
                                : Colors.white.withAlpha((0.9 * 255).round()),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? CareSyncDesignSystem.primaryTeal
                                  : CareSyncDesignSystem.textSecondary.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                            ),
                          ),
                          child: Text(
                            location,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: isSelected
                                  ? CareSyncDesignSystem.primaryTeal
                                  : CareSyncDesignSystem.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  // Notes
                  Text(
                    'Additional Notes (Optional)',
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
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Add any additional details...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 60.h),
                          child: Icon(
                            Icons.note,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.w),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 300.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 300.ms),
                  SizedBox(height: 32.h),
                  // Submit Button
                  CareSyncButton(
                    text: 'Log Symptom',
                    icon: Icons.check,
                    onPressed: _submitSymptom,
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

