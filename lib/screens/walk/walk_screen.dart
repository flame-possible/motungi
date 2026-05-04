import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/walk_session_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'widgets/live_map.dart';

class WalkScreen extends ConsumerWidget {
  const WalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(walkSessionProvider);
    if (session == null) return const SizedBox.shrink();

    final elapsed = DateTime.now().difference(session.startedAt).inMinutes;
    final progress = (elapsed / session.duration).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('산책 중', style: AppTextStyles.headline(AppColors.ink)),
            Text('${elapsed}분 경과', style: AppTextStyles.label(AppColors.copper)),
          ]),
        ),
        LiveMap(duration: session.duration, progress: progress),
        Expanded(child: ListView(
          padding: const EdgeInsets.all(16),
          children: session.route.quests.map((q) {
            final done = session.completedQuestIds.contains(q.id);
            return GestureDetector(
              onTap: () => ref.read(walkSessionProvider.notifier).completeQuest(q.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: done ? AppColors.moss.withValues(alpha: 0.15) : AppColors.paper2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: done ? AppColors.moss : AppColors.border),
                ),
                child: Row(children: [
                  Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: done ? AppColors.moss : AppColors.border, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(q.text,
                    style: AppTextStyles.questText(done ? AppColors.moss : AppColors.ink),
                    decoration: done ? TextDecoration.lineThrough : null)),
                ]),
              ),
            );
          }).toList(),
        )),
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () => ref.read(walkSessionProvider.notifier).finish(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(12)),
              child: Center(child: Text('산책 완료', style: AppTextStyles.body(AppColors.paper))),
            ),
          ),
        ),
      ])),
    );
  }
}
