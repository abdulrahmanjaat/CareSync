import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/design/caresync_design_system.dart';
import '../../../core/widgets/bento_card.dart';
import '../../../core/providers/role_provider.dart';

/// Role Dropdown Widget - For signup form
class RoleDropdown extends StatefulWidget {
  final UserRole? selectedRole;
  final Function(UserRole) onRoleSelected;

  const RoleDropdown({
    super.key,
    required this.selectedRole,
    required this.onRoleSelected,
  });

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  String? _errorText;

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.manager:
        return 'Manager';
      case UserRole.caregiver:
        return 'Caregiver';
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.patient:
        return Icons.person;
      case UserRole.manager:
        return Icons.people;
      case UserRole.caregiver:
        return Icons.medical_services;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dropdown = DropdownButtonFormField<UserRole>(
      key: ValueKey(widget.selectedRole),
      initialValue: widget.selectedRole,
      decoration: InputDecoration(
        // labelText: 'Select Your Role',
        prefixIcon: Icon(
          widget.selectedRole != null
              ? _getRoleIcon(widget.selectedRole!)
              : Icons.work_outline,
          color: CareSyncDesignSystem.primaryTeal,
        ),
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: CareSyncDesignSystem.textPrimary,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        labelStyle: TextStyle(
          color: CareSyncDesignSystem.textPrimary.withValues(alpha: 0.40),
          fontSize: 16.sp,
        ),
        errorStyle: const TextStyle(height: 0, fontSize: 0),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        isDense: true,
      ),
      style: TextStyle(
        color: CareSyncDesignSystem.textPrimary,
        fontSize: 15.sp,
      ),
      hint: widget.selectedRole == null
          ? Text(
              '',
              style: TextStyle(
                color: CareSyncDesignSystem.textPrimary.withValues(alpha: 0.40),
                fontSize: 15.sp,
              ),
            )
          : null,
      items: UserRole.values.map((role) {
        return DropdownMenuItem<UserRole>(
          value: role,
          child: Row(
            children: [
              Icon(
                _getRoleIcon(role),
                color: CareSyncDesignSystem.primaryTeal,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Text(_getRoleLabel(role)),
            ],
          ),
        );
      }).toList(),
      onChanged: (role) {
        if (role != null) {
          widget.onRoleSelected(role);
          setState(() {
            _errorText = null;
          });
        }
      },
      validator: (value) {
        if (value == null) {
          final error = 'Please select a role';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _errorText = error;
              });
            }
          });
          return error;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _errorText = null;
            });
          }
        });
        return null;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BentoCard(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
          child: SizedBox(height: 56.h, child: dropdown),
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
}
