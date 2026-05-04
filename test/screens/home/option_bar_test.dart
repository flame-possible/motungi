import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/screens/home/widgets/option_bar.dart';
import 'package:motungi/theme/app_theme.dart';

void main() {
  testWidgets('OptionBar shows duration chips', (tester) async {
    int selected = 15;
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: OptionBar(
        duration: selected,
        mood: 'quiet',
        purpose: 'recovery',
        onDurationChanged: (v) => selected = v,
        onMoodChanged: (_) {},
        onPurposeChanged: (_) {},
      )),
    ));
    expect(find.text('15분'), findsOneWidget);
    expect(find.text('30분'), findsOneWidget);
  });

  testWidgets('tapping duration chip calls onDurationChanged', (tester) async {
    int changed = 0;
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: OptionBar(
        duration: 15,
        mood: 'quiet',
        purpose: 'recovery',
        onDurationChanged: (v) => changed = v,
        onMoodChanged: (_) {},
        onPurposeChanged: (_) {},
      )),
    ));
    await tester.tap(find.text('30분'));
    expect(changed, 30);
  });
}
