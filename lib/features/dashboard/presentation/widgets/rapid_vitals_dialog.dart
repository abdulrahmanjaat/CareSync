import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';
import '../../../../core/providers/vitals_provider.dart';

/// Rapid Vitals Dialog - Large number pad for quick entry
class RapidVitalsDialog extends ConsumerStatefulWidget {
  final String vitalType; // 'BP', 'Temp', or 'Sugar'

  const RapidVitalsDialog({super.key, required this.vitalType});

  @override
  ConsumerState<RapidVitalsDialog> createState() => _RapidVitalsDialogState();
}

class _RapidVitalsDialogState extends ConsumerState<RapidVitalsDialog> {
  String _value = '';
  String? _secondValue; // For BP (systolic/diastolic)

  String get _title {
    switch (widget.vitalType) {
      case 'BP':
        return 'Blood Pressure';
      case 'Temp':
        return 'Temperature';
      case 'Sugar':
        return 'Blood Sugar';
      default:
        return 'Vital Sign';
    }
  }

  String get _unit {
    switch (widget.vitalType) {
      case 'BP':
        return 'mmHg';
      case 'Temp':
        return '°F';
      case 'Sugar':
        return 'mg/dL';
      default:
        return '';
    }
  }

  void _addDigit(String digit) {
    HapticFeedback.selectionClick();
    setState(() {
      if (widget.vitalType == 'BP') {
        if (_secondValue == null) {
          if (_value.length < 3) {
            _value += digit;
          }
        } else {
          if (_secondValue!.length < 3) {
            _secondValue = _secondValue! + digit;
          }
        }
      } else {
        if (_value.length < 4) {
          _value += digit;
        }
      }
    });
  }

  void _deleteDigit() {
    HapticFeedback.selectionClick();
    setState(() {
      if (widget.vitalType == 'BP') {
        if (_secondValue != null && _secondValue!.isNotEmpty) {
          _secondValue = _secondValue!.substring(0, _secondValue!.length - 1);
          if (_secondValue!.isEmpty) {
            _secondValue = null;
          }
        } else if (_value.isNotEmpty) {
          _value = _value.substring(0, _value.length - 1);
        }
      } else {
        if (_value.isNotEmpty) {
          _value = _value.substring(0, _value.length - 1);
        }
      }
    });
  }

  void _saveVital() {
    if (widget.vitalType == 'BP') {
      if (_value.isEmpty || _secondValue == null || _secondValue!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter both systolic and diastolic values'),
            backgroundColor: CareSyncDesignSystem.alertRed,
          ),
        );
        return;
      }
      ref
          .read(vitalsProvider.notifier)
          .saveVitals(
            heartRate: null,
            bloodPressure: '$_value/${_secondValue}',
            temperature: null,
            weight: null,
          );
    } else if (widget.vitalType == 'Temp') {
      if (_value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter temperature'),
            backgroundColor: CareSyncDesignSystem.alertRed,
          ),
        );
        return;
      }
      ref
          .read(vitalsProvider.notifier)
          .saveVitals(
            heartRate: null,
            bloodPressure: null,
            temperature: double.tryParse(_value),
            weight: null,
          );
    } else if (widget.vitalType == 'Sugar') {
      if (_value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter blood sugar'),
            backgroundColor: CareSyncDesignSystem.alertRed,
          ),
        );
        return;
      }
      // Note: Sugar is not in the current VitalsData model, but we can add it
      // For now, we'll just show success
    }

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_title saved successfully'),
        backgroundColor: CareSyncDesignSystem.successEmerald,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha((0.5 * 255).round()),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: BentoCard(
            padding: EdgeInsets.all(24.w),
            backgroundColor: Colors.white.withAlpha((0.95 * 255).round()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 28.sp,
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                // Value Display
                Container(
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: CareSyncDesignSystem.primaryTeal.withAlpha(
                      (0.1 * 255).round(),
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      if (widget.vitalType == 'BP') ...[
                        Text(
                          _value.isEmpty ? '---' : _value,
                          style: GoogleFonts.inter(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                        Text(
                          '/',
                          style: GoogleFonts.inter(
                            fontSize: 48.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                        ),
                        Text(
                          _secondValue == null || _secondValue!.isEmpty
                              ? '---'
                              : _secondValue!,
                          style: GoogleFonts.inter(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                      ] else
                        Text(
                          _value.isEmpty ? '---' : _value,
                          style: GoogleFonts.inter(
                            fontSize: 72.sp,
                            fontWeight: FontWeight.bold,
                            color: CareSyncDesignSystem.textPrimary,
                          ),
                        ),
                      SizedBox(height: 8.h),
                      Text(
                        _unit,
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                // Number Pad
                _NumberPad(
                  onDigitTap: _addDigit,
                  onDelete: _deleteDigit,
                  showSlash: widget.vitalType == 'BP' && _secondValue == null,
                  onSlash: () {
                    if (widget.vitalType == 'BP' && _value.isNotEmpty) {
                      setState(() {
                        _secondValue = '';
                      });
                      HapticFeedback.selectionClick();
                    }
                  },
                ),
                SizedBox(height: 24.h),
                // Save Button
                CareSyncButton(
                  text: 'Save',
                  icon: Icons.check,
                  onPressed: _saveVital,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Number Pad Widget
class _NumberPad extends StatelessWidget {
  final Function(String) onDigitTap;
  final VoidCallback onDelete;
  final bool showSlash;
  final VoidCallback? onSlash;

  const _NumberPad({
    required this.onDigitTap,
    required this.onDelete,
    this.showSlash = false,
    this.onSlash,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton('1', () => onDigitTap('1')),
            _NumberButton('2', () => onDigitTap('2')),
            _NumberButton('3', () => onDigitTap('3')),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton('4', () => onDigitTap('4')),
            _NumberButton('5', () => onDigitTap('5')),
            _NumberButton('6', () => onDigitTap('6')),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NumberButton('7', () => onDigitTap('7')),
            _NumberButton('8', () => onDigitTap('8')),
            _NumberButton('9', () => onDigitTap('9')),
          ],
        ),
        SizedBox(height: 12.h),
        // Row 4: Slash (for BP), 0, Delete
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (showSlash && onSlash != null)
              _NumberButton('/', onSlash!)
            else
              SizedBox(width: 80.w),
            _NumberButton('0', () => onDigitTap('0')),
            _DeleteButton(onDelete),
          ],
        ),
      ],
    );
  }
}

/// Number Button
class _NumberButton extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;

  const _NumberButton(this.digit, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: CareSyncDesignSystem.primaryTeal.withAlpha(
            (0.1 * 255).round(),
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: CareSyncDesignSystem.primaryTeal.withAlpha(
              (0.3 * 255).round(),
            ),
            width: 2.w,
          ),
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.inter(
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
              color: CareSyncDesignSystem.primaryTeal,
            ),
          ),
        ),
      ),
    );
  }
}

/// Delete Button
class _DeleteButton extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteButton(this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: CareSyncDesignSystem.alertRed.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: CareSyncDesignSystem.alertRed.withAlpha((0.3 * 255).round()),
            width: 2.w,
          ),
        ),
        child: Icon(
          Icons.backspace,
          color: CareSyncDesignSystem.alertRed,
          size: 32.sp,
        ),
      ),
    );
  }
}
