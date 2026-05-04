import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/screens/walk/widgets/live_map.dart';
import 'package:motungi/theme/app_theme.dart';

void main() {
  testWidgets('LiveMap renders at progress 0', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: LiveMap(duration: 20, progress: 0)),
    ));
    expect(find.byType(LiveMap), findsOneWidget);
  });

  testWidgets('LiveMap renders at progress 1 (completed)', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(body: LiveMap(duration: 20, progress: 1)),
    ));
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });
}
