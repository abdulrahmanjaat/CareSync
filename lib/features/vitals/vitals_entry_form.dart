import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/vitals_provider.dart';

class VitalsEntryForm extends ConsumerStatefulWidget {
  const VitalsEntryForm({super.key});

  @override
  ConsumerState<VitalsEntryForm> createState() => _VitalsEntryFormState();
}

class _VitalsEntryFormState extends ConsumerState<VitalsEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _heartRateController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();
  final _glucoseController = TextEditingController();
  final _oxygenController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _heartRateController.dispose();
    _bloodPressureController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _glucoseController.dispose();
    _oxygenController.dispose();
    super.dispose();
  }

  Future<void> _submitVitals() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Parse and save vitals
    final heartRate = int.tryParse(_heartRateController.text);
    final bloodPressure = _bloodPressureController.text.trim();
    final temperature = double.tryParse(_temperatureController.text);
    final weight = double.tryParse(_weightController.text);

    // Parse glucose and oxygen
    final glucose = double.tryParse(_glucoseController.text);
    final oxygenSaturation = int.tryParse(_oxygenController.text);

    // Save to provider
    ref
        .read(vitalsProvider.notifier)
        .saveVitals(
          heartRate: heartRate,
          bloodPressure: bloodPressure.isNotEmpty ? bloodPressure : null,
          temperature: temperature,
          weight: weight,
          glucose: glucose,
          oxygenSaturation: oxygenSaturation,
        );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vitals logged successfully!'),
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
                              'Log Vitals',
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
                  // Heart Rate
                  _VitalInputField(
                        label: 'Heart Rate',
                        icon: Icons.favorite,
                        controller: _heartRateController,
                        unit: 'bpm',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter heart rate';
                          }
                          final rate = int.tryParse(value);
                          if (rate == null || rate < 40 || rate > 200) {
                            return 'Enter a valid heart rate (40-200)';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 100.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Blood Pressure
                  _VitalInputField(
                        label: 'Blood Pressure',
                        icon: Icons.monitor_heart,
                        controller: _bloodPressureController,
                        unit: 'mmHg',
                        hint: '120/80',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter blood pressure';
                          }
                          if (!value.contains('/')) {
                            return 'Format: systolic/diastolic (e.g., 120/80)';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 200.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Temperature
                  _VitalInputField(
                        label: 'Temperature',
                        icon: Icons.thermostat,
                        controller: _temperatureController,
                        unit: '°F',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter temperature';
                          }
                          final temp = double.tryParse(value);
                          if (temp == null || temp < 90 || temp > 110) {
                            return 'Enter a valid temperature (90-110°F)';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 300.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 300.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Weight
                  _VitalInputField(
                        label: 'Weight',
                        icon: Icons.monitor_weight,
                        controller: _weightController,
                        unit: 'lbs',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null || weight < 50 || weight > 500) {
                            return 'Enter a valid weight (50-500 lbs)';
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 400.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 400.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Glucose (Blood Sugar)
                  _VitalInputField(
                        label: 'Blood Glucose',
                        icon: Icons.cake,
                        controller: _glucoseController,
                        unit: 'mg/dL',
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final glucose = double.tryParse(value);
                            if (glucose == null ||
                                glucose < 50 ||
                                glucose > 500) {
                              return 'Enter a valid glucose (50-500 mg/dL)';
                            }
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 500.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 500.ms,
                      ),
                  SizedBox(height: 16.h),
                  // Oxygen Saturation
                  _VitalInputField(
                        label: 'Oxygen Saturation',
                        icon: Icons.air,
                        controller: _oxygenController,
                        unit: '%',
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final oxygen = int.tryParse(value);
                            if (oxygen == null || oxygen < 70 || oxygen > 100) {
                              return 'Enter a valid SpO2 (70-100%)';
                            }
                          }
                          return null;
                        },
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 600.ms)
                      .slideX(
                        begin: -0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 600.ms,
                      ),
                  SizedBox(height: 32.h),
                  // Submit Button
                  CareSyncButton(
                        text: 'Save Vitals',
                        onPressed: _submitVitals,
                        isLoading: _isLoading,
                        width: double.infinity,
                      )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 700.ms)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 300.ms,
                        delay: 700.ms,
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

class _VitalInputField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String unit;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const _VitalInputField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.unit,
    this.hint,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      padding: EdgeInsets.zero,
      backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.number,
        validator: validator,
        style: GoogleFonts.inter(
          fontSize: 16.sp,
          color: CareSyncDesignSystem.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: unit,
          prefixIcon: Icon(icon, color: CareSyncDesignSystem.primaryTeal),
          border: InputBorder.none,
          labelStyle: GoogleFonts.inter(
            color: CareSyncDesignSystem.textSecondary,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}
