import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../design/caresync_design_system.dart';
import 'bento_card.dart';

enum ValidatorType { text, email, password, confirmPassword, name, description }

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextEditingController? passwordController;
  final AutovalidateMode autovalidateMode;
  final String? label;
  final ValidatorType validatorType;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPasswordField;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Widget? suffixIcon;
  final bool showUnderline;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final bool isOptional;
  final IconData? prefixIcon;
  final bool useBentoCard;

  const CustomTextField({
    super.key,
    this.controller,
    this.passwordController,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPasswordField = false,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onEditingComplete,
    this.suffixIcon,
    this.validatorType = ValidatorType.text,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.showUnderline = true,
    this.onChanged,
    this.autofillHints,
    this.isOptional = false,
    this.prefixIcon,
    this.useBentoCard = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  ///  validator logic
  String? _builtInValidator(String? value) {
    // If field is optional and empty, it's valid
    if (widget.isOptional && (value == null || value.trim().isEmpty)) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    switch (widget.validatorType) {
      case ValidatorType.email:
        return _validateEmail(value);

      case ValidatorType.password:
        return _validatePassword(value);

      case ValidatorType.confirmPassword:
        if (widget.passwordController == null) {
          return "Password field missing for comparison";
        }
        if (value != widget.passwordController!.text) {
          return "Passwords do not match";
        }
        break;

      case ValidatorType.name:
        return _validateName(value);

      case ValidatorType.description:
        return _validateDescription(value);

      case ValidatorType.text:
        break;
    }
    return null;
  }

  //Email validator
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  // password validator
  String? _validatePassword(String? value) {
    if (value!.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  // Name validator
  String? _validateName(String? value) {
    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name must contain only letters';
    }
    return null;
  }

  // Description validator
  String? _validateDescription(String? value) {
    // Description is required (not optional)
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }

    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }

    if (value.trim().length > 500) {
      return 'Description must be less than 500 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textField = TextFormField(
      controller: widget.controller,
      validator: (value) {
        final error = _builtInValidator(value);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _errorText = error;
            });
          }
        });
        return error;
      },
      autovalidateMode: widget.autovalidateMode,
      keyboardType: widget.keyboardType,
      obscureText: _isObscured,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      onChanged: (value) {
        widget.onChanged?.call(value);
        // Clear error when user starts typing
        if (_errorText != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              final error = _builtInValidator(value);
              setState(() {
                _errorText = error;
              });
            }
          });
        }
      },
      autofillHints: widget.autofillHints,
      style: TextStyle(
        color: CareSyncDesignSystem.textPrimary,
        fontSize: 15.sp,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: CareSyncDesignSystem.textPrimary.withValues(alpha: 0.40),
          fontSize: 16.sp,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: CareSyncDesignSystem.primaryTeal)
            : null,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: CareSyncDesignSystem.textPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
            : widget.suffixIcon,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: const TextStyle(height: 0, fontSize: 0),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        isDense: true,
      ),
    );

    if (widget.useBentoCard) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BentoCard(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
            child: SizedBox(height: 56.h, child: textField),
          ),
          if (_errorText != null)
            Padding(
              padding: EdgeInsets.only(top: 4.h, left: 16.w),
              child: Text(
                _errorText!,
                style: TextStyle(
                  color: CareSyncDesignSystem.alertRed,
                  fontSize: 12.sp,
                  height: 1.4,
                ),
              ),
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        textField,
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h, left: 16.w),
            child: Text(
              _errorText!,
              style: TextStyle(
                color: CareSyncDesignSystem.alertRed,
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}
