import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Handoff Note Model
class HandoffNote {
  final String id;
  final DateTime createdAt;
  final String? voiceNotePath; // Path to recorded audio file
  final String textNote;
  final String caregiverName;

  HandoffNote({
    required this.id,
    required this.createdAt,
    this.voiceNotePath,
    required this.textNote,
    required this.caregiverName,
  });

  HandoffNote copyWith({
    String? id,
    DateTime? createdAt,
    String? voiceNotePath,
    String? textNote,
    String? caregiverName,
  }) {
    return HandoffNote(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      textNote: textNote ?? this.textNote,
      caregiverName: caregiverName ?? this.caregiverName,
    );
  }
}

/// Handoff State
class HandoffState {
  final List<HandoffNote> notes;
  final String? currentVoiceNotePath;
  final bool isRecording;

  HandoffState({
    this.notes = const [],
    this.currentVoiceNotePath,
    this.isRecording = false,
  });

  HandoffState copyWith({
    List<HandoffNote>? notes,
    String? currentVoiceNotePath,
    bool? isRecording,
  }) {
    return HandoffState(
      notes: notes ?? this.notes,
      currentVoiceNotePath: currentVoiceNotePath ?? this.currentVoiceNotePath,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}

/// Handoff Notifier
class HandoffNotifier extends StateNotifier<HandoffState> {
  HandoffNotifier() : super(HandoffState()) {
    _initializeMockNotes();
  }

  void _initializeMockNotes() {
    state = HandoffState(
      notes: [
        HandoffNote(
          id: 'h1',
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          textNote:
              'All meds given on time. Patient complained of mild headache at 2 PM.',
          caregiverName: 'Sarah Johnson',
        ),
      ],
    );
  }

  void startRecording() {
    state = state.copyWith(isRecording: true);
  }

  void stopRecording(String? voiceNotePath) {
    state = state.copyWith(
      isRecording: false,
      currentVoiceNotePath: voiceNotePath,
    );
  }

  void saveHandoffNote(String textNote, String caregiverName) {
    final note = HandoffNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      voiceNotePath: state.currentVoiceNotePath,
      textNote: textNote,
      caregiverName: caregiverName,
    );
    state = state.copyWith(
      notes: [note, ...state.notes],
      currentVoiceNotePath: null,
    );
  }

  void clearCurrentRecording() {
    state = state.copyWith(currentVoiceNotePath: null, isRecording: false);
  }
}

/// Handoff Provider
final handoffProvider = StateNotifierProvider<HandoffNotifier, HandoffState>((
  ref,
) {
  return HandoffNotifier();
});
