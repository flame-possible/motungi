import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_service.dart';
import 'screens/home/home_screen.dart';
import 'screens/log/log_screen.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  const supabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    await SupabaseService.init(url: supabaseUrl, anonKey: supabaseKey);
  }
  runApp(const ProviderScope(child: MotungiApp()));
}

class MotungiApp extends StatelessWidget {
  const MotungiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '모퉁이',
    theme: buildTheme(dark: false),
    darkTheme: buildTheme(dark: true),
    home: const _RootShell(),
  );
}

class _RootShell extends StatefulWidget {
  const _RootShell();
  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _idx = 0;
  static const _screens = [HomeScreen(), LogScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _screens[_idx],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _idx,
      onTap: (i) => setState(() => _idx = i),
      backgroundColor: AppColors.paper2,
      selectedItemColor: AppColors.ink,
      unselectedItemColor: AppColors.border,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '오늘'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: '기록'),
      ],
    ),
  );
}
