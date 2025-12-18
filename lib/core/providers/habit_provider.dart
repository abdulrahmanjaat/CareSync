import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Habit Type
enum HabitType { exercise, sleep, dietary }

/// Habit Entry Model
class HabitEntry {
  final String id;
  final HabitType type;
  final DateTime date;
  final double? value; // Duration in minutes for exercise, hours for sleep, calories for dietary
  final String? notes;
  final Map<String, dynamic>? metadata; // Additional data (e.g., exercise type, meal type)

  HabitEntry({
    required this.id,
    required this.type,
    required this.date,
    this.value,
    this.notes,
    this.metadata,
  });

  HabitEntry copyWith({
    String? id,
    HabitType? type,
    DateTime? date,
    double? value,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return HabitEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      value: value ?? this.value,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Habit State
class HabitState {
  final List<HabitEntry> habits;

  HabitState({this.habits = const []});

  HabitState copyWith({List<HabitEntry>? habits}) {
    return HabitState(habits: habits ?? this.habits);
  }

  List<HabitEntry> getHabitsByType(HabitType type) {
    return habits.where((h) => h.type == type).toList();
  }

  List<HabitEntry> getHabitsForDate(DateTime date) {
    return habits.where((h) {
      return h.date.year == date.year &&
          h.date.month == date.month &&
          h.date.day == date.day;
    }).toList();
  }
}

/// Habit Notifier
class HabitNotifier extends StateNotifier<HabitState> {
  HabitNotifier() : super(HabitState());

  void addHabit(HabitEntry habit) {
    state = state.copyWith(habits: [habit, ...state.habits]);
  }

  void removeHabit(String id) {
    state = state.copyWith(
      habits: state.habits.where((h) => h.id != id).toList(),
    );
  }

  void updateHabit(HabitEntry habit) {
    state = state.copyWith(
      habits: state.habits.map((h) {
        if (h.id == habit.id) {
          return habit;
        }
        return h;
      }).toList(),
    );
  }
}

/// Habit Provider
final habitProvider = StateNotifierProvider<HabitNotifier, HabitState>((ref) {
  return HabitNotifier();
});

