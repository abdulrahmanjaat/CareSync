import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Appointment Model
class Appointment {
  final String id;
  final String title;
  final String? description;
  final DateTime dateTime;
  final String? location;
  final String? doctorName;
  final String? doctorSpecialty;
  final String? notes;
  final bool isReminderSet;
  final DateTime? reminderTime;
  final bool isCompleted;

  Appointment({
    required this.id,
    required this.title,
    this.description,
    required this.dateTime,
    this.location,
    this.doctorName,
    this.doctorSpecialty,
    this.notes,
    this.isReminderSet = true,
    this.reminderTime,
    this.isCompleted = false,
  });

  Appointment copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    String? location,
    String? doctorName,
    String? doctorSpecialty,
    String? notes,
    bool? isReminderSet,
    DateTime? reminderTime,
    bool? isCompleted,
  }) {
    return Appointment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      location: location ?? this.location,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      notes: notes ?? this.notes,
      isReminderSet: isReminderSet ?? this.isReminderSet,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  bool get isUpcoming => dateTime.isAfter(DateTime.now()) && !isCompleted;
  bool get isPast => dateTime.isBefore(DateTime.now()) || isCompleted;
}

/// Appointment State
class AppointmentState {
  final List<Appointment> appointments;

  AppointmentState({this.appointments = const []});

  AppointmentState copyWith({List<Appointment>? appointments}) {
    return AppointmentState(appointments: appointments ?? this.appointments);
  }

  List<Appointment> getUpcomingAppointments() {
    return appointments.where((a) => a.isUpcoming).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Appointment> getAppointmentsForDate(DateTime date) {
    return appointments.where((a) {
      return a.dateTime.year == date.year &&
          a.dateTime.month == date.month &&
          a.dateTime.day == date.day;
    }).toList();
  }
}

/// Appointment Notifier
class AppointmentNotifier extends StateNotifier<AppointmentState> {
  AppointmentNotifier() : super(AppointmentState()) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = AppointmentState(
      appointments: [
        Appointment(
          id: 'a1',
          title: 'Annual Checkup',
          description: 'Routine health checkup',
          dateTime: DateTime.now().add(Duration(days: 5)),
          location: 'City Medical Center',
          doctorName: 'Dr. Smith',
          doctorSpecialty: 'General Medicine',
          isReminderSet: true,
          reminderTime: DateTime.now().add(Duration(days: 5, hours: -1)),
        ),
      ],
    );
  }

  void addAppointment(Appointment appointment) {
    state = state.copyWith(
      appointments: [...state.appointments, appointment],
    );
  }

  void removeAppointment(String id) {
    state = state.copyWith(
      appointments: state.appointments.where((a) => a.id != id).toList(),
    );
  }

  void updateAppointment(Appointment appointment) {
    state = state.copyWith(
      appointments: state.appointments.map((a) {
        if (a.id == appointment.id) {
          return appointment;
        }
        return a;
      }).toList(),
    );
  }

  void markAsCompleted(String id) {
    state = state.copyWith(
      appointments: state.appointments.map((a) {
        if (a.id == id) {
          return a.copyWith(isCompleted: true);
        }
        return a;
      }).toList(),
    );
  }
}

/// Appointment Provider
final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, AppointmentState>((ref) {
  return AppointmentNotifier();
});

