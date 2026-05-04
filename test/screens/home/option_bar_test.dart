import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/screens/home/widgets/option_bar.dart';
import 'package:motungi/theme/app_theme.dart';

void main() {
  testWidgets('AdjustBar collapsed shows summary and swap button', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(
        body: AdjustBar(
          dur: 20,
          mood: '활기',
          purp: '회복',
          showOptions: false,
          showCustom: false,
          custom: '',
          onToggleOptions: () {},
          onSwap: () {},
          onDurChanged: (_) {},
          onMoodChanged: (_) {},
          onPurpChanged: (_) {},
          onToggleCustom: () {},
          onCustomChanged: (_) {},
        ),
      ),
    ));
    expect(find.text('조정→'), findsOneWidget);
    expect(find.text('↻'), findsOneWidget);
  });

  testWidgets('AdjustBar expanded shows mood chips', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: AdjustBar(
            dur: 20,
            mood: '활기',
            purp: '회복',
            showOptions: true,
            showCustom: false,
            custom: '',
            onToggleOptions: () {},
            onSwap: () {},
            onDurChanged: (_) {},
            onMoodChanged: (_) {},
            onPurpChanged: (_) {},
            onToggleCustom: () {},
            onCustomChanged: (_) {},
          ),
        ),
      ),
    ));
    expect(find.text('고요'), findsOneWidget);
    expect(find.text('활기'), findsOneWidget);
    expect(find.text('즉흥'), findsOneWidget);
  });
}
