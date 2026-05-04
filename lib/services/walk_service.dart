import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../logic/route_engine.dart';

class WalkService {
  static Future<String?> startWalk({
    required RouteResult route,
    required int duration,
    required String mood,
    required String purpose,
  }) async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      final res = await SupabaseService.client.from('walks').insert({
        'user_id': userId,
        'duration': duration,
        'mood': mood,
        'purpose': purpose,
        'distance_m': (route.distanceKm * 1000).round(),
        'started_at': DateTime.now().toIso8601String(),
      }).select().single();
      return res['id'] as String;
    } catch (_) {
      return null;
    }
  }

  static Future<void> completeQuest({required String walkId, required String questId, String? memo}) async {
    try {
      await SupabaseService.client.from('walk_quests').insert({
        'walk_id': walkId,
        'quest_id': questId,
        'memo': memo,
        'completed_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {}
  }

  static Future<void> finishWalk(String walkId) async {
    try {
      await SupabaseService.client.from('walks').update({
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', walkId);
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> getWalkLog() async {
    try {
      final userId = SupabaseService.client.auth.currentUser?.id;
      if (userId == null) return [];
      return await SupabaseService.client
        .from('walks')
        .select('*, walk_quests(*)')
        .eq('user_id', userId)
        .order('started_at', ascending: false)
        .limit(30);
    } catch (_) {
      return [];
    }
  }
}
