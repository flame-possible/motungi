import '../data/quests.dart';
import '../data/flavors.dart';
import 'seeded_random.dart';

class RouteResult {
  final String flavorName;
  final String flavorDesc;
  final String illust;  // healing|breeze|reflection|explore
  final double distanceKm;
  final int duration;
  final List<Quest> quests;
  const RouteResult({
    required this.flavorName,
    required this.flavorDesc,
    required this.illust,
    required this.distanceKm,
    required this.duration,
    required this.quests,
  });
}

const kQuestPref = <String, List<String>>{
  '회복': ['감각', '관찰'],
  '환기': ['사진', '감각'],
  '사색': ['감각', '관찰'],
  '탐험': ['경로', '발견'],
};

// Maps English UI values to Korean flavor keys
const _purposeKo = <String, String>{
  'recovery': '회복',
  'clearing': '환기',
  'reflection': '사색',
  'exploration': '탐험',
};
const _moodKo = <String, String>{
  'quiet': '고요',
  'lively': '활기',
  'spontaneous': '즉흥',
};

RouteResult getRoute({required int duration, required String mood, required String purpose, required int seed}) {
  final purposeKo = _purposeKo[purpose] ?? purpose;
  final moodKo = _moodKo[mood] ?? mood;
  final key = '${purposeKo}_$moodKo';
  final pool = kFlavors[key] ?? kFlavors['회복_활기']!;
  final f = pool[seed.abs() % pool.length];
  final qs = getQuests(duration: duration, purpose: purposeKo, seed: seed);
  return RouteResult(
    flavorName: f.name,
    flavorDesc: f.desc,
    illust: kIllustByPurp[purposeKo] ?? 'healing',
    distanceKm: (duration / 60.0) * 4.0,
    duration: duration,
    quests: qs,
  );
}

List<Quest> getQuests({required int duration, required String purpose, required int seed}) {
  final count = duration <= 10 ? 1 : duration <= 20 ? 2 : 3;
  final pref = kQuestPref[purpose] ?? kQuestPref['회복']!;
  final scored = kQuests.asMap().entries.map((e) {
    final q = e.value;
    final i = e.key;
    final w = q.tags.any((t) => pref.contains(t)) ? 3.0 : 1.0;
    final r = seededRand(seed, i);
    return (quest: q, score: w + r * 2);
  }).toList();
  scored.sort((a, b) => b.score.compareTo(a.score));
  return scored.take(count).map((e) => e.quest).toList();
}
