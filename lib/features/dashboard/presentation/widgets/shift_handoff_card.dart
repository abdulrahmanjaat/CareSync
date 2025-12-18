import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/handoff_provider.dart';

/// Shift Handoff Card - Persistent bottom card for shift transitions
class ShiftHandoffCard extends ConsumerStatefulWidget {
  const ShiftHandoffCard({super.key});

  @override
  ConsumerState<ShiftHandoffCard> createState() => _ShiftHandoffCardState();
}

class _ShiftHandoffCardState extends ConsumerState<ShiftHandoffCard> {
  final _textController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _startRecording() {
    ref.read(handoffProvider.notifier).startRecording();
    HapticFeedback.mediumImpact();
    // TODO: Implement actual voice recording
    // For now, simulate recording
    Future.delayed(Duration(seconds: 2), () {
      ref.read(handoffProvider.notifier).stopRecording('mock_voice_path.mp3');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice note recorded'),
          backgroundColor: CareSyncDesignSystem.successEmerald,
        ),
      );
    });
  }

  void _stopRecording() {
    ref.read(handoffProvider.notifier).stopRecording(null);
    HapticFeedback.lightImpact();
  }

  void _saveHandoffNote() {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a summary note'),
          backgroundColor: CareSyncDesignSystem.alertRed,
        ),
      );
      return;
    }

    ref
        .read(handoffProvider.notifier)
        .saveHandoffNote(
          _textController.text.trim(),
          'Current Caregiver', // TODO: Get from auth provider
        );

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Handoff note saved'),
        backgroundColor: CareSyncDesignSystem.successEmerald,
      ),
    );

    setState(() {
      _isExpanded = false;
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final handoffState = ref.watch(handoffProvider);
    final isRecording = handoffState.isRecording;

    return BentoCard(
      padding: EdgeInsets.all(16.w),
      backgroundColor: CareSyncDesignSystem.primaryTeal.withAlpha(
        (0.1 * 255).round(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.swap_horiz,
                color: CareSyncDesignSystem.primaryTeal,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Leaving soon?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: CareSyncDesignSystem.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                  HapticFeedback.lightImpact();
                },
                child: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: CareSyncDesignSystem.primaryTeal,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          if (_isExpanded) ...[
            SizedBox(height: 16.h),
            Divider(
              color: CareSyncDesignSystem.primaryTeal.withAlpha(
                (0.2 * 255).round(),
              ),
            ),
            SizedBox(height: 16.h),
            // Voice Note Button
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: isRecording ? _stopRecording : _startRecording,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isRecording
                            ? CareSyncDesignSystem.alertRed
                            : CareSyncDesignSystem.primaryTeal,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: CareSyncDesignSystem.surfaceWhite,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            isRecording
                                ? 'Stop Recording'
                                : 'Record Voice Note',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: CareSyncDesignSystem.surfaceWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Summary Text Field
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.9 * 255).round()),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: _textController,
                maxLines: 3,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: CareSyncDesignSystem.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                      'e.g., All meds given, patient complained of headache at 2 PM.',
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: CareSyncDesignSystem.textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Save Button
            GestureDetector(
              onTap: _saveHandoffNote,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: CareSyncDesignSystem.successEmerald,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    'Save Handoff Note',
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.surfaceWhite,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            // Recent Notes Preview
            if (handoffState.notes.isNotEmpty) ...[
              Divider(
                color: CareSyncDesignSystem.primaryTeal.withAlpha(
                  (0.2 * 255).round(),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Recent Notes',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: CareSyncDesignSystem.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              ...handoffState.notes.take(2).map((note) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        note.voiceNotePath != null ? Icons.mic : Icons.note,
                        size: 16.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          note.textNote,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: CareSyncDesignSystem.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ],
      ),
    );
  }
}
