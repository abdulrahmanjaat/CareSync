import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/widgets/caresync_button.dart';

/// Flag Issue Dialog - For flagging tasks with notes
class FlagIssueDialog extends StatefulWidget {
  const FlagIssueDialog({super.key});

  @override
  State<FlagIssueDialog> createState() => _FlagIssueDialogState();
}

class _FlagIssueDialogState extends State<FlagIssueDialog> {
  final _noteController = TextEditingController();
  String? _selectedReason;

  final List<String> _commonReasons = [
    'Patient refused medication',
    'Patient not available',
    'Equipment issue',
    'Medication out of stock',
    'Other',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: BentoCard(
        padding: EdgeInsets.all(24.w),
        backgroundColor: Colors.white.withAlpha((0.95 * 255).round()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flag Issue',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: CareSyncDesignSystem.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Reason',
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
              children: _commonReasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedReason = reason;
                      if (reason != 'Other') {
                        _noteController.text = reason;
                      } else {
                        _noteController.clear();
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? CareSyncDesignSystem.alertRed.withAlpha(
                              (0.1 * 255).round(),
                            )
                          : Colors.white.withAlpha((0.9 * 255).round()),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected
                            ? CareSyncDesignSystem.alertRed
                            : CareSyncDesignSystem.textSecondary.withAlpha(
                                (0.2 * 255).round(),
                              ),
                      ),
                    ),
                    child: Text(
                      reason,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: isSelected
                            ? CareSyncDesignSystem.alertRed
                            : CareSyncDesignSystem.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            Text(
              'Additional Notes',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: CareSyncDesignSystem.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.9 * 255).round()),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _noteController,
                maxLines: 3,
                enabled: _selectedReason == 'Other' || _selectedReason != null,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: CareSyncDesignSystem.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter additional details...',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CareSyncButton(
                    text: 'Cancel',
                    isOutlined: true,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CareSyncButton(
                    text: 'Flag',
                    onPressed: () {
                      if (_noteController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a reason'),
                            backgroundColor: CareSyncDesignSystem.alertRed,
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).pop(_noteController.text.trim());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
