import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class OptionBar extends StatelessWidget {
  final int duration;
  final String mood;
  final String purpose;
  final ValueChanged<int> onDurationChanged;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onPurposeChanged;

  const OptionBar({
    super.key,
    required this.duration,
    required this.mood,
    required this.purpose,
    required this.onDurationChanged,
    required this.onMoodChanged,
    required this.onPurposeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ...[5, 10, 15, 20, 30].map((d) => _chip(
            '${d}분',
            selected: duration == d,
            onTap: () => onDurationChanged(d),
          )),
          _CustomDurationChip(duration: duration, onChanged: onDurationChanged),
          const SizedBox(width: 8),
          _divider(),
          const SizedBox(width: 8),
          ...['quiet', 'lively', 'spontaneous'].map((m) => _chip(
            _moodLabel(m),
            selected: mood == m,
            onTap: () => onMoodChanged(m),
          )),
          const SizedBox(width: 8),
          _divider(),
          const SizedBox(width: 8),
          ...['recovery', 'clearing', 'reflection', 'exploration'].map((p) =>
            _chip(
              _purposeLabel(p),
              selected: purpose == p,
              onTap: () => onPurposeChanged(p),
            )),
        ],
      ),
    );
  }

  Widget _chip(
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.paper2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: AppTextStyles.label(
            selected ? AppColors.paper : AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 20,
    color: AppColors.border,
  );

  String _moodLabel(String m) =>
    const {'quiet': '고요', 'lively': '활기', 'spontaneous': '즉흥'}[m]!;

  String _purposeLabel(String p) => const {
    'recovery': '회복',
    'clearing': '환기',
    'reflection': '사색',
    'exploration': '탐험'
  }[p]!;
}

class _CustomDurationChip extends StatefulWidget {
  final int duration;
  final ValueChanged<int> onChanged;

  const _CustomDurationChip({
    required this.duration,
    required this.onChanged,
  });

  @override
  State<_CustomDurationChip> createState() => _CustomDurationChipState();
}

class _CustomDurationChipState extends State<_CustomDurationChip> {
  bool _editing = false;
  late TextEditingController _ctrl;

  bool get _isCustom => ![5, 10, 15, 20, 30].contains(widget.duration);

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return SizedBox(
        width: 60,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          style: AppTextStyles.label(AppColors.ink),
          onSubmitted: (v) {
            final n = int.tryParse(v);
            if (n != null && n >= 3 && n <= 60) {
              widget.onChanged(n);
            }
            setState(() => _editing = false);
          },
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        _ctrl.clear();
        setState(() => _editing = true);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isCustom ? AppColors.ink : AppColors.paper2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          _isCustom ? '${widget.duration}분' : '직접',
          style: AppTextStyles.label(
            _isCustom ? AppColors.paper : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
