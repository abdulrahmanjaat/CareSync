import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/caresync_design_system.dart';

/// Messages Screen - Communication hub
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Messages',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              // Empty State
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64.sp,
                        color: CareSyncDesignSystem.textSecondary,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No messages yet',
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          color: CareSyncDesignSystem.textSecondary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Communicate with your caregivers and manager',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: CareSyncDesignSystem.textSecondary.withAlpha(
                            (0.7 * 255).round(),
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
