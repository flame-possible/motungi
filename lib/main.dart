import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/supabase_service.dart';
import 'theme/t.dart';
import 'theme/app_theme.dart';
import 'logic/route_engine.dart';
import 'screens/home/home_screen.dart';
import 'screens/walk/walk_screen.dart';
import 'screens/complete/complete_screen.dart';
import 'screens/log/log_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/auth/auth_screen.dart';

// ── Supabase credentials ──────────────────────────────────────────────────────
const _supabaseUrl =
    'https://mvnvrtnusypkiwuvtibr.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    '.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im12bnZydG51c3lwa2l3dXZ0aWJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc4NzQ0NDMsImV4cCI6MjA5MzQ1MDQ0M30'
    '.OpIFJQ26B2bJftq_IAguVIjD_MP4TwWLOQ3vQolaOmM';

// ── Entry point ───────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  runApp(const ProviderScope(child: MotungiApp()));
}

// ── Root app ──────────────────────────────────────────────────────────────────

class MotungiApp extends StatelessWidget {
  const MotungiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, tokens, _) {
        return MaterialApp(
          title: '모퉁이',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(dark: tokens.isDark),
          home: const _AppShell(),
        );
      },
    );
  }
}

// ── App shell ─────────────────────────────────────────────────────────────────

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  // ── Tab ──
  String _tab = 'home'; // 'home' | 'log'

  // ── Screen stack ──
  // 'home' | 'walk' | 'complete' | 'settings' | 'auth'
  String _screen = 'home';

  // ── Theme ──
  String _themeMode = 'auto'; // 'auto' | 'light' | 'dark'

  // ── Walk preferences ──
  int _defaultDur = 20;
  String _neighborhood = '서울';
  String _locationName = '홈';

  // ── Auth ──
  Map<String, dynamic>? _user;

  // ── Log data ──
  List<Map<String, dynamic>> _logs = [];

  // ── Active walk data ──
  Map<String, dynamic>? _activeWalk;
  Map<String, dynamic>? _completeResult;

  // ── Derived ──
  bool get _hasWalkedToday {
    final today = DateTime.now();
    final todayStr = '${today.month}/${today.day}';
    return _logs.any((l) => l['date'] == todayStr);
  }

  bool get _showTabBar =>
      _screen == 'home' || _screen == 'log';

  // ── Theme logic ──────────────────────────────────────────────────────────

  void _applyTheme(String mode) {
    final hour = DateTime.now().hour;
    final isDark =
        mode == 'dark' || (mode == 'auto' && (hour >= 20 || hour < 6));
    themeTokensNotifier.value = isDark ? kDarkTokens : kLightTokens;
  }

  void _setTheme(String mode) {
    setState(() => _themeMode = mode);
    _applyTheme(mode);
  }

  // ── Navigation handlers ──────────────────────────────────────────────────

  void _goHome() => setState(() {
        _screen = 'home';
        _tab = 'home';
      });

  void _onTabSwitch(String tab) => setState(() {
        _tab = tab;
        _screen = tab == 'log' ? 'log' : 'home';
      });

  void _onStartWalk(Map<String, dynamic> walkData) {
    setState(() {
      _activeWalk = walkData;
      _screen = 'walk';
    });
  }

  /// Called when WalkScreen closes (both cancel and finish).
  /// We always move to CompleteScreen if there's active walk data.
  void _onWalkClose() {
    if (_activeWalk == null) {
      _goHome();
      return;
    }
    // Build complete result from the active walk.
    // WalkScreen doesn't expose elapsed/completed via onClose, so we pass
    // sensible defaults. The user can still fill the memo.
    final route = getRoute(
      duration: _activeWalk!['dur'] as int? ?? _activeWalk!['duration'] as int? ?? _defaultDur,
      mood: _activeWalk!['mood'] as String? ?? 'lively',
      purpose: _activeWalk!['purpose'] as String? ?? _activeWalk!['purp'] as String? ?? 'recovery',
      seed: _activeWalk!['seed'] as int? ?? 0,
    );
    setState(() {
      _completeResult = {
        'route': route,
        'elapsed': 0,
        'quests': route.quests,
        'completed': 0,
      };
      _screen = 'complete';
    });
  }

  void _onDone(String note) {
    final now = DateTime.now();
    final route = _completeResult!['route'] as RouteResult;
    final log = {
      'date': '${now.month}/${now.day}',
      'route': route,
      'duration':
          _activeWalk!['dur'] as int? ?? _activeWalk!['duration'] as int? ?? _defaultDur,
      'completed': _completeResult!['completed'] as int? ?? 0,
      'total': (_completeResult!['quests'] as List).length,
      'note': note,
      'elapsed': _completeResult!['elapsed'] as int? ?? 0,
    };
    setState(() {
      _logs = [log, ..._logs];
      _activeWalk = null;
      _completeResult = null;
      _screen = 'home';
      _tab = 'home';
    });
  }

  void _onOpenSettings() => setState(() => _screen = 'settings');
  void _onCloseSettings() => setState(() => _screen = _tab == 'log' ? 'log' : 'home');

  void _onOpenAuth() => setState(() => _screen = 'auth');
  void _onCloseAuth() => setState(() => _screen = _tab == 'log' ? 'log' : 'home');

  void _onAuth(Map<String, dynamic> user) {
    setState(() {
      _user = user;
      _screen = _tab == 'log' ? 'log' : 'home';
    });
  }

  void _onSignout() => setState(() => _user = null);

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        return Scaffold(
          backgroundColor: t.bg,
          body: _buildCurrentScreen(),
          bottomNavigationBar: _showTabBar ? _buildTabBar(t) : null,
        );
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (_screen) {
      case 'walk':
        return WalkScreen(
          walk: _activeWalk ?? {},
          onClose: _onWalkClose,
        );

      case 'complete':
        return CompleteScreen(
          result: _completeResult ?? {},
          onDone: _onDone,
          neighborhood: _neighborhood,
          locationName: _locationName,
        );

      case 'settings':
        return SettingsScreen(
          user: _user,
          onAuthEntry: _onOpenAuth,
          onSignout: _onSignout,
          themeMode: _themeMode,
          setTheme: _setTheme,
          defaultDur: _defaultDur,
          setDefaultDur: (v) => setState(() => _defaultDur = v),
          neighborhood: _neighborhood,
          locationName: _locationName,
          onLocationEdit: () {},
          onClose: _onCloseSettings,
        );

      case 'auth':
        return AuthScreen(
          user: _user,
          onAuth: _onAuth,
          onSignout: _onSignout,
          onClose: _onCloseAuth,
        );

      case 'log':
        return LogScreen(
          logs: _logs,
          user: _user,
          onBack: _goHome,
          onAuthEntry: _onOpenAuth,
          neighborhood: _neighborhood,
          locationName: _locationName,
        );

      case 'home':
      default:
        return HomeScreen(
          logs: _logs,
          hasWalkedToday: _hasWalkedToday,
          defaultDur: _defaultDur,
          neighborhood: _neighborhood,
          locationName: _locationName,
          onStart: _onStartWalk,
          onTab: _onTabSwitch,
          onSettings: _onOpenSettings,
        );
    }
  }

  Widget _buildTabBar(AppThemeTokens t) {
    return Container(
      decoration: BoxDecoration(
        color: t.paper,
        border: Border(top: BorderSide(color: t.rule, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _TabItem(
              label: '오늘',
              active: _tab == 'home',
              t: t,
              onTap: () => _onTabSwitch('home'),
            ),
            _TabItem(
              label: '기록',
              active: _tab == 'log',
              t: t,
              onTap: () => _onTabSwitch('log'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab item ──────────────────────────────────────────────────────────────────

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final AppThemeTokens t;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.active,
    required this.t,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Copper top indicator when active
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 2,
              color: active ? t.copper : Colors.transparent,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active ? t.ink : t.ink3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
