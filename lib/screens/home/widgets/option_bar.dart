import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/t.dart';
import '../../../theme/app_text_styles.dart';

// ── Public callback interface ───────────────────────────────────────────────
class AdjustBar extends StatelessWidget {
  final int dur;
  final String mood;   // 고요 | 활기 | 즉흥
  final String purp;   // 회복 | 환기 | 사색 | 탐험
  final bool showOptions;
  final bool showCustom;
  final String custom;
  final VoidCallback onToggleOptions;
  final VoidCallback onSwap;
  final ValueChanged<int> onDurChanged;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onPurpChanged;
  final VoidCallback onToggleCustom;
  final ValueChanged<String> onCustomChanged;

  const AdjustBar({
    super.key,
    required this.dur,
    required this.mood,
    required this.purp,
    required this.showOptions,
    required this.showCustom,
    required this.custom,
    required this.onToggleOptions,
    required this.onSwap,
    required this.onDurChanged,
    required this.onMoodChanged,
    required this.onPurpChanged,
    required this.onToggleCustom,
    required this.onCustomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        return showOptions
            ? _ExpandedBar(
                dur: dur,
                mood: mood,
                purp: purp,
                showCustom: showCustom,
                custom: custom,
                t: t,
                onToggleOptions: onToggleOptions,
                onSwap: onSwap,
                onDurChanged: onDurChanged,
                onMoodChanged: onMoodChanged,
                onPurpChanged: onPurpChanged,
                onToggleCustom: onToggleCustom,
                onCustomChanged: onCustomChanged,
              )
            : _CollapsedBar(
                dur: dur,
                mood: mood,
                purp: purp,
                t: t,
                onToggleOptions: onToggleOptions,
                onSwap: onSwap,
              );
      },
    );
  }
}

// ── Collapsed state ─────────────────────────────────────────────────────────
class _CollapsedBar extends StatelessWidget {
  final int dur;
  final String mood;
  final String purp;
  final AppThemeTokens t;
  final VoidCallback onToggleOptions;
  final VoidCallback onSwap;

  const _CollapsedBar({
    required this.dur,
    required this.mood,
    required this.purp,
    required this.t,
    required this.onToggleOptions,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.paper2,
        border: Border.all(color: t.ruleSoft),
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: [
          // Left: current settings summary
          Expanded(
            child: GestureDetector(
              onTap: onToggleOptions,
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: t.ruleSoft),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '$dur분 · $mood · $purp',
                        style: Ts.sans(13, FontWeight.w400, t.ink2),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '조정→',
                      style: Ts.sans(12, FontWeight.w700, t.copperD),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right: swap button
          GestureDetector(
            onTap: onSwap,
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Text(
                  '↻',
                  style: TextStyle(fontSize: 20, color: t.ink),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Expanded state ──────────────────────────────────────────────────────────
class _ExpandedBar extends StatelessWidget {
  final int dur;
  final String mood;
  final String purp;
  final bool showCustom;
  final String custom;
  final AppThemeTokens t;
  final VoidCallback onToggleOptions;
  final VoidCallback onSwap;
  final ValueChanged<int> onDurChanged;
  final ValueChanged<String> onMoodChanged;
  final ValueChanged<String> onPurpChanged;
  final VoidCallback onToggleCustom;
  final ValueChanged<String> onCustomChanged;

  const _ExpandedBar({
    required this.dur,
    required this.mood,
    required this.purp,
    required this.showCustom,
    required this.custom,
    required this.t,
    required this.onToggleOptions,
    required this.onSwap,
    required this.onDurChanged,
    required this.onMoodChanged,
    required this.onPurpChanged,
    required this.onToggleCustom,
    required this.onCustomChanged,
  });

  static const _presets = [10, 20, 30, 45, 60];
  static const _moods = ['고요', '활기', '즉흥'];
  static const _purps = ['회복', '환기', '사색', '탐험'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.paper2,
        border: Border.all(color: t.ruleSoft),
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: 얼마나
          Row(
            children: [
              Text('얼마나', style: Ts.sans(12, FontWeight.w600, t.ink3)),
              const Spacer(),
              GestureDetector(
                onTap: onToggleCustom,
                child: Text(
                  showCustom ? '프리셋' : '직접 입력',
                  style: Ts.sans(12, FontWeight.w600, t.copperD),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (!showCustom)
            Row(
              children: _presets
                  .map((d) => _MinPill(
                        label: '$d분',
                        active: dur == d,
                        t: t,
                        onTap: () => onDurChanged(d),
                      ))
                  .toList(),
            )
          else
            _CustomInput(
              value: custom,
              t: t,
              onChanged: onCustomChanged,
            ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: _DashedDivider(color: t.ruleSoft),
          ),

          // Section: 마음
          Text('마음', style: Ts.sans(12, FontWeight.w600, t.ink3)),
          const SizedBox(height: 8),
          Row(
            children: _moods
                .map((m) => _ChipRadio(
                      label: m,
                      active: mood == m,
                      t: t,
                      onTap: () => onMoodChanged(m),
                    ))
                .toList(),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: _DashedDivider(color: t.ruleSoft),
          ),

          // Section: 목적
          Text('목적', style: Ts.sans(12, FontWeight.w600, t.ink3)),
          const SizedBox(height: 8),
          Row(
            children: _purps
                .map((p) => _ChipRadio(
                      label: p,
                      active: purp == p,
                      t: t,
                      onTap: () => onPurpChanged(p),
                    ))
                .toList(),
          ),

          // Bottom actions
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: _DashedDivider(color: t.ruleSoft),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onSwap,
                child: Text(
                  '↻ 다른 길',
                  style: Ts.sans(13, FontWeight.w700, t.copperD),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onToggleOptions,
                child: Text(
                  '접기',
                  style: Ts.sans(13, FontWeight.w600, t.ink3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── MinPill ─────────────────────────────────────────────────────────────────
class _MinPill extends StatelessWidget {
  final String label;
  final bool active;
  final AppThemeTokens t;
  final VoidCallback onTap;

  const _MinPill({
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 42,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: active ? t.ink : t.paper2,
            border: Border.all(color: active ? t.ink : t.rule),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: Ts.sans(13, FontWeight.w600,
                active ? t.paper : t.ink),
          ),
        ),
      ),
    );
  }
}

// ── ChipRadio ───────────────────────────────────────────────────────────────
class _ChipRadio extends StatelessWidget {
  final String label;
  final bool active;
  final AppThemeTokens t;
  final VoidCallback onTap;

  const _ChipRadio({
    required this.label,
    required this.active,
    required this.t,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? t.ink : Colors.transparent,
          border: Border.all(color: active ? t.ink : t.rule),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: Ts.sans(13, FontWeight.w500,
              active ? t.paper : t.ink),
        ),
      ),
    );
  }
}

// ── Custom input ─────────────────────────────────────────────────────────────
class _CustomInput extends StatefulWidget {
  final String value;
  final AppThemeTokens t;
  final ValueChanged<String> onChanged;

  const _CustomInput({
    required this.value,
    required this.t,
    required this.onChanged,
  });

  @override
  State<_CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<_CustomInput> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      autofocus: true,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: Ts.sans(15, FontWeight.w400, widget.t.ink),
      decoration: InputDecoration(
        hintText: '분 단위 입력 (3–60)',
        hintStyle: Ts.sans(14, FontWeight.w400, widget.t.ink3),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.t.ink, width: 1.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.t.ink, width: 1.5),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 4),
      ),
      onChanged: widget.onChanged,
    );
  }
}

// ── Dashed divider ───────────────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedPainter(color: color),
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  const _DashedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashW = 4.0, gapW = 4.0;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashW, 0), paint);
      x += dashW + gapW;
    }
  }

  @override
  bool shouldRepaint(_DashedPainter old) => old.color != color;
}
