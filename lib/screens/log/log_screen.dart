import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/walk_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

final walkLogProvider = FutureProvider<List<Map<String,dynamic>>>((ref) => WalkService.getWalkLog());

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(walkLogProvider);
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('내 산책', style: AppTextStyles.headline(AppColors.ink)),
        ),
        Expanded(child: log.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('기록을 불러올 수 없어요.', style: AppTextStyles.body(AppColors.ink))),
          data: (walks) => walks.isEmpty
            ? Center(child: Text('아직 기록이 없어요.\n첫 산책을 시작해보세요!', textAlign: TextAlign.center, style: AppTextStyles.body(AppColors.ink)))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: walks.length,
                itemBuilder: (_, i) {
                  final w = walks[i];
                  final date = DateTime.parse(w['started_at'] as String);
                  final quests = (w['walk_quests'] as List).length;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.paper2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${date.month}/${date.day}  ${date.hour}:${date.minute.toString().padLeft(2,'0')}',
                        style: AppTextStyles.label(AppColors.copper)),
                      const SizedBox(height: 4),
                      Text('${w['duration']}분 산책  ·  퀘스트 ${quests}개',
                        style: AppTextStyles.body(AppColors.ink)),
                    ]),
                  );
                },
              ),
        )),
      ])),
    );
  }
}
