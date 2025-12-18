import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shift Status
enum ShiftStatus { active, onBreak, ended }

/// Task Status
enum TaskStatus { pending, completed, flagged }

/// Caregiver Task Model
class CaregiverTask {
  final String id;
  final String patientId;
  final String patientName;
  final String description;
  final DateTime scheduledTime;
  final TaskStatus status;
  final String? flagNote; // Reason for flagging (e.g., "Patient refused meds")

  CaregiverTask({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.description,
    required this.scheduledTime,
    this.status = TaskStatus.pending,
    this.flagNote,
  });

  CaregiverTask copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? description,
    DateTime? scheduledTime,
    TaskStatus? status,
    String? flagNote,
  }) {
    return CaregiverTask(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      description: description ?? this.description,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      flagNote: flagNote ?? this.flagNote,
    );
  }

  /// Check if task is overdue (30+ minutes late)
  bool get isOverdue {
    if (status == TaskStatus.completed) return false;
    final now = DateTime.now();
    final difference = now.difference(scheduledTime);
    return difference.inMinutes >= 30;
  }

  /// Get minutes overdue
  int get minutesOverdue {
    if (!isOverdue) return 0;
    final now = DateTime.now();
    return now.difference(scheduledTime).inMinutes;
  }
}

/// Shift State
class ShiftState {
  final DateTime startTime;
  final DateTime? breakStartTime;
  final Duration breakDuration;
  final ShiftStatus status;
  final List<CaregiverTask> tasks;

  ShiftState({
    required this.startTime,
    this.breakStartTime,
    this.breakDuration = Duration.zero,
    this.status = ShiftStatus.active,
    this.tasks = const [],
  });

  Duration get elapsedDuration {
    if (status == ShiftStatus.ended) {
      return DateTime.now().difference(startTime) - breakDuration;
    }
    final now = DateTime.now();
    final totalDuration = now.difference(startTime);
    if (status == ShiftStatus.onBreak && breakStartTime != null) {
      final currentBreakDuration = now.difference(breakStartTime!);
      return totalDuration - breakDuration - currentBreakDuration;
    }
    return totalDuration - breakDuration;
  }

  List<CaregiverTask> get sortedTasks {
    final sorted = List<CaregiverTask>.from(tasks);
    sorted.sort((a, b) {
      // Overdue tasks first
      if (a.isOverdue && !b.isOverdue) return -1;
      if (!a.isOverdue && b.isOverdue) return 1;
      // Then by scheduled time
      return a.scheduledTime.compareTo(b.scheduledTime);
    });
    return sorted;
  }

  ShiftState copyWith({
    DateTime? startTime,
    DateTime? breakStartTime,
    Duration? breakDuration,
    ShiftStatus? status,
    List<CaregiverTask>? tasks,
  }) {
    return ShiftState(
      startTime: startTime ?? this.startTime,
      breakStartTime: breakStartTime ?? this.breakStartTime,
      breakDuration: breakDuration ?? this.breakDuration,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
    );
  }
}

/// Caregiver Shift Notifier
class CaregiverShiftNotifier extends StateNotifier<ShiftState> {
  CaregiverShiftNotifier() : super(ShiftState(startTime: DateTime.now())) {
    _initializeMockTasks();
  }

  void _initializeMockTasks() {
    final now = DateTime.now();
    state = state.copyWith(
      tasks: [
        CaregiverTask(
          id: 't1',
          patientId: '1',
          patientName: 'John Doe',
          description: 'Morning medication - Metformin',
          scheduledTime: now.subtract(Duration(minutes: 45)), // Overdue
        ),
        CaregiverTask(
          id: 't2',
          patientId: '1',
          patientName: 'John Doe',
          description: 'Blood pressure check',
          scheduledTime: now.add(Duration(minutes: 30)),
        ),
        CaregiverTask(
          id: 't3',
          patientId: '2',
          patientName: 'Jane Smith',
          description: 'Afternoon medication - Insulin',
          scheduledTime: now.add(Duration(hours: 2)),
        ),
        CaregiverTask(
          id: 't4',
          patientId: '1',
          patientName: 'John Doe',
          description: 'Temperature check',
          scheduledTime: now.add(Duration(minutes: 15)),
        ),
      ],
    );
  }

  void startBreak() {
    if (state.status == ShiftStatus.active) {
      state = state.copyWith(
        status: ShiftStatus.onBreak,
        breakStartTime: DateTime.now(),
      );
    }
  }

  void endBreak() {
    if (state.status == ShiftStatus.onBreak && state.breakStartTime != null) {
      final breakDuration = DateTime.now().difference(state.breakStartTime!);
      state = state.copyWith(
        status: ShiftStatus.active,
        breakDuration: state.breakDuration + breakDuration,
        breakStartTime: null,
      );
    }
  }

  void completeTask(String taskId) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(status: TaskStatus.completed);
      }
      return task;
    }).toList();
    state = state.copyWith(tasks: updatedTasks);
  }

  void flagTask(String taskId, String note) {
    final updatedTasks = state.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(status: TaskStatus.flagged, flagNote: note);
      }
      return task;
    }).toList();
    state = state.copyWith(tasks: updatedTasks);
  }

  void addTask(CaregiverTask task) {
    state = state.copyWith(tasks: [...state.tasks, task]);
  }
}

/// Caregiver Shift Provider
final caregiverShiftProvider =
    StateNotifierProvider<CaregiverShiftNotifier, ShiftState>((ref) {
      return CaregiverShiftNotifier();
    });
