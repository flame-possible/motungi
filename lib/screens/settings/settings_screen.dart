import 'package:flutter/material.dart';
import '../../theme/t.dart';
import '../../theme/app_text_styles.dart';

class SettingsScreen extends StatefulWidget {
  final Map<String, dynamic>? user;
  final VoidCallback onAuthEntry;
  final VoidCallback onSignout;
  final String themeMode;
  final void Function(String) setTheme;
  final int defaultDur;
  final void Function(int) setDefaultDur;
  final String neighborhood;
  final String locationName;
  final VoidCallback onLocationEdit;
  final VoidCallback onClose;

  const SettingsScreen({
    super.key,
    this.user,
    required this.onAuthEntry,
    required this.onSignout,
    required this.themeMode,
    required this.setTheme,
    required this.defaultDur,
    required this.setDefaultDur,
    required this.neighborhood,
    required this.locationName,
    required this.onLocationEdit,
    required this.onClose,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _themeMode;
  late int _defaultDur;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _defaultDur = widget.defaultDur;
  }

  void _showInfoDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: T.paper2,
        title: Text(title, style: Ts.serif(16, FontWeight.w700, T.ink)),
        content: Text(body, style: Ts.sans(13, FontWeight.w400, T.ink2)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('닫기', style: Ts.sans(13, FontWeight.w400, T.copper)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        final user = widget.user;
        final name = user?['name'] as String? ?? '';
        final email = user?['email'] as String? ?? '';
        final initial = name.isNotEmpty ? name.characters.first : '?';

        return Scaffold(
          backgroundColor: t.paper,
          body: SafeArea(
            child: Column(children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(children: [
                  GestureDetector(
                    onTap: widget.onClose,
                    child: Row(children: [
                      Text('←', style: Ts.sans(16, FontWeight.w400, t.ink2)),
                      const SizedBox(width: 4),
                      Text('닫기', style: Ts.sans(14, FontWeight.w400, t.ink2)),
                    ]),
                  ),
                  Expanded(
                    child: Center(child: Text('설정', style: Ts.sans(15, FontWeight.w600, t.ink))),
                  ),
                  const SizedBox(width: 48),
                ]),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // ── 계정 섹션 ─────────────────────────────────────────
                    _SectionHeader(label: '계정', t: t),
                    if (user != null) ...[
                      _SettingsRow(
                        t: t,
                        leading: _Avatar(initial: initial, t: t),
                        label: name,
                        value: email,
                        valueStyle: Ts.sans(12, FontWeight.w400, t.ink3),
                        onTap: widget.onAuthEntry,
                        showArrow: true,
                      ),
                      _SettingsRow(
                        t: t,
                        label: '로그아웃',
                        labelStyle: Ts.sans(14, FontWeight.w400, t.copper),
                        onTap: widget.onSignout,
                        showArrow: false,
                      ),
                    ] else ...[
                      _SettingsRow(
                        t: t,
                        label: '로그인 / 가입',
                        value: '걸음을 오래 간직',
                        onTap: widget.onAuthEntry,
                        showArrow: true,
                      ),
                    ],

                    // ── 표시 섹션 ─────────────────────────────────────────
                    _SectionHeader(label: '표시', t: t),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(children: [
                        Text('테마', style: Ts.sans(14, FontWeight.w400, t.ink)),
                        const Spacer(),
                        _SettingsSegmented(
                          t: t,
                          options: const ['자동', '라이트', '다크'],
                          values: const ['auto', 'light', 'dark'],
                          selected: _themeMode,
                          onSelect: (v) {
                            setState(() => _themeMode = v);
                            widget.setTheme(v);
                          },
                        ),
                      ]),
                    ),

                    // ── 산책 섹션 ─────────────────────────────────────────
                    _SectionHeader(label: '산책', t: t),
                    _SettingsRow(
                      t: t,
                      label: '내 위치',
                      value: '${widget.neighborhood} · ${widget.locationName}',
                      onTap: widget.onLocationEdit,
                      showArrow: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('기본 시간', style: Ts.sans(14, FontWeight.w400, t.ink)),
                          const SizedBox(height: 10),
                          _SettingsSegmented(
                            t: t,
                            options: const ['10분', '20분', '30분', '45분', '60분'],
                            values: const [10, 20, 30, 45, 60],
                            selected: _defaultDur,
                            onSelect: (v) {
                              setState(() => _defaultDur = v as int);
                              widget.setDefaultDur(v as int);
                            },
                            fullWidth: true,
                          ),
                        ],
                      ),
                    ),

                    // ── 정보 섹션 ─────────────────────────────────────────
                    _SectionHeader(label: '정보', t: t),
                    _SettingsRow(
                      t: t,
                      label: '모퉁이에 대해',
                      onTap: () => _showInfoDialog(
                        '모퉁이에 대해',
                        '모퉁이는 동네 산책을 위한 앱입니다.\n매번 다른 경로와 작은 퀘스트로 걸음을 더욱 풍요롭게 만들어드립니다.',
                      ),
                      showArrow: true,
                    ),
                    _SettingsRow(
                      t: t,
                      label: '이용약관',
                      onTap: () => _showInfoDialog('이용약관', '서비스 이용약관 내용이 여기에 표시됩니다.'),
                      showArrow: true,
                    ),
                    _SettingsRow(
                      t: t,
                      label: '개인정보 처리방침',
                      onTap: () => _showInfoDialog('개인정보 처리방침', '개인정보 처리방침 내용이 여기에 표시됩니다.'),
                      showArrow: true,
                    ),
                    _SettingsRow(
                      t: t,
                      label: '의견 보내기',
                      onTap: () => _showInfoDialog('의견 보내기', 'werq20003@gmail.com으로 의견을 보내주세요.'),
                      showArrow: true,
                    ),
                    _SettingsRow(
                      t: t,
                      label: '버전',
                      value: 'v0.1 · 프로토타입',
                      showArrow: false,
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final AppThemeTokens t;
  const _SectionHeader({required this.label, required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 4),
      child: Text(label, style: Ts.sans(11, FontWeight.w600, t.ink3)),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final AppThemeTokens t;
  final Widget? leading;
  final String label;
  final TextStyle? labelStyle;
  final String? value;
  final TextStyle? valueStyle;
  final VoidCallback? onTap;
  final bool showArrow;

  const _SettingsRow({
    required this.t,
    this.leading,
    required this.label,
    this.labelStyle,
    this.value,
    this.valueStyle,
    this.onTap,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: t.ruleSoft, width: 1)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: labelStyle ?? Ts.sans(14, FontWeight.w400, t.ink)),
                if (value != null)
                  Text(value!, style: valueStyle ?? Ts.sans(12, FontWeight.w400, t.ink3)),
              ],
            ),
          ),
          if (showArrow)
            Text('→', style: Ts.sans(14, FontWeight.w400, t.ink3)),
        ]),
      ),
    );
  }
}

class _SettingsSegmented extends StatelessWidget {
  final AppThemeTokens t;
  final List<String> options;
  final List<dynamic> values;
  final dynamic selected;
  final void Function(dynamic) onSelect;
  final bool fullWidth;

  const _SettingsSegmented({
    required this.t,
    required this.options,
    required this.values,
    required this.selected,
    required this.onSelect,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final inner = Container(
      decoration: BoxDecoration(
        color: t.paper2,
        border: Border.all(color: t.rule, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        children: options.asMap().entries.map((entry) {
          final i = entry.key;
          final opt = entry.value;
          final val = values[i];
          final isActive = val == selected;
          return GestureDetector(
            onTap: () => onSelect(val),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? t.ink : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                opt,
                style: Ts.sans(12, FontWeight.w400, isActive ? t.paper : t.ink2),
              ),
            ),
          );
        }).toList(),
      ),
    );

    return fullWidth ? SizedBox(width: double.infinity, child: inner) : inner;
  }
}

class _Avatar extends StatelessWidget {
  final String initial;
  final AppThemeTokens t;
  const _Avatar({required this.initial, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: t.copperL, shape: BoxShape.circle),
      child: Center(
        child: Text(initial, style: Ts.sans(16, FontWeight.w700, t.copperD)),
      ),
    );
  }
}
