import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';

/// Settings Screen - App settings and preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: CareSyncDesignSystem.meshGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Settings',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Notifications Settings
                _SettingsSection(
                  title: 'Notifications',
                  children: [
                    _SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Receive alerts and reminders',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: CareSyncDesignSystem.primaryTeal,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.medication_outlined,
                      title: 'Medication Reminders',
                      subtitle: 'Get notified when medication is due',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: CareSyncDesignSystem.primaryTeal,
                      ),
                    ),
                    _SettingsTile(
                      icon: Icons.calendar_today_outlined,
                      title: 'Appointment Reminders',
                      subtitle: 'Remind me before appointments',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: CareSyncDesignSystem.primaryTeal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Privacy & Security
                _SettingsSection(
                  title: 'Privacy & Security',
                  children: [
                    _SettingsTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.fingerprint_outlined,
                      title: 'Biometric Authentication',
                      subtitle: 'Use fingerprint or face ID',
                      trailing: Switch(
                        value: false,
                        onChanged: (value) {},
                        activeColor: CareSyncDesignSystem.primaryTeal,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // App Info
                _SettingsSection(
                  title: 'About',
                  children: [
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'App Version',
                      subtitle: '1.0.0',
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      subtitle: 'Read our terms of service',
                      onTap: () {},
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: CareSyncDesignSystem.textPrimary,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: BentoCard(
        onTap: onTap,
        padding: EdgeInsets.all(16.w),
        backgroundColor: Colors.white.withAlpha((0.9 * 255).round()),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: CareSyncDesignSystem.primaryTeal.withAlpha(
                  (0.1 * 255).round(),
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: CareSyncDesignSystem.primaryTeal,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: CareSyncDesignSystem.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null && onTap != null)
              Icon(
                Icons.chevron_right,
                color: CareSyncDesignSystem.textSecondary,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }
}
