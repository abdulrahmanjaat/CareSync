import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Caregiver Model
class Caregiver {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final List<String>
  assignedPatientIds; // IDs of patients assigned to this caregiver

  Caregiver({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatarUrl,
    this.assignedPatientIds = const [],
  });

  Caregiver copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<String>? assignedPatientIds,
  }) {
    return Caregiver(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      assignedPatientIds: assignedPatientIds ?? this.assignedPatientIds,
    );
  }
}

/// Caregiver State
class CaregiverState {
  final List<Caregiver> caregivers;

  CaregiverState({this.caregivers = const []});

  CaregiverState copyWith({List<Caregiver>? caregivers}) {
    return CaregiverState(caregivers: caregivers ?? this.caregivers);
  }
}

/// Caregiver Notifier
class CaregiverNotifier extends StateNotifier<CaregiverState> {
  CaregiverNotifier() : super(CaregiverState()) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = CaregiverState(
      caregivers: [
        Caregiver(
          id: 'c1',
          name: 'Sarah Johnson',
          email: 'sarah@example.com',
          phone: '+1-555-0101',
          assignedPatientIds: ['1', '3'],
        ),
        Caregiver(
          id: 'c2',
          name: 'Michael Chen',
          email: 'michael@example.com',
          phone: '+1-555-0102',
          assignedPatientIds: ['2'],
        ),
        Caregiver(
          id: 'c3',
          name: 'Emily Davis',
          email: 'emily@example.com',
          phone: '+1-555-0103',
          assignedPatientIds: [],
        ),
      ],
    );
  }

  void addCaregiver(Caregiver caregiver) {
    state = state.copyWith(caregivers: [...state.caregivers, caregiver]);
  }

  void updateCaregiver(String id, Caregiver caregiver) {
    final updated = state.caregivers
        .map((c) => c.id == id ? caregiver : c)
        .toList();
    state = state.copyWith(caregivers: updated);
  }

  void removeCaregiver(String id) {
    state = state.copyWith(
      caregivers: state.caregivers.where((c) => c.id != id).toList(),
    );
  }

  void assignPatientToCaregiver(String caregiverId, String patientId) {
    final caregiver = state.caregivers.firstWhere((c) => c.id == caregiverId);
    if (!caregiver.assignedPatientIds.contains(patientId)) {
      final updatedCaregiver = caregiver.copyWith(
        assignedPatientIds: [...caregiver.assignedPatientIds, patientId],
      );
      updateCaregiver(caregiverId, updatedCaregiver);
    }
  }

  void unassignPatientFromCaregiver(String caregiverId, String patientId) {
    final caregiver = state.caregivers.firstWhere((c) => c.id == caregiverId);
    final updatedCaregiver = caregiver.copyWith(
      assignedPatientIds: caregiver.assignedPatientIds
          .where((id) => id != patientId)
          .toList(),
    );
    updateCaregiver(caregiverId, updatedCaregiver);
  }

  List<Caregiver> getCaregiversForPatient(String patientId) {
    return state.caregivers
        .where((c) => c.assignedPatientIds.contains(patientId))
        .toList();
  }
}

/// Caregiver Provider
final caregiverProvider =
    StateNotifierProvider<CaregiverNotifier, CaregiverState>((ref) {
      return CaregiverNotifier();
    });
