import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/design/caresync_design_system.dart';
import '../../../../core/widgets/bento_card.dart';
import '../../../../core/providers/notification_provider.dart';
import '../../../notifications/notification_list_screen.dart';

/// Notification Center Widget
class NotificationCenter extends ConsumerWidget {
  const NotificationCenter({super.key});

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.medicationDue:
      case NotificationType.medicationMissed:
        return Icons.medication;
      case NotificationType.appointmentReminder:
        return Icons.calendar_today;
      case NotificationType.abnormalVitals:
      case NotificationType.vitalWarning:
        return Icons.warning;
      case NotificationType.caregiverNote:
        return Icons.note;
      case NotificationType.managerAlert:
        return Icons.notifications;
      case NotificationType.caregiverRequest:
        return Icons.person_add;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.medicationDue:
      case NotificationType.medicationMissed:
        return CareSyncDesignSystem.alertRed;
      case NotificationType.appointmentReminder:
        return CareSyncDesignSystem.primaryTeal;
      case NotificationType.abnormalVitals:
      case NotificationType.vitalWarning:
        return CareSyncDesignSystem.softCoral;
      case NotificationType.caregiverNote:
        return CareSyncDesignSystem.successEmerald;
      case NotificationType.managerAlert:
        return CareSyncDesignSystem.primaryTeal;
      case NotificationType.caregiverRequest:
        return CareSyncDesignSystem.primaryTeal;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notifications = notificationState.notifications.take(5).toList();

    if (notifications.isEmpty) {
      return SizedBox.shrink();
    }

    return BentoCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 20.sp,
                    color: CareSyncDesignSystem.primaryTeal,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Notifications',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.textPrimary,
                    ),
                  ),
                ],
              ),
              if (notificationState.unreadCount > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: CareSyncDesignSystem.alertRed,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${notificationState.unreadCount}',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: CareSyncDesignSystem.surfaceWhite,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          ...notifications.map((notification) {
            final isUnread = !notification.isRead;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(notificationProvider.notifier)
                      .markAsRead(notification.id);
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isUnread
                        ? CareSyncDesignSystem.primaryTeal.withAlpha(
                            (0.05 * 255).round(),
                          )
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isUnread
                        ? Border.all(
                            color: CareSyncDesignSystem.primaryTeal.withAlpha(
                              (0.2 * 255).round(),
                            ),
                            width: 1.w,
                          )
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getNotificationColor(notification.type)
                              .withAlpha((0.1 * 255).round()),
                        ),
                        child: Icon(
                          _getNotificationIcon(notification.type),
                          size: 20.sp,
                          color: _getNotificationColor(notification.type),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                fontWeight: isUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: CareSyncDesignSystem.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              notification.message,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _formatTime(notification.createdAt),
                              style: GoogleFonts.inter(
                                fontSize: 10.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (notificationState.notifications.length > 5)
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationListScreen(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: CareSyncDesignSystem.primaryTeal,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

