import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/widgets/caresync_button.dart';
import '../../core/providers/habit_provider.dart';

class HabitTrackingForm extends ConsumerStatefulWidget {
  final HabitType habitType;

  const HabitTrackingForm({
    super.key,
    required this.habitType,
  });

  @override
  ConsumerState<HabitTrackingForm> createState() => _HabitTrackingFormState();
}

class _HabitTrackingFormState extends ConsumerState<HabitTrackingForm> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  String get _title {
    switch (widget.habitType) {
      case HabitType.exercise:
        return 'Log Exercise';
      case HabitType.sleep:
        return 'Log Sleep';
      case HabitType.dietary:
        return 'Log Meal';
    }
  }

  String get _unit {
    switch (widget.habitType) {
      case HabitType.exercise:
        return 'minutes';
      case HabitType.sleep:
        return 'hours';
      case HabitType.dietary:
        return 'calories';
    }
  }

  IconData get _icon {
    switch (widget.habitType) {
      case HabitType.exercise:
        return Icons.fitness_center;
      case HabitType.sleep:
        return Icons.bedtime;
      case HabitType.dietary:
        return Icons.restaurant;
    }
  }

  Color get _color {
    switch (widget.habitType) {
      case HabitType.exercise:
        return CareSyncDesignSystem.successEmerald;
      case HabitType.sleep:
        return CareSyncDesignSystem.primaryTeal;
      case HabitType.dietary:
        return CareSyncDesignSystem.softCoral;
    }
  }

  List<String> get _quickOptions {
    switch (widget.habitType) {
      case HabitType.exercise:
        return ['15', '30', '45', '60', '90'];
      case HabitType.sleep:
        return ['6', '7', '8', '9', '10'];
      case HabitType.dietary:
        return ['300', '500', '700', '1000', '1500'];
    }
  }

  List<String> get _activityTypes {
    switch (widget.habitType) {
      case HabitType.exercise:
        return ['Walking', 'Running', 'Cycling', 'Swimming', 'Yoga', 'Gym', 'Other'];
      case HabitType.sleep:
        return ['Night Sleep', 'Nap', 'Rest'];
      case HabitType.dietary:
        return ['Breakfast', 'Lunch', 'Dinner', 'Snack', 'Other'];
    }
  }

  String? _selectedActivityType;

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitHabit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final value = double.tryParse(_valueController.text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid ${_unit} value'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final habit = HabitEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: widget.habitType,
      date: _selectedDate,
      value: value,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      metadata: _selectedActivityType != null
          ? {'activityType': _selectedActivityType}
          : null,
    );

    ref.read(habitProvider.notifier).addHabit(habit);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_title} logged successfully!'),
          backgroundColor: CareSyncDesignSystem.successEmerald,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
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
                          _title,
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
                  // Date Selection
                  Text(
                    'Date',
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
                      backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: _color,
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.sp,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 100.ms),
                  SizedBox(height: 24.h),
                  // Activity Type Selection
                  Text(
                    widget.habitType == HabitType.exercise
                        ? 'Exercise Type'
                        : widget.habitType == HabitType.sleep
                            ? 'Sleep Type'
                            : 'Meal Type',
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
                    children: _activityTypes.map((type) {
                      final isSelected = _selectedActivityType == type;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedActivityType = type;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _color.withAlpha((0.1 * 255).round())
                                : Colors.white.withAlpha((0.9 * 255).round()),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? _color
                                  : CareSyncDesignSystem.textSecondary.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                            ),
                          ),
                          child: Text(
                            type,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: isSelected
                                  ? _color
                                  : CareSyncDesignSystem.textPrimary,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24.h),
                  // Value Input
                  Text(
                    'Duration' +
                        (widget.habitType == HabitType.dietary ? '/Amount' : '') +
                        ' ($_unit)',
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
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter $_unit',
                        prefixIcon: Icon(
                          _icon,
                          color: _color,
                        ),
                        suffixText: _unit,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter $_unit';
                        }
                        final num = double.tryParse(value);
                        if (num == null || num <= 0) {
                          return 'Enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 200.ms)
                      .slideX(begin: -0.2, end: 0, duration: 300.ms, delay: 200.ms),
                  SizedBox(height: 12.h),
                  // Quick Select Options
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _quickOptions.map((option) {
                      final isSelected = _valueController.text == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _valueController.text = option;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _color.withAlpha((0.1 * 255).round())
                                : Colors.white.withAlpha((0.9 * 255).round()),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isSelected
                                  ? _color
                                  : CareSyncDesignSystem.textSecondary.withAlpha(
                                      (0.2 * 255).round(),
                                    ),
                            ),
                          ),
                          child: Text(
                            '$option $_unit',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              color: isSelected
                                  ? _color
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
                    'Notes (Optional)',
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
                        hintText: 'Add any additional details...',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 40.h),
                          child: Icon(
                            Icons.note,
                            color: _color,
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
                    text: 'Log $_title',
                    icon: Icons.check,
                    onPressed: _submitHabit,
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

