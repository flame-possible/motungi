import 'package:flutter/material.dart';
import '../../../data/quests.dart';
import '../../../logic/route_engine.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import 'illustrated_map.dart';

class CourseCard extends StatelessWidget {
  final RouteResult route;
  final int duration;
  final String mood;

  const CourseCard({super.key, required this.route, required this.duration, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.paper2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: IllustratedMap(duration: duration, mood: mood),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(route.flavorName, style: AppTextStyles.cardTitle(AppColors.ink)),
            const SizedBox(height: 4),
            Text(route.flavorDesc, style: AppTextStyles.body(AppColors.ink)),
            const SizedBox(height: 4),
            Text('약 ${route.distanceKm.toStringAsFixed(1)}km',
              style: AppTextStyles.label(AppColors.copper)),
            const SizedBox(height: 12),
            ...route.quests.map((q) => _QuestChip(quest: q)),
          ]),
        ),
      ]),
    );
  }
}

class _QuestChip extends StatelessWidget {
  final Quest quest;
  const _QuestChip({required this.quest});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Text(_catEmoji(quest.cat), style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Expanded(child: Text(quest.text, style: AppTextStyles.questText(AppColors.ink))),
      ]),
    );
  }

  String _catEmoji(String cat) => const {'관찰':'👁','감각':'🌿','경로':'🚶','사진':'📷','발견':'✦'}[cat]!;
}
