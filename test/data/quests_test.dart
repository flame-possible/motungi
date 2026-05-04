import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/data/quests.dart';

void main() {
  test('quests list has 50 entries', () {
    expect(quests.length, greaterThanOrEqualTo(50));
  });

  test('each quest has required fields', () {
    for (final q in quests) {
      expect(q.id, isNotNull);
      expect(q.text, isNotEmpty);
      expect(['관찰','감각','경로','사진','발견'], contains(q.cat));
    }
  });

  test('easy quests exist', () {
    expect(quests.where((q) => q.easy).length, greaterThan(0));
  });
}
