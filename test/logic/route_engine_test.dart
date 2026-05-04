import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/logic/seeded_random.dart';
import 'package:motungi/logic/route_engine.dart';

void main() {
  test('seededRandom returns same value for same seed+n', () {
    expect(seededRandom(42, 0), seededRandom(42, 0));
    expect(seededRandom(42, 1), isNot(seededRandom(42, 0)));
  });

  test('seededRandom returns value between 0 and 1', () {
    for (int i = 0; i < 100; i++) {
      final v = seededRandom(i, i);
      expect(v, greaterThanOrEqualTo(0));
      expect(v, lessThan(1));
    }
  });

  test('getQuests returns 1 quest for 10min', () {
    final q = getQuests(duration: 10, purpose: 'recovery', seed: 1);
    expect(q.length, 1);
  });

  test('getQuests returns 2 quests for 20min', () {
    final q = getQuests(duration: 20, purpose: 'clearing', seed: 1);
    expect(q.length, 2);
  });

  test('getQuests returns 3 quests for 30min', () {
    final q = getQuests(duration: 30, purpose: 'exploration', seed: 1);
    expect(q.length, 3);
  });

  test('getQuests same seed gives same result', () {
    final a = getQuests(duration: 20, purpose: 'recovery', seed: 7);
    final b = getQuests(duration: 20, purpose: 'recovery', seed: 7);
    expect(a.map((q)=>q.id).toList(), b.map((q)=>q.id).toList());
  });

  test('getRoute returns flavor matching purpose+mood', () {
    final r = getRoute(duration: 20, mood: 'quiet', purpose: 'recovery', seed: 0);
    expect(r.flavorName, isNotEmpty);
    expect(r.distanceKm, closeTo(20/60*4, 0.01));
  });
}
