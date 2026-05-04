import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/quests.dart';
import '../../logic/route_engine.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/t.dart';
import '../../screens/home/widgets/illustrated_map.dart';
import 'widgets/live_map.dart';

// ── Always-dark Mast constants ────────────────────────────────────────────────
const _mastBg     = Color(0xFF1B2520);
const _mastFg     = Color(0xFFECE3CC);
const _mastFgMute = Color(0xFFECE3CC); // use withValues(alpha:0.65)
const _mastBorder = Color(0xFFECE3CC); // use withValues(alpha:0.18)

// ── WalkScreen ────────────────────────────────────────────────────────────────

class WalkScreen extends ConsumerStatefulWidget {
  /// Data from HomeScreen: route, quests, duration, mood, purp
  final Map<String, dynamic> walk;
  final VoidCallback onClose;

  const WalkScreen({
    super.key,
    required this.walk,
    required this.onClose,
  });

  @override
  ConsumerState<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends ConsumerState<WalkScreen> {
  // ── Phase state ──
  bool _started = false;
  bool _paused  = false;

  // ── Timer state ──
  late int _durationMin;
  int _elapsedSec = 0;
  bool _showCountdown = true; // true = countdown, false = elapsed
  Timer? _timer;

  // ── Quests state ──
  final Set<int> _doneIds = {};
  final Map<int, bool> _memoOpen = {};
  final Map<int, String> _memos = {};

  // ── Route ──
  late RouteResult _route;
  late List<Quest> _quests;
  late String _mood;
  late String _purp;

  @override
  void initState() {
    super.initState();
    _durationMin = (widget.walk['dur'] as int? ?? widget.walk['duration'] as int? ?? 20);
    _mood = widget.walk['mood'] as String? ?? 'lively';
    _purp = widget.walk['purp'] as String? ?? 'recovery';

    // Build RouteResult — may already be provided via walk data
    _route = getRoute(
      duration: _durationMin,
      mood: _mood,
      purpose: _purp,
      seed: (widget.walk['seed'] as int? ?? 0),
    );
    _quests = _route.quests;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isImprovisational => _mood == 'spontaneous' || _mood == '즉흥';
  bool get _allDone => _quests.isNotEmpty && _doneIds.length >= _quests.length;

  int get _remainSec => (_durationMin * 60 - _elapsedSec).clamp(0, _durationMin * 60);
  double get _progress => (_elapsedSec / (_durationMin * 60)).clamp(0.0, 1.0);

  String _fmtTime(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _startWalk() {
    setState(() { _started = true; });
    _resumeTimer();
  }

  void _resumeTimer() {
    _paused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_paused && mounted) {
        setState(() { _elapsedSec++; });
      }
    });
  }

  void _pauseTimer() {
    setState(() { _paused = true; });
    _timer?.cancel();
    _timer = null;
  }

  void _togglePause() {
    if (_paused) {
      _resumeTimer();
    } else {
      _pauseTimer();
    }
    setState(() {});
  }

  void _toggleTimer() {
    setState(() { _showCountdown = !_showCountdown; });
  }

  void _toggleQuest(int id) {
    setState(() {
      if (_doneIds.contains(id)) {
        _doneIds.remove(id);
      } else {
        _doneIds.add(id);
      }
    });
  }

  void _toggleMemo(int id) {
    setState(() {
      _memoOpen[id] = !(_memoOpen[id] ?? false);
    });
  }

  String _statusLabel() {
    if (_remainSec <= 60) return '도착 직전';
    if (_paused) return '일시 정지';
    return '걷는 중';
  }

  // accent color for mast
  Color get _accent => _allDone ? const Color(0xFF97AC85) : const Color(0xFF92AEC2);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        return Scaffold(
          backgroundColor: _started ? t.bg : _mastBg,
          body: SafeArea(
            child: _started ? _buildWalking(t) : _buildStandby(t),
          ),
        );
      },
    );
  }

  // ── Phase A: Standby ─────────────────────────────────────────────────────────

  Widget _buildStandby(AppThemeTokens t) {
    final distKm  = _route.distanceKm;
    final questCnt = _quests.length;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Standby Mast
          Container(
            color: _mastBg,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    // "준비" 배지
                    Row(
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD88150),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text('준비',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _mastFg,
                            letterSpacing: 0.5,
                          )),
                      ],
                    ),
                    const Spacer(),
                    // ← 닫기
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Text('← 닫기',
                        style: TextStyle(
                          fontSize: 13,
                          color: _mastFgMute.withValues(alpha: 0.65),
                        )),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Route name (h2 serif)
                Text(
                  _isImprovisational ? '발길 닿는 모퉁이' : _route.flavorName,
                  style: Ts.serif(22, FontWeight.w700, _mastFg),
                ),
                const SizedBox(height: 6),
                // Route desc
                Text(
                  _isImprovisational
                      ? '어느 모퉁이일지는 출발할 때 정합니다.'
                      : _route.flavorDesc,
                  style: Ts.sans(14, FontWeight.w400,
                      _mastFgMute.withValues(alpha: 0.65)),
                ),
                const SizedBox(height: 20),
                // Stats 3-up
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: _mastBorder.withValues(alpha: 0.18)),
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      _StandbyStat(
                        label: '시간',
                        value: '$_durationMin',
                        unit: '분',
                        fg: _mastFg,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: _mastBorder.withValues(alpha: 0.18),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _StandbyStat(
                        label: '거리',
                        value: distKm.toStringAsFixed(1),
                        unit: 'km',
                        fg: _mastFg,
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: _mastBorder.withValues(alpha: 0.18),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _StandbyStat(
                        label: '발견',
                        value: '$questCnt',
                        unit: '개',
                        fg: _mastFg,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Map preview
          if (_isImprovisational)
            _ImprovPlaceholder()
          else
            IllustratedMap(
              duration: _durationMin,
              mood: _mood,
              height: 200,
            ),

          // Quests section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('걸으며 챙겨볼 것',
                  style: Ts.sans(12, FontWeight.w700,
                      t.ink3.withValues(alpha: 0.85),
                      letterSpacing: 0.8)),
                const SizedBox(height: 12),
                ..._quests.asMap().entries.map((e) {
                  final i = e.key;
                  final q = e.value;
                  return _StandbyQuestRow(quest: q, isLast: i == _quests.length - 1, t: t);
                }),
              ],
            ),
          ),

          // Start CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: GestureDetector(
              onTap: _startWalk,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 17),
                decoration: BoxDecoration(
                  color: t.ink,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  _isImprovisational ? '출발 — 길은 그때 정해집니다' : '지금부터 걸을게요',
                  style: Ts.sans(15, FontWeight.w800, t.paper),
                ),
              ),
            ),
          ),
          // Sub hint
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Text(
              '시작 버튼을 누르면 시간이 흐르기 시작합니다.',
              style: Ts.sans(12, FontWeight.w400, t.ink3),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ── Phase B: Walking ─────────────────────────────────────────────────────────

  Widget _buildWalking(AppThemeTokens t) {
    final displaySec = _showCountdown ? _remainSec : _elapsedSec;
    final timerLabel = _showCountdown
        ? '남은 시간 · $_durationMin분 코스'
        : (_remainSec > 0
            ? '경과 · $_durationMin분 코스'
            : '예정 $_durationMin분 · 여유분');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Walk Mast
          Container(
            color: _mastBg,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  children: [
                    // × 닫기
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Text('×',
                        style: TextStyle(
                          fontSize: 20,
                          color: _mastFgMute.withValues(alpha: 0.65),
                        )),
                    ),
                    const SizedBox(width: 10),
                    // 상태 배지
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _accent.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              color: _accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(_statusLabel(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: _accent,
                            )),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // 일시정지 / 다시 시작
                    if (!_allDone)
                      GestureDetector(
                        onTap: _togglePause,
                        child: Text(
                          _paused ? '다시 시작' : '일시 정지',
                          style: TextStyle(
                            fontSize: 13,
                            color: _mastFgMute.withValues(alpha: 0.65),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Route name
                Text(
                  _isImprovisational ? '발길 닿는 모퉁이' : _route.flavorName,
                  style: Ts.serif(22, FontWeight.w700, _mastFg),
                ),
                const SizedBox(height: 14),
                // Timer button
                GestureDetector(
                  onTap: _toggleTimer,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // MM:SS with accent colon
                      _TimerDisplay(
                        timeSec: displaySec,
                        accentColor: _accent,
                        fg: _mastFg,
                      ),
                      const SizedBox(width: 10),
                      // ⇄ icon badge
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: _mastFgMute.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('⇄',
                            style: TextStyle(
                              fontSize: 12,
                              color: _mastFgMute.withValues(alpha: 0.65),
                            )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(timerLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: _mastFgMute.withValues(alpha: 0.65),
                  )),
              ],
            ),
          ),

          // Progress Card 3-up
          Container(
            decoration: BoxDecoration(
              color: t.paper2,
              border: Border(
                top: BorderSide(color: t.ruleSoft),
                bottom: BorderSide(color: t.ruleSoft),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
            child: Row(
              children: [
                Expanded(
                  child: _WalkStat(
                    label: _showCountdown ? '남은 시간' : '걸은 시간',
                    value: _fmtTime(_showCountdown ? _remainSec : _elapsedSec),
                    t: t,
                  ),
                ),
                _DashedDivider(height: 40, color: t.ruleSoft),
                Expanded(
                  child: _WalkStat(
                    label: _showCountdown ? '남은 거리' : '걸은 거리',
                    value: _showCountdown
                        ? '${(_route.distanceKm * (1 - _progress)).toStringAsFixed(1)}km'
                        : '${(_route.distanceKm * _progress).toStringAsFixed(1)}km',
                    t: t,
                  ),
                ),
                _DashedDivider(height: 40, color: t.ruleSoft),
                Expanded(
                  child: _WalkStat(
                    label: '발견',
                    value: '${_doneIds.length} / ${_quests.length}',
                    t: t,
                  ),
                ),
              ],
            ),
          ),

          // LiveMap
          LiveMap(
            duration: _durationMin,
            progress: _progress,
            allDone: _allDone,
          ),

          // Quests section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: dot progress bar + count
                Row(
                  children: [
                    Text('걸으며 챙겨보세요',
                      style: Ts.sans(12, FontWeight.w700,
                          t.ink3.withValues(alpha: 0.85),
                          letterSpacing: 0.8)),
                    const Spacer(),
                    // Dot progress bar
                    Row(
                      children: List.generate(_quests.length, (i) {
                        final done = i < _doneIds.length;
                        return Container(
                          width: 6, height: 6,
                          margin: const EdgeInsets.only(right: 3),
                          decoration: BoxDecoration(
                            color: done ? t.moss : t.rule,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(width: 6),
                    Text('${_doneIds.length} / ${_quests.length}',
                      style: Ts.sans(11, FontWeight.w600, t.ink3)),
                  ],
                ),
                const SizedBox(height: 12),
                // Quest rows
                ..._quests.asMap().entries.map((e) {
                  final q = e.value;
                  final isDone = _doneIds.contains(q.id);
                  final memoIsOpen = _memoOpen[q.id] ?? false;
                  final memo = _memos[q.id] ?? '';
                  return _WalkQuestRow(
                    quest: q,
                    isDone: isDone,
                    memoOpen: memoIsOpen,
                    memoText: memo,
                    t: t,
                    onToggle: () => _toggleQuest(q.id),
                    onToggleMemo: () => _toggleMemo(q.id),
                    onMemoChanged: (v) => setState(() { _memos[q.id] = v; }),
                  );
                }),
              ],
            ),
          ),

          // Finish CTA
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            child: GestureDetector(
              onTap: widget.onClose,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 17),
                decoration: BoxDecoration(
                  color: _allDone ? t.moss : t.ink,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  _allDone ? '오늘 마치기' : '오늘은 여기까지',
                  style: Ts.sans(15, FontWeight.w800, t.paper),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _StandbyStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color fg;
  const _StandbyStat({required this.label, required this.value, required this.unit, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: fg.withValues(alpha: 0.65))),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: Ts.serif(23, FontWeight.w700, fg)),
            const SizedBox(width: 3),
            Text(unit, style: TextStyle(fontSize: 12, color: fg.withValues(alpha: 0.65))),
          ],
        ),
      ],
    );
  }
}

class _StandbyQuestRow extends StatelessWidget {
  final Quest quest;
  final bool isLast;
  final AppThemeTokens t;
  const _StandbyQuestRow({required this.quest, required this.isLast, required this.t});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: t.ruleSoft,
                  style: BorderStyle.solid,
                ),
              ),
            ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: t.copperL.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                catGlyph(quest.cat),
                style: TextStyle(fontSize: 13, color: t.copper),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(quest.text, style: Ts.sans(14, FontWeight.w400, t.ink)),
          ),
        ],
      ),
    );
  }
}

class _WalkStat extends StatelessWidget {
  final String label;
  final String value;
  final AppThemeTokens t;
  const _WalkStat({required this.label, required this.value, required this.t});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Ts.sans(11, FontWeight.w400, t.ink3)),
        const SizedBox(height: 3),
        Text(value, style: Ts.serif(16, FontWeight.w700, t.ink)),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  final double height;
  final Color color;
  const _DashedDivider({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(1, height),
      painter: _DashedLinePainter(color: color),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashH = 4.0, gapH = 4.0;
    final paint = Paint()..color = color..strokeWidth = 1;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, (y + dashH).clamp(0, size.height)), paint);
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

class _TimerDisplay extends StatelessWidget {
  final int timeSec;
  final Color accentColor;
  final Color fg;
  const _TimerDisplay({required this.timeSec, required this.accentColor, required this.fg});

  @override
  Widget build(BuildContext context) {
    final mm = (timeSec ~/ 60).toString().padLeft(2, '0');
    final ss = (timeSec % 60).toString().padLeft(2, '0');
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w500,
          fontFamily: 'monospace',
          color: fg,
        ),
        children: [
          TextSpan(text: mm),
          TextSpan(text: ':', style: TextStyle(color: accentColor)),
          TextSpan(text: ss),
        ],
      ),
    );
  }
}

class _WalkQuestRow extends StatelessWidget {
  final Quest quest;
  final bool isDone;
  final bool memoOpen;
  final String memoText;
  final AppThemeTokens t;
  final VoidCallback onToggle;
  final VoidCallback onToggleMemo;
  final ValueChanged<String> onMemoChanged;

  const _WalkQuestRow({
    required this.quest,
    required this.isDone,
    required this.memoOpen,
    required this.memoText,
    required this.t,
    required this.onToggle,
    required this.onToggleMemo,
    required this.onMemoChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Check button
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: isDone ? t.moss : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone ? t.moss : t.copper,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: isDone
                        ? const Text('✓',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w800))
                        : Text(catGlyph(quest.cat),
                            style: TextStyle(fontSize: 13, color: t.copper)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Quest text
              Expanded(
                child: Text(
                  quest.text,
                  style: Ts.sans(14, FontWeight.w400,
                      isDone ? t.ink3 : t.ink).copyWith(
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    decorationColor: t.ink3,
                  ),
                ),
              ),
              // Memo button
              GestureDetector(
                onTap: onToggleMemo,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text('✎',
                    style: TextStyle(
                      fontSize: 16,
                      color: memoOpen ? t.copper : t.ink3,
                    )),
                ),
              ),
            ],
          ),
          // Memo textarea
          if (memoOpen)
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 6),
              child: TextField(
                onChanged: onMemoChanged,
                controller: TextEditingController(text: memoText)
                  ..selection = TextSelection.collapsed(offset: memoText.length),
                maxLines: 3,
                style: Ts.sans(13, FontWeight.w400, t.ink2),
                decoration: InputDecoration(
                  hintText: '메모를 남겨보세요...',
                  hintStyle: Ts.sans(13, FontWeight.w400, t.ink3),
                  filled: true,
                  fillColor: t.paper2,
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: t.ruleSoft),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: t.ruleSoft),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: t.copper),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ImprovPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: const Color(0xFF243029),
      child: Center(
        child: Text('?',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w300,
            color: _mastFgMute.withValues(alpha: 0.35),
          )),
      ),
    );
  }
}
