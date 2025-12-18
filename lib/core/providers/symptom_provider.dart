import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Symptom Entry Model
class SymptomEntry {
  final String id;
  final String symptom;
  final String severity; // Mild, Moderate, Severe
  final String? notes;
  final DateTime timestamp;
  final String? location; // Body location
  final List<String>? tags; // e.g., ["headache", "nausea"]

  SymptomEntry({
    required this.id,
    required this.symptom,
    required this.severity,
    this.notes,
    required this.timestamp,
    this.location,
    this.tags,
  });

  SymptomEntry copyWith({
    String? id,
    String? symptom,
    String? severity,
    String? notes,
    DateTime? timestamp,
    String? location,
    List<String>? tags,
  }) {
    return SymptomEntry(
      id: id ?? this.id,
      symptom: symptom ?? this.symptom,
      severity: severity ?? this.severity,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      tags: tags ?? this.tags,
    );
  }
}

/// Symptom State
class SymptomState {
  final List<SymptomEntry> symptoms;

  SymptomState({this.symptoms = const []});

  SymptomState copyWith({List<SymptomEntry>? symptoms}) {
    return SymptomState(symptoms: symptoms ?? this.symptoms);
  }

  List<SymptomEntry> getRecentSymptoms(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return symptoms.where((s) => s.timestamp.isAfter(cutoff)).toList();
  }
}

/// Symptom Notifier
class SymptomNotifier extends StateNotifier<SymptomState> {
  SymptomNotifier() : super(SymptomState());

  void addSymptom(SymptomEntry symptom) {
    state = state.copyWith(symptoms: [symptom, ...state.symptoms]);
  }

  void removeSymptom(String id) {
    state = state.copyWith(
      symptoms: state.symptoms.where((s) => s.id != id).toList(),
    );
  }

  void updateSymptom(SymptomEntry symptom) {
    state = state.copyWith(
      symptoms: state.symptoms.map((s) {
        if (s.id == symptom.id) {
          return symptom;
        }
        return s;
      }).toList(),
    );
  }
}

/// Symptom Provider
final symptomProvider =
    StateNotifierProvider<SymptomNotifier, SymptomState>((ref) {
  return SymptomNotifier();
});

