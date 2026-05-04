import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/screens/auth/auth_screen.dart';
import 'package:motungi/theme/app_theme.dart';

void main() {
  testWidgets('AuthScreen shows email field and social buttons', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MaterialApp(
      theme: buildTheme(),
      home: const AuthScreen(),
    )));
    expect(find.byType(TextField), findsWidgets);
    expect(find.text('Apple로 계속'), findsOneWidget);
    expect(find.text('구글로 계속'), findsOneWidget);
    expect(find.text('카카오로 계속'), findsOneWidget);
  });

  testWidgets('submit button disabled when email invalid', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MaterialApp(
      theme: buildTheme(),
      home: const AuthScreen(),
    )));
    final btn = tester.widget<GestureDetector>(
      find.ancestor(of: find.text('로그인'), matching: find.byType(GestureDetector)).first,
    );
    expect(btn.onTap, isNull);
  });

  testWidgets('mode toggles between login and signup', (tester) async {
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    tester.binding.window.physicalSizeTestValue = const Size(800, 1600);

    await tester.pumpWidget(ProviderScope(child: MaterialApp(
      theme: buildTheme(),
      home: const AuthScreen(),
    )));
    expect(find.text('처음이신가요?'), findsOneWidget);

    // Scroll to bottom to find the toggle button
    await tester.dragUntilVisible(
      find.text('회원가입'),
      find.byType(SingleChildScrollView),
      const Offset(0, -300),
    );

    await tester.tap(find.text('회원가입'));
    await tester.pumpAndSettle();
    expect(find.text('이미 계정이 있나요?'), findsOneWidget);
  });
}
