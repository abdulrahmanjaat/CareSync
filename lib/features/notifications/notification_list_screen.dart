import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/design/caresync_design_system.dart';
import '../../core/widgets/bento_card.dart';
import '../../core/providers/notification_provider.dart';

class NotificationListScreen extends ConsumerWidget {
  const NotificationListScreen({super.key});

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

  String _formatFullDate(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final notifications = notificationState.notifications;

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
                      icon: Icon(
                        Icons.arrow_back,
                        color: CareSyncDesignSystem.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notifications',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: CareSyncDesignSystem.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${notificationState.unreadCount} unread',
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: CareSyncDesignSystem.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (notificationState.unreadCount > 0)
                      TextButton(
                        onPressed: () {
                          ref
                              .read(notificationProvider.notifier)
                              .markAllAsRead();
                        },
                        child: Text(
                          'Mark all read',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CareSyncDesignSystem.primaryTeal,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Notifications List
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 64.sp,
                              color: CareSyncDesignSystem.textSecondary
                                  .withAlpha((0.5 * 255).round()),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No notifications',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'You\'re all caught up!',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: CareSyncDesignSystem.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          final isUnread = !notification.isRead;
                          final showDateHeader =
                              index == 0 ||
                              notifications[index - 1].createdAt.day !=
                                  notification.createdAt.day;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showDateHeader) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Text(
                                    _formatFullDate(notification.createdAt),
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: CareSyncDesignSystem.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                              Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        ref
                                            .read(notificationProvider.notifier)
                                            .markAsRead(notification.id);
                                      },
                                      child: BentoCard(
                                        padding: EdgeInsets.all(16.w),
                                        backgroundColor: isUnread
                                            ? CareSyncDesignSystem.primaryTeal
                                                  .withAlpha(
                                                    (0.05 * 255).round(),
                                                  )
                                            : null,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 48.w,
                                              height: 48.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    _getNotificationColor(
                                                      notification.type,
                                                    ).withAlpha(
                                                      (0.1 * 255).round(),
                                                    ),
                                              ),
                                              child: Icon(
                                                _getNotificationIcon(
                                                  notification.type,
                                                ),
                                                size: 24.sp,
                                                color: _getNotificationColor(
                                                  notification.type,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          notification.title,
                                                          style: GoogleFonts.inter(
                                                            fontSize: 16.sp,
                                                            fontWeight: isUnread
                                                                ? FontWeight
                                                                      .w600
                                                                : FontWeight
                                                                      .normal,
                                                            color:
                                                                CareSyncDesignSystem
                                                                    .textPrimary,
                                                          ),
                                                        ),
                                                      ),
                                                      if (isUnread)
                                                        Container(
                                                          width: 8.w,
                                                          height: 8.w,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color:
                                                                CareSyncDesignSystem
                                                                    .primaryTeal,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    notification.message,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 14.sp,
                                                      color:
                                                          CareSyncDesignSystem
                                                              .textSecondary,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    _formatTime(
                                                      notification.createdAt,
                                                    ),
                                                    style: GoogleFonts.inter(
                                                      fontSize: 12.sp,
                                                      color:
                                                          CareSyncDesignSystem
                                                              .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    duration: 300.ms,
                                    delay: Duration(milliseconds: index * 50),
                                  )
                                  .slideX(
                                    begin: -0.2,
                                    end: 0,
                                    duration: 300.ms,
                                    delay: Duration(milliseconds: index * 50),
                                  ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
