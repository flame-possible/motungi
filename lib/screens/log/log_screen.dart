import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('내 산책', style: AppTextStyles.headline(AppColors.ink)),
          const SizedBox(height: 8),
          Text('기록이 쌓이면 여기에 보여요.', style: AppTextStyles.body(AppColors.ink)),
        ]),
      )),
    );
  }
}
