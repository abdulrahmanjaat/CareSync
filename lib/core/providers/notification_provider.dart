import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification Type
enum NotificationType {
  medicationDue,
  appointmentReminder,
  abnormalVitals,
  caregiverNote,
  managerAlert,
  caregiverRequest,
  medicationMissed,
  vitalWarning,
}

/// Notification Model
class AppNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedId; // ID of related entity (patient, medication, etc.)
  final Map<String, dynamic>? metadata;

  AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.relatedId,
    this.metadata,
  });

  AppNotification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
    String? relatedId,
    Map<String, dynamic>? metadata,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Notification State
class NotificationState {
  final List<AppNotification> notifications;

  NotificationState({this.notifications = const []});

  NotificationState copyWith({List<AppNotification>? notifications}) {
    return NotificationState(notifications: notifications ?? this.notifications);
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  List<AppNotification> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();
}

/// Notification Notifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState()) {
    _initializeMockNotifications();
  }

  void _initializeMockNotifications() {
    state = NotificationState(
      notifications: [
        AppNotification(
          id: 'n1',
          type: NotificationType.medicationDue,
          title: 'Medication Reminder',
          message: 'Time to take your morning medication',
          createdAt: DateTime.now().subtract(Duration(minutes: 5)),
        ),
        AppNotification(
          id: 'n2',
          type: NotificationType.appointmentReminder,
          title: 'Appointment Tomorrow',
          message: 'Doctor appointment at 10:00 AM',
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
      ],
    );
  }

  void addNotification(AppNotification notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
    );
  }

  void markAsRead(String notificationId) {
    state = state.copyWith(
      notifications: state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList(),
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications: state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList(),
    );
  }

  void removeNotification(String notificationId) {
    state = state.copyWith(
      notifications:
          state.notifications.where((n) => n.id != notificationId).toList(),
    );
  }

  void clearAll() {
    state = NotificationState();
  }
}

/// Notification Provider
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

