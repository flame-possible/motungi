import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/route_engine.dart';

class WalkSession {
  final RouteResult route;
  final int duration;
  final DateTime startedAt;
  final Set<int> completedQuestIds;
  const WalkSession({required this.route, required this.duration, required this.startedAt, this.completedQuestIds = const {}});
  WalkSession copyWith({Set<int>? completedQuestIds}) =>
    WalkSession(route: route, duration: duration, startedAt: startedAt, completedQuestIds: completedQuestIds ?? this.completedQuestIds);
}

class WalkSessionNotifier extends StateNotifier<WalkSession?> {
  WalkSessionNotifier() : super(null);
  void start(RouteResult route, int duration) =>
    state = WalkSession(route: route, duration: duration, startedAt: DateTime.now());
  void completeQuest(int questId) {
    if (state == null) return;
    state = state!.copyWith(completedQuestIds: {...state!.completedQuestIds, questId});
  }
  void finish() => state = null;
}

final walkSessionProvider = StateNotifierProvider<WalkSessionNotifier, WalkSession?>(
  (ref) => WalkSessionNotifier(),
);
