import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vitals Data Model
class VitalsData {
  final int? heartRate; // bpm
  final String? bloodPressure; // e.g., "120/80"
  final double? temperature; // °F
  final double? weight; // lbs
  final double? glucose; // mg/dL (blood sugar)
  final int? oxygenSaturation; // SpO2 percentage
  final DateTime timestamp;

  VitalsData({
    this.heartRate,
    this.bloodPressure,
    this.temperature,
    this.weight,
    this.glucose,
    this.oxygenSaturation,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  VitalsData copyWith({
    int? heartRate,
    String? bloodPressure,
    double? temperature,
    double? weight,
    double? glucose,
    int? oxygenSaturation,
    DateTime? timestamp,
  }) {
    return VitalsData(
      heartRate: heartRate ?? this.heartRate,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      temperature: temperature ?? this.temperature,
      weight: weight ?? this.weight,
      glucose: glucose ?? this.glucose,
      oxygenSaturation: oxygenSaturation ?? this.oxygenSaturation,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  bool get isEmpty =>
      heartRate == null &&
      bloodPressure == null &&
      temperature == null &&
      weight == null &&
      glucose == null &&
      oxygenSaturation == null;
}

/// Vitals Notifier
class VitalsNotifier extends StateNotifier<VitalsData> {
  VitalsNotifier() : super(VitalsData());

  void saveVitals({
    int? heartRate,
    String? bloodPressure,
    double? temperature,
    double? weight,
    double? glucose,
    int? oxygenSaturation,
  }) {
    state = VitalsData(
      heartRate: heartRate ?? state.heartRate,
      bloodPressure: bloodPressure ?? state.bloodPressure,
      temperature: temperature ?? state.temperature,
      weight: weight ?? state.weight,
      glucose: glucose ?? state.glucose,
      oxygenSaturation: oxygenSaturation ?? state.oxygenSaturation,
      timestamp: DateTime.now(),
    );
  }

  void clearVitals() {
    state = VitalsData();
  }

  VitalsData? getLatestVitals() {
    return state.isEmpty ? null : state;
  }
}

/// Vitals Provider
final vitalsProvider = StateNotifierProvider<VitalsNotifier, VitalsData>((ref) {
  return VitalsNotifier();
});
