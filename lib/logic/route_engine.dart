import '../data/quests.dart';
import '../data/flavors.dart';
import 'seeded_random.dart';

class RouteResult {
  final String flavorName;
  final String flavorDesc;
  final double distanceKm;
  final List<Quest> quests;
  const RouteResult({required this.flavorName, required this.flavorDesc, required this.distanceKm, required this.quests});
}

const _questPref = <String, List<String>>{
  'recovery':    ['감각','관찰'],
  'clearing':    ['사진','감각'],
  'reflection':  ['감각','관찰'],
  'exploration': ['경로','발견'],
};

RouteResult getRoute({required int duration, required String mood, required String purpose, required int seed}) {
  final key    = '${purpose}_$mood';
  final flavor = flavors[key] ?? flavors['recovery_quiet']!;
  final dist   = (duration / 60) * 4;
  final qs     = getQuests(duration: duration, purpose: purpose, seed: seed);
  return RouteResult(flavorName: flavor.name, flavorDesc: flavor.desc, distanceKm: dist, quests: qs);
}

List<Quest> getQuests({required int duration, required String purpose, required int seed}) {
  final count = duration <= 10 ? 1 : duration <= 20 ? 2 : 3;
  final prefs = _questPref[purpose] ?? ['감각','관찰'];

  final preferred = quests.where((q) => prefs.contains(q.cat)).toList();
  final rest      = quests.where((q) => !prefs.contains(q.cat)).toList();
  final pool      = [...preferred, ...rest];

  final selected = <Quest>[];
  final used     = <int>{};
  int n = 0;
  while (selected.length < count) {
    final idx = (seededRandom(seed, n++) * pool.length).floor();
    if (!used.contains(idx)) {
      used.add(idx);
      selected.add(pool[idx]);
    }
  }
  return selected;
}
