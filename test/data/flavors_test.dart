import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/data/flavors.dart';

void main() {
  test('all purpose+mood combinations exist', () {
    final purposes = ['recovery','clearing','reflection','exploration'];
    final moods    = ['quiet','lively','spontaneous'];
    for (final p in purposes) {
      for (final m in moods) {
        expect(flavors['${p}_$m'], isNotNull, reason: '${p}_$m missing');
      }
    }
  });

  test('each flavor has name and desc', () {
    for (final entry in flavors.values) {
      expect(entry.name, isNotEmpty);
      expect(entry.desc, isNotEmpty);
    }
  });
}
