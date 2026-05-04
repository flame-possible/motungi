import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logic/route_engine.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/option_bar.dart';
import 'widgets/course_card.dart';

final _homeStateProvider = StateNotifierProvider<_HomeNotifier, _HomeState>((ref) => _HomeNotifier());

class _HomeState {
  final int duration;
  final String mood;
  final String purpose;
  final int seed;
  const _HomeState({this.duration=15, this.mood='quiet', this.purpose='recovery', this.seed=0});
  _HomeState copyWith({int? duration, String? mood, String? purpose, int? seed}) =>
    _HomeState(duration: duration??this.duration, mood: mood??this.mood, purpose: purpose??this.purpose, seed: seed??this.seed);
}

class _HomeNotifier extends StateNotifier<_HomeState> {
  _HomeNotifier() : super(const _HomeState());
  void setDuration(int v) => state = state.copyWith(duration: v);
  void setMood(String v)  => state = state.copyWith(mood: v);
  void setPurpose(String v) => state = state.copyWith(purpose: v);
  void swap() => state = state.copyWith(seed: state.seed + 1);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(_homeStateProvider);
    final notifier = ref.read(_homeStateProvider.notifier);
    final route = getRoute(duration: s.duration, mood: s.mood, purpose: s.purpose, seed: s.seed);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16,16,16,4),
          child: Text(_headline(), style: AppTextStyles.headline(AppColors.ink)),
        ),
        OptionBar(
          duration: s.duration, mood: s.mood, purpose: s.purpose,
          onDurationChanged: notifier.setDuration,
          onMoodChanged: notifier.setMood,
          onPurposeChanged: notifier.setPurpose,
        ),
        Expanded(child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim,
                child: SlideTransition(position: Tween(begin: const Offset(0,.04), end: Offset.zero).animate(anim), child: child)),
              child: KeyedSubtree(
                key: ValueKey('${s.duration}_${s.mood}_${s.purpose}_${s.seed}'),
                child: CourseCard(route: route, duration: s.duration, mood: s.mood),
              ),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _OutlineButton(label: '다른 길', onTap: notifier.swap),
              const SizedBox(width: 12),
              _FilledButton(label: '산책 시작', onTap: () {}),
            ]),
            const SizedBox(height: 24),
          ]),
        )),
      ])),
    );
  }

  String _headline() {
    final h = DateTime.now().hour;
    if (h < 6)  return '깊은 밤의 걸음';
    if (h < 11) return '아침이 왔습니다';
    if (h < 14) return '점심 산책 어때요';
    if (h < 17) return '오후의 햇살';
    if (h < 19) return '황금빛 시간이에요';
    if (h < 22) return '저녁 산책 시간';
    return '밤의 동네';
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.ink),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label, style: AppTextStyles.body(AppColors.ink)),
    ),
  );
}

class _FilledButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FilledButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(label, style: AppTextStyles.body(AppColors.paper)),
    ),
  );
}
