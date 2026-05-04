import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MotungiApp()));
}

class MotungiApp extends StatelessWidget {
  const MotungiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모퉁이',
      theme: buildTheme(dark: false),
      darkTheme: buildTheme(dark: true),
      home: const HomeScreen(),
    );
  }
}
