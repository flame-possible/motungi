import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/headlines.dart';
import '../../logic/route_engine.dart';
import '../../theme/t.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/option_bar.dart';
import 'widgets/course_card.dart';

// ── State ────────────────────────────────────────────────────────────────────

class HomeState {
  final int dur;
  final String mood;   // 고요 | 활기 | 즉흥
  final String purp;   // 회복 | 환기 | 사색 | 탐험
  final int seed;
  final bool showOptions;
  final bool showCustom;
  final String custom;
  final bool swapping;

  const HomeState({
    this.dur = 20,
    this.mood = '활기',
    this.purp = '회복',
    this.seed = 0,
    this.showOptions = false,
    this.showCustom = false,
    this.custom = '',
    this.swapping = false,
  });

  HomeState copyWith({
    int? dur,
    String? mood,
    String? purp,
    int? seed,
    bool? showOptions,
    bool? showCustom,
    String? custom,
    bool? swapping,
  }) =>
      HomeState(
        dur: dur ?? this.dur,
        mood: mood ?? this.mood,
        purp: purp ?? this.purp,
        seed: seed ?? this.seed,
        showOptions: showOptions ?? this.showOptions,
        showCustom: showCustom ?? this.showCustom,
        custom: custom ?? this.custom,
        swapping: swapping ?? this.swapping,
      );

  /// Effective duration: custom input when valid, otherwise preset
  int get effectiveDur =>
      showCustom && custom.isNotEmpty
          ? (int.tryParse(custom) ?? dur).clamp(3, 60)
          : dur;

  /// English mood key for route engine
  String get moodEn {
    const map = {'고요': 'quiet', '활기': 'lively', '즉흥': 'spontaneous'};
    return map[mood] ?? 'lively';
  }

  /// English purpose key for route engine
  String get purpEn {
    const map = {'회복': 'recovery', '환기': 'clearing', '사색': 'reflection', '탐험': 'exploration'};
    return map[purp] ?? 'recovery';
  }
}

class _HomeNotifier extends StateNotifier<HomeState> {
  _HomeNotifier() : super(const HomeState());

  void setDur(int v) => state = state.copyWith(dur: v);
  void setMood(String v) => state = state.copyWith(mood: v);
  void setPurp(String v) => state = state.copyWith(purp: v);
  void setCustom(String v) => state = state.copyWith(custom: v);
  void toggleOptions() =>
      state = state.copyWith(showOptions: !state.showOptions);
  void toggleCustom() =>
      state = state.copyWith(showCustom: !state.showCustom, custom: '');
  void swap() => state = state.copyWith(seed: state.seed + 1);
}

final _homeStateProvider =
    StateNotifierProvider<_HomeNotifier, HomeState>((_) => _HomeNotifier());

// ── HomeScreen ───────────────────────────────────────────────────────────────

class HomeScreen extends ConsumerWidget {
  final List<Map<String, dynamic>> logs;
  final bool hasWalkedToday;
  final int defaultDur;
  final String neighborhood;
  final String locationName;
  final void Function(Map<String, dynamic> walkData) onStart;
  final void Function(String tab) onTab;
  final VoidCallback onSettings;

  const HomeScreen({
    super.key,
    this.logs = const [],
    this.hasWalkedToday = false,
    this.defaultDur = 20,
    this.neighborhood = '서울',
    this.locationName = '홈',
    this.onStart = _noop,
    this.onTab = _noopTab,
    this.onSettings = _noopVoid,
  });

  static void _noop(Map<String, dynamic> _) {}
  static void _noopTab(String _) {}
  static void _noopVoid() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(_homeStateProvider);
    final notifier = ref.read(_homeStateProvider.notifier);

    final route = getRoute(
      duration: s.effectiveDur,
      mood: s.moodEn,
      purpose: s.purpEn,
      seed: s.seed,
    );

    final headline = getHeadline(hasWalkedToday);
    final now = DateTime.now();
    final dateStr =
        '${now.year}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}';
    final dayStr = kDayKor[now.weekday % 7];

    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        return Scaffold(
          backgroundColor: t.bg,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. TopBar
                  _TopBar(
                    dateStr: dateStr,
                    dayStr: dayStr,
                    locationName: locationName,
                    t: t,
                    onSettings: onSettings,
                  ),

                  // 2. Headline greeting
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                    child: _Headline(headline: headline, t: t),
                  ),

                  // 3. Course Card
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: AnimatedOpacity(
                      opacity: s.swapping ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: child,
                        ),
                        child: KeyedSubtree(
                          key: ValueKey(
                              '${s.effectiveDur}_${s.mood}_${s.purp}_${s.seed}'),
                          child: CourseCard(
                            route: route,
                            duration: s.effectiveDur,
                            mood: s.mood,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 4. AdjustBar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    child: AdjustBar(
                      dur: s.dur,
                      mood: s.mood,
                      purp: s.purp,
                      showOptions: s.showOptions,
                      showCustom: s.showCustom,
                      custom: s.custom,
                      onToggleOptions: notifier.toggleOptions,
                      onSwap: notifier.swap,
                      onDurChanged: notifier.setDur,
                      onMoodChanged: notifier.setMood,
                      onPurpChanged: notifier.setPurp,
                      onToggleCustom: notifier.toggleCustom,
                      onCustomChanged: notifier.setCustom,
                    ),
                  ),

                  // 5. CTA button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                    child: _CtaButton(
                      mood: s.mood,
                      t: t,
                      onTap: () => onStart({
                        'dur': s.effectiveDur,
                        'mood': s.moodEn,
                        'purpose': s.purpEn,
                        'seed': s.seed,
                        'flavorName': route.flavorName,
                        'flavorDesc': route.flavorDesc,
                        'distanceKm': route.distanceKm,
                      }),
                    ),
                  ),

                  // 6. Past walks link
                  if (logs.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
                      child: GestureDetector(
                        onTap: () => onTab('logs'),
                        child: Text(
                          '지난 산책 ${logs.length}개 →',
                          style: Ts.sans(13, FontWeight.w400, t.copperD)
                              .copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor: t.copperD),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── TopBar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String dateStr;
  final String dayStr;
  final String locationName;
  final AppThemeTokens t;
  final VoidCallback onSettings;

  const _TopBar({
    required this.dateStr,
    required this.dayStr,
    required this.locationName,
    required this.t,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: t.rule),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: dateStr,
                    style: TextStyle(
                      fontFeatures: const [FontFeature.tabularFigures()],
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: t.ink,
                    ),
                  ),
                  TextSpan(
                    text: ' · $dayStr요일 · $locationName',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: t.ink2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onSettings,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: t.paper2,
                border: Border.all(color: t.rule),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.settings_outlined, size: 18, color: t.ink2),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Headline ─────────────────────────────────────────────────────────────────

class _Headline extends StatelessWidget {
  final HeadlineParts headline;
  final AppThemeTokens t;

  const _Headline({required this.headline, required this.t});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: Ts.serif(18, FontWeight.w400, t.ink2),
        children: [
          TextSpan(text: '${headline.l1} '),
          TextSpan(
            text: headline.a,
            style: TextStyle(color: t.copper, fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: ' ${headline.l2}',
            style: TextStyle(color: t.ink),
          ),
        ],
      ),
    );
  }
}

// ── CTA button ───────────────────────────────────────────────────────────────

class _CtaButton extends StatelessWidget {
  final String mood;
  final AppThemeTokens t;
  final VoidCallback onTap;

  const _CtaButton({
    required this.mood,
    required this.t,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = mood == '즉흥'
        ? '출발 — 길은 그때 정해집니다'
        : '이 길로 걷기';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: t.ink,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 17),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Ts.sans(15, FontWeight.w800, t.paper),
        ),
      ),
    );
  }
}
