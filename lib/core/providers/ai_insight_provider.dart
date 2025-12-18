import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AI Insight Model
class AIInsight {
  final String id;
  final String message;
  final String type; // 'adherence', 'wellness', 'safety', 'tip'
  final DateTime createdAt;
  final bool isDismissed;

  AIInsight({
    required this.id,
    required this.message,
    required this.type,
    DateTime? createdAt,
    this.isDismissed = false,
  }) : createdAt = createdAt ?? DateTime.now();

  AIInsight copyWith({
    String? id,
    String? message,
    String? type,
    DateTime? createdAt,
    bool? isDismissed,
  }) {
    return AIInsight(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }
}

/// AI Insight Notifier
class AIInsightNotifier extends StateNotifier<List<AIInsight>> {
  AIInsightNotifier() : super([]) {
    _loadDefaultInsights();
  }

  void _loadDefaultInsights() {
    state = [
      AIInsight(
        id: '1',
        message: 'Your adherence is up 10% this week! Keep it up.',
        type: 'adherence',
      ),
      AIInsight(
        id: '2',
        message: 'Remember to drink water regularly throughout the day.',
        type: 'wellness',
      ),
    ];
  }

  void addInsight(AIInsight insight) {
    state = [...state, insight];
  }

  void dismissInsight(String id) {
    state = state.map((insight) {
      if (insight.id == id) {
        return insight.copyWith(isDismissed: true);
      }
      return insight;
    }).toList();
  }

  AIInsight? getActiveInsight() {
    return state.firstWhere(
      (insight) => !insight.isDismissed,
      orElse: () => AIInsight(id: '', message: '', type: ''),
    );
  }
}

/// AI Insight Provider
final aiInsightProvider =
    StateNotifierProvider<AIInsightNotifier, List<AIInsight>>((ref) {
      return AIInsightNotifier();
    });
