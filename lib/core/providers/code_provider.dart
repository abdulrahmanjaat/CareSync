import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';

/// Code Type
enum CodeType { caregiverCode, patientInviteCode }

/// Access Code Model
class AccessCode {
  final String id;
  final String code;
  final CodeType type;
  final String generatedByUserId; // User who generated the code
  final String? patientId; // For caregiver codes - which patient
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isUsed;
  final String? usedByUserId; // Who used the code
  final DateTime? usedAt;

  AccessCode({
    required this.id,
    required this.code,
    required this.type,
    required this.generatedByUserId,
    this.patientId,
    required this.createdAt,
    required this.expiresAt,
    this.isUsed = false,
    this.usedByUserId,
    this.usedAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isValid => !isUsed && !isExpired;

  AccessCode copyWith({
    String? id,
    String? code,
    CodeType? type,
    String? generatedByUserId,
    String? patientId,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isUsed,
    String? usedByUserId,
    DateTime? usedAt,
  }) {
    return AccessCode(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      generatedByUserId: generatedByUserId ?? this.generatedByUserId,
      patientId: patientId ?? this.patientId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isUsed: isUsed ?? this.isUsed,
      usedByUserId: usedByUserId ?? this.usedByUserId,
      usedAt: usedAt ?? this.usedAt,
    );
  }
}

/// Code State
class CodeState {
  final List<AccessCode> codes;

  CodeState({this.codes = const []});

  CodeState copyWith({List<AccessCode>? codes}) {
    return CodeState(codes: codes ?? this.codes);
  }
}

/// Code Notifier
class CodeNotifier extends StateNotifier<CodeState> {
  CodeNotifier() : super(CodeState());

  /// Generate a random 6-digit code
  String _generateCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Generate caregiver code for a patient
  AccessCode generateCaregiverCode(String generatedByUserId, String patientId) {
    final code = AccessCode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: _generateCode(),
      type: CodeType.caregiverCode,
      generatedByUserId: generatedByUserId,
      patientId: patientId,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 7)), // Expires in 7 days
    );

    state = state.copyWith(codes: [...state.codes, code]);
    return code;
  }

  /// Generate patient invite code
  AccessCode generatePatientInviteCode(String generatedByUserId) {
    final code = AccessCode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      code: _generateCode(),
      type: CodeType.patientInviteCode,
      generatedByUserId: generatedByUserId,
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(Duration(days: 30)), // Expires in 30 days
    );

    state = state.copyWith(codes: [...state.codes, code]);
    return code;
  }

  /// Use a code
  bool useCode(String code, String usedByUserId) {
    final codeIndex = state.codes.indexWhere((c) => c.code == code);
    if (codeIndex == -1) return false;

    final accessCode = state.codes[codeIndex];
    if (!accessCode.isValid) return false;

    final updatedCode = accessCode.copyWith(
      isUsed: true,
      usedByUserId: usedByUserId,
      usedAt: DateTime.now(),
    );

    final updatedCodes = List<AccessCode>.from(state.codes);
    updatedCodes[codeIndex] = updatedCode;
    state = state.copyWith(codes: updatedCodes);

    return true;
  }

  /// Get active codes for a user
  List<AccessCode> getActiveCodes(String userId) {
    return state.codes
        .where((c) => c.generatedByUserId == userId && c.isValid)
        .toList();
  }

  /// Get caregiver code for a patient
  AccessCode? getCaregiverCodeForPatient(String patientId) {
    try {
      return state.codes.firstWhere(
        (c) => c.patientId == patientId &&
            c.type == CodeType.caregiverCode &&
            c.isValid,
      );
    } catch (e) {
      return null;
    }
  }

  /// Revoke a code
  void revokeCode(String codeId) {
    final updatedCodes = state.codes
        .map((c) => c.id == codeId ? c.copyWith(isUsed: true) : c)
        .toList();
    state = state.copyWith(codes: updatedCodes);
  }
}

/// Code Provider
final codeProvider = StateNotifierProvider<CodeNotifier, CodeState>((ref) {
  return CodeNotifier();
});

