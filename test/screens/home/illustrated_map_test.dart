import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/screens/home/widgets/illustrated_map.dart';
import 'package:motungi/theme/app_theme.dart';

void main() {
  testWidgets('IllustratedMap renders without error', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: IllustratedMap(duration: 20, mood: 'quiet')),
    ));
    expect(find.byType(IllustratedMap), findsOneWidget);
  });

  testWidgets('IllustratedMap animates on mount', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: IllustratedMap(duration: 20, mood: 'quiet')),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 800));
    expect(tester.takeException(), isNull);
  });
}
