import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Medication Model
class Medication {
  final String id;
  final String name;
  final String type;
  final String dosage;
  final List<String> frequency; // Days of week
  final List<String> times; // Time slots
  final String foodTiming; // Before/With/After
  final DateTime createdAt;

  Medication({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.foodTiming,
    required this.createdAt,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? type,
    String? dosage,
    List<String>? frequency,
    List<String>? times,
    String? foodTiming,
    DateTime? createdAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      foodTiming: foodTiming ?? this.foodTiming,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Medication Notifier
class MedicationNotifier extends StateNotifier<List<Medication>> {
  MedicationNotifier() : super([]);

  void addMedication(Medication medication) {
    state = [...state, medication];
  }

  void removeMedication(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  void updateMedication(Medication medication) {
    state = state.map((m) => m.id == medication.id ? medication : m).toList();
  }
}

/// Medication Provider
final medicationProvider =
    StateNotifierProvider<MedicationNotifier, List<Medication>>((ref) {
      return MedicationNotifier();
    });
