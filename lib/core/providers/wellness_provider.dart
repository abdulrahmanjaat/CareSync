import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Wellness Data Model
class WellnessData {
  final int waterIntake; // milliliters
  final String? mood; // 'happy', 'neutral', 'pain'
  final DateTime lastUpdated;

  WellnessData({this.waterIntake = 0, this.mood, DateTime? lastUpdated})
    : lastUpdated = lastUpdated ?? DateTime.now();

  // Convert to liters for display
  double get waterIntakeLiters => waterIntake / 1000.0;

  // Convert to cups (1 cup = 240ml)
  int get waterIntakeCups => (waterIntake / 240).round();

  WellnessData copyWith({
    int? waterIntake,
    String? mood,
    DateTime? lastUpdated,
  }) {
    return WellnessData(
      waterIntake: waterIntake ?? this.waterIntake,
      mood: mood ?? this.mood,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Wellness Notifier
class WellnessNotifier extends StateNotifier<WellnessData> {
  WellnessNotifier() : super(WellnessData());

  void addWater(int milliliters) {
    state = state.copyWith(waterIntake: state.waterIntake + milliliters);
  }

  void removeWater(int milliliters) {
    state = state.copyWith(
      waterIntake: (state.waterIntake - milliliters)
          .clamp(0, double.infinity)
          .toInt(),
    );
  }

  void setMood(String mood) {
    state = state.copyWith(mood: mood);
  }

  void resetDaily() {
    state = WellnessData();
  }
}

/// Wellness Provider
final wellnessProvider = StateNotifierProvider<WellnessNotifier, WellnessData>((
  ref,
) {
  return WellnessNotifier();
});
