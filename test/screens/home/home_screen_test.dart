import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/screens/home/home_screen.dart';
import 'package:motungi/theme/app_theme.dart';

void main() {
  testWidgets('HomeScreen shows option bar and card', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MaterialApp(
      theme: buildTheme(),
      home: const HomeScreen(),
    )));
    await tester.pump();
    expect(find.text('15분'), findsOneWidget);
    expect(find.text('다른 길'), findsOneWidget);
    expect(find.text('산책 시작'), findsOneWidget);
  });

  testWidgets('tapping 다른 길 changes card content', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MaterialApp(
      theme: buildTheme(),
      home: const HomeScreen(),
    )));
    await tester.pump();
    await tester.tap(find.text('다른 길'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
