import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Patient Status Enum
enum PatientStatus { critical, lowStock, stable }

/// Patient Model
class Patient {
  final String id;
  final String name;
  final String? avatarUrl;
  final PatientStatus status;
  final bool isHome; // Geofence status
  final List<VitalTrend> vitalTrends; // Last 7 days of vitals
  final List<MedicationInventory> medications;
  final DateTime lastVitalsUpdate;

  Patient({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.status,
    this.isHome = true,
    this.vitalTrends = const [],
    this.medications = const [],
    DateTime? lastVitalsUpdate,
  }) : lastVitalsUpdate = lastVitalsUpdate ?? DateTime.now();

  Patient copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    PatientStatus? status,
    bool? isHome,
    List<VitalTrend>? vitalTrends,
    List<MedicationInventory>? medications,
    DateTime? lastVitalsUpdate,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      isHome: isHome ?? this.isHome,
      vitalTrends: vitalTrends ?? this.vitalTrends,
      medications: medications ?? this.medications,
      lastVitalsUpdate: lastVitalsUpdate ?? this.lastVitalsUpdate,
    );
  }

  /// Check if patient has low stock medications (< 3 days)
  bool get hasLowStock {
    return medications.any((med) => med.daysRemaining < 3);
  }
}

/// Vital Trend Data Point
class VitalTrend {
  final DateTime date;
  final int? heartRate;
  final String? bloodPressure; // e.g., "120/80"

  VitalTrend({required this.date, this.heartRate, this.bloodPressure});
}

/// Medication Inventory
class MedicationInventory {
  final String id;
  final String name;
  final int daysRemaining; // Days until stock runs out

  MedicationInventory({
    required this.id,
    required this.name,
    required this.daysRemaining,
  });
}

/// Household State
class HouseholdState {
  final List<Patient> patients;

  HouseholdState({this.patients = const []});

  HouseholdState copyWith({List<Patient>? patients}) {
    return HouseholdState(patients: patients ?? this.patients);
  }

  /// Get patients sorted by priority (Critical > Low Stock > Stable)
  List<Patient> get sortedPatients {
    final sorted = List<Patient>.from(patients);
    sorted.sort((a, b) {
      // Critical patients first
      if (a.status == PatientStatus.critical &&
          b.status != PatientStatus.critical) {
        return -1;
      }
      if (b.status == PatientStatus.critical &&
          a.status != PatientStatus.critical) {
        return 1;
      }

      // Then low stock alerts
      if (a.hasLowStock && !b.hasLowStock) {
        return -1;
      }
      if (b.hasLowStock && !a.hasLowStock) {
        return 1;
      }

      // Then by status
      if (a.status != b.status) {
        return a.status.index.compareTo(b.status.index);
      }

      return 0;
    });
    return sorted;
  }

  /// Get global status summary
  String get statusSummary {
    final criticalCount = patients
        .where((p) => p.status == PatientStatus.critical)
        .length;
    final lowStockCount = patients.where((p) => p.hasLowStock).length;

    if (criticalCount > 0) {
      return '$criticalCount patient${criticalCount > 1 ? 's' : ''} need attention';
    }
    if (lowStockCount > 0) {
      final names = patients
          .where((p) => p.hasLowStock)
          .map((p) => p.name)
          .join(', ');
      return '$names ${lowStockCount > 1 ? 'are' : 'is'} low on medication';
    }
    return 'All vitals normal';
  }
}

/// Household Notifier
class HouseholdNotifier extends StateNotifier<HouseholdState> {
  HouseholdNotifier() : super(HouseholdState()) {
    // Initialize with mock data
    _initializeMockData();
  }

  void _initializeMockData() {
    // Mock data for demonstration
    state = HouseholdState(
      patients: [
        Patient(
          id: '1',
          name: 'Mom',
          status: PatientStatus.stable,
          isHome: true,
          vitalTrends: _generateMockTrends(),
          medications: [
            MedicationInventory(id: 'm1', name: 'Insulin', daysRemaining: 2),
            MedicationInventory(id: 'm2', name: 'Metformin', daysRemaining: 10),
          ],
        ),
        Patient(
          id: '2',
          name: 'Dad',
          status: PatientStatus.stable,
          isHome: false,
          vitalTrends: _generateMockTrends(),
          medications: [
            MedicationInventory(id: 'm3', name: 'Aspirin', daysRemaining: 15),
          ],
        ),
        Patient(
          id: '3',
          name: 'Grandma',
          status: PatientStatus.critical,
          isHome: true,
          vitalTrends: _generateMockTrends(),
          medications: [
            MedicationInventory(
              id: 'm4',
              name: 'Blood Pressure Med',
              daysRemaining: 5,
            ),
          ],
        ),
      ],
    );
  }

  List<VitalTrend> _generateMockTrends() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return VitalTrend(
        date: date,
        heartRate: 70 + (index * 2),
        bloodPressure: '${120 + index}/${80 + index}',
      );
    });
  }

  void addPatient(Patient patient) {
    state = state.copyWith(patients: [...state.patients, patient]);
  }

  void updatePatient(String id, Patient patient) {
    final updated = state.patients
        .map((p) => p.id == id ? patient : p)
        .toList();
    state = state.copyWith(patients: updated);
  }

  void removePatient(String id) {
    state = state.copyWith(
      patients: state.patients.where((p) => p.id != id).toList(),
    );
  }
}

/// Household Provider
final householdProvider =
    StateNotifierProvider<HouseholdNotifier, HouseholdState>((ref) {
      return HouseholdNotifier();
    });
