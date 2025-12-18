import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'household_provider.dart';

/// Inventory Alert
class InventoryAlert {
  final String patientId;
  final String patientName;
  final String medicationId;
  final String medicationName;
  final int daysRemaining;
  final DateTime alertDate;

  InventoryAlert({
    required this.patientId,
    required this.patientName,
    required this.medicationId,
    required this.medicationName,
    required this.daysRemaining,
    DateTime? alertDate,
  }) : alertDate = alertDate ?? DateTime.now();

  bool get isCritical => daysRemaining < 3;
}

/// Inventory State
class InventoryState {
  final List<InventoryAlert> alerts;

  InventoryState({this.alerts = const []});

  InventoryState copyWith({List<InventoryAlert>? alerts}) {
    return InventoryState(alerts: alerts ?? this.alerts);
  }

  List<InventoryAlert> get criticalAlerts {
    return alerts.where((a) => a.isCritical).toList();
  }

  List<InventoryAlert> get lowStockAlerts {
    return alerts.where((a) => a.daysRemaining < 7 && !a.isCritical).toList();
  }
}

/// Inventory Notifier
class InventoryNotifier extends StateNotifier<InventoryState> {
  final Ref ref;

  InventoryNotifier(this.ref) : super(InventoryState()) {
    // Watch household provider and generate alerts
    ref.listen<HouseholdState>(householdProvider, (previous, next) {
      _updateAlerts(next);
    });
    _updateAlerts(ref.read(householdProvider));
  }

  void _updateAlerts(HouseholdState household) {
    final alerts = <InventoryAlert>[];

    for (final patient in household.patients) {
      for (final medication in patient.medications) {
        if (medication.daysRemaining < 7) {
          alerts.add(
            InventoryAlert(
              patientId: patient.id,
              patientName: patient.name,
              medicationId: medication.id,
              medicationName: medication.name,
              daysRemaining: medication.daysRemaining,
            ),
          );
        }
      }
    }

    state = InventoryState(alerts: alerts);
  }

  void dismissAlert(String medicationId) {
    state = state.copyWith(
      alerts: state.alerts
          .where((a) => a.medicationId != medicationId)
          .toList(),
    );
  }

  void generateRestockList() {
    // Generate shopping list from all low stock medications
    final allMedications = <String, int>{};
    for (final alert in state.alerts) {
      if (allMedications.containsKey(alert.medicationName)) {
        allMedications[alert.medicationName] =
            (allMedications[alert.medicationName]! + 1);
      } else {
        allMedications[alert.medicationName] = 1;
      }
    }
    // TODO: Implement shopping list generation/export
  }
}

/// Inventory Provider
final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
      return InventoryNotifier(ref);
    });
