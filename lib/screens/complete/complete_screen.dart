import 'package:flutter/material.dart';
import '../../theme/t.dart';
import '../../theme/app_text_styles.dart';
import '../../data/quests.dart';
import '../../logic/route_engine.dart';

class CompleteScreen extends StatefulWidget {
  final Map<String, dynamic> result;
  final void Function(String note) onDone;
  final String neighborhood;
  final String locationName;

  const CompleteScreen({
    super.key,
    required this.result,
    required this.onDone,
    required this.neighborhood,
    required this.locationName,
  });

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  final _noteController = TextEditingController();

  RouteResult get _route => widget.result['route'] as RouteResult;
  int get _elapsed => widget.result['elapsed'] as int? ?? 0;
  List<Quest> get _quests => (widget.result['quests'] as List?)?.cast<Quest>() ?? [];
  int get _completed => widget.result['completed'] as int? ?? 0;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _dayOfWeek(DateTime dt) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[dt.weekday % 7];
  }

  String _illustType(DateTime dt) {
    const types = ['healing', 'explore', 'breeze', 'reflection'];
    return types[dt.day % 4];
  }

  String _postLine(DateTime dt) {
    const lines = [
      '오늘 한 모퉁이를 돌고 옵니다.',
      '오늘의 작은 발견, 잘 다녀오셨어요.',
      '걸음만으로도 충분한 하루였어요.',
    ];
    return lines[dt.day % 3];
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final elapsedMin = _elapsed ~/ 60;
    final elapsedSec = _elapsed % 60;
    final total = _quests.length;
    final allDone = total > 0 && _completed >= total;
    final noteLen = _noteController.text.length;
    final steps = (_route.distanceKm * 1300).round();

    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        return Scaffold(
          backgroundColor: t.paper,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHero(t, now, elapsedMin, elapsedSec, total, allDone, steps),
                  _buildDiscoveries(t, total),
                  _buildMemo(t, now, noteLen),
                  _buildCta(t),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHero(AppThemeTokens t, DateTime now, int elapsedMin, int elapsedSec, int total, bool allDone, int steps) {
    return Container(
      decoration: BoxDecoration(
        color: t.paper2,
        border: Border(bottom: BorderSide(color: t.rule, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        children: [
          Text(
            '${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')} · ${_dayOfWeek(now)} · ${widget.locationName}',
            style: Ts.sans(12, FontWeight.w400, t.ink2),
          ),
          const SizedBox(height: 20),
          _CompletionMark(type: _illustType(now), size: 192, t: t),
          const SizedBox(height: 20),
          Text(
            _route.flavorName,
            textAlign: TextAlign.center,
            style: Ts.serif(30, FontWeight.w700, t.ink),
          ),
          const SizedBox(height: 8),
          Text(
            _postLine(now),
            textAlign: TextAlign.center,
            style: Ts.sans(14, FontWeight.w400, t.ink2),
          ),
          const SizedBox(height: 20),
          _StatsThreeUp(
            t: t,
            elapsedMin: elapsedMin,
            elapsedSec: elapsedSec,
            completed: _completed,
            total: total,
            allDone: allDone,
            distanceKm: _route.distanceKm,
            steps: steps,
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveries(AppThemeTokens t, int total) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('발견', style: Ts.serif(18, FontWeight.w700, t.ink)),
            const SizedBox(width: 10),
            Text('$_completed / $total', style: Ts.sans(13, FontWeight.w400, t.ink3)),
          ]),
          const SizedBox(height: 14),
          ..._quests.asMap().entries.map((entry) {
            final i = entry.key;
            final q = entry.value;
            final done = i < _completed;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                _QuestCircle(done: done, t: t),
                const SizedBox(width: 12),
                Expanded(child: Text(q.text, style: Ts.sans(14, FontWeight.w400, done ? t.ink : t.ink3))),
                if (done) ...[
                  const SizedBox(width: 8),
                  Text('✺ 찾음', style: Ts.sans(12, FontWeight.w400, t.moss)),
                ],
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMemo(AppThemeTokens t, DateTime now, int noteLen) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('메모', style: Ts.serif(18, FontWeight.w700, t.ink)),
            const SizedBox(width: 10),
            Text('한 줄이면 충분해요', style: Ts.sans(12, FontWeight.w400, t.ink3)),
          ]),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: t.rule, width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: t.paper3,
                    border: Border(bottom: BorderSide(color: t.rule, width: 1, style: BorderStyle.solid)),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${now.year}.${now.month.toString().padLeft(2,'0')}.${now.day.toString().padLeft(2,'0')}',
                        style: Ts.sans(11, FontWeight.w400, t.ink2),
                      ),
                      Text(
                        '${widget.locationName} · 맑음',
                        style: Ts.sans(11, FontWeight.w400, t.ink3),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  maxLength: 240,
                  onChanged: (_) => setState(() {}),
                  style: Ts.sans(14, FontWeight.w400, t.ink),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '오늘 걷다 만난 것들을 적어보세요.',
                    hintStyle: Ts.sans(14, FontWeight.w400, t.ink3),
                    contentPadding: const EdgeInsets.all(14),
                    border: InputBorder.none,
                    fillColor: t.paper2,
                    filled: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: t.paper2,
                    border: Border(top: BorderSide(color: t.ruleSoft, width: 1)),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('가볍게 적어두기', style: Ts.sans(11, FontWeight.w400, t.ink3)),
                      Text(
                        '$noteLen/240',
                        style: Ts.sans(11, FontWeight.w400, noteLen > 200 ? t.copperD : t.ink3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCta(AppThemeTokens t) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => widget.onDone(_noteController.text),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: t.ink,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text('오늘 페이지 접기', style: Ts.sans(15, FontWeight.w600, t.paper)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '오늘의 한 걸음이 수첩에 더해집니다',
            textAlign: TextAlign.center,
            style: Ts.sans(12, FontWeight.w400, t.ink3),
          ),
        ],
      ),
    );
  }
}

class _QuestCircle extends StatelessWidget {
  final bool done;
  final AppThemeTokens t;
  const _QuestCircle({required this.done, required this.t});

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Container(
        width: 22, height: 22,
        decoration: BoxDecoration(color: t.copper, shape: BoxShape.circle),
        child: Center(child: Text('✓', style: TextStyle(fontSize: 12, color: t.paper, fontWeight: FontWeight.w700))),
      );
    }
    return Container(
      width: 22, height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: t.rule, width: 1.5, style: BorderStyle.solid),
      ),
    );
  }
}

class _CompletionMark extends StatelessWidget {
  final String type;
  final double size;
  final AppThemeTokens t;
  const _CompletionMark({required this.type, required this.size, required this.t});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(painter: _IllustPainter(type: type, t: t)),
    );
  }
}

class _IllustPainter extends CustomPainter {
  final String type;
  final AppThemeTokens t;
  const _IllustPainter({required this.type, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final bgPaint = Paint()..color = t.paper3;
    final borderPaint = Paint()
      ..color = t.rule
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final inkPaint = Paint()..color = t.ink2;
    final mossPaint = Paint()..color = t.moss;
    final copperPaint = Paint()..color = t.copper;

    // Background circle
    canvas.drawCircle(Offset(cx, cy), size.width * 0.46, bgPaint);
    canvas.drawCircle(Offset(cx, cy), size.width * 0.46, borderPaint);

    switch (type) {
      case 'healing':
        _drawHealing(canvas, size, cx, cy, inkPaint, mossPaint, copperPaint);
      case 'explore':
        _drawExplore(canvas, size, cx, cy, inkPaint, mossPaint, copperPaint);
      case 'breeze':
        _drawBreeze(canvas, size, cx, cy, inkPaint, mossPaint, copperPaint);
      case 'reflection':
        _drawReflection(canvas, size, cx, cy, inkPaint, mossPaint, copperPaint);
      default:
        _drawHealing(canvas, size, cx, cy, inkPaint, mossPaint, copperPaint);
    }
  }

  void _drawHealing(Canvas canvas, Size size, double cx, double cy,
      Paint inkPaint, Paint mossPaint, Paint copperPaint) {
    final s = size.width / 192;
    // Bench slats
    final benchPaint = Paint()..color = inkPaint.color..strokeWidth = 3 * s..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - 40 * s, cy + 10 * s), Offset(cx + 40 * s, cy + 10 * s), benchPaint);
    canvas.drawLine(Offset(cx - 40 * s, cy + 20 * s), Offset(cx + 40 * s, cy + 20 * s), benchPaint);
    // Bench legs
    canvas.drawLine(Offset(cx - 30 * s, cy + 10 * s), Offset(cx - 35 * s, cy + 40 * s), benchPaint);
    canvas.drawLine(Offset(cx + 30 * s, cy + 10 * s), Offset(cx + 35 * s, cy + 40 * s), benchPaint);
    // Tree trunk
    final trunkPaint = Paint()..color = inkPaint.color..strokeWidth = 4 * s..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx + 55 * s, cy + 40 * s), Offset(cx + 55 * s, cy - 10 * s), trunkPaint);
    // Tree top (circle)
    final leafPaint = Paint()..color = mossPaint.color;
    canvas.drawCircle(Offset(cx + 55 * s, cy - 25 * s), 18 * s, leafPaint);
    // Sun
    final sunPaint = Paint()..color = copperPaint.color;
    canvas.drawCircle(Offset(cx - 50 * s, cy - 45 * s), 12 * s, sunPaint);
  }

  void _drawExplore(Canvas canvas, Size size, double cx, double cy,
      Paint inkPaint, Paint mossPaint, Paint copperPaint) {
    final s = size.width / 192;
    final buildingPaint = Paint()..color = inkPaint.color..style = PaintingStyle.stroke..strokeWidth = 2 * s;
    // Left building
    canvas.drawRect(Rect.fromLTWH(cx - 60 * s, cy - 30 * s, 40 * s, 70 * s), buildingPaint);
    // Right building (taller)
    canvas.drawRect(Rect.fromLTWH(cx + 5 * s, cy - 55 * s, 45 * s, 95 * s), buildingPaint);
    // Windows
    final winPaint = Paint()..color = copperPaint.color;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 2; c++) {
        canvas.drawRect(
          Rect.fromLTWH(cx - 55 * s + c * 16 * s, cy - 20 * s + r * 18 * s, 8 * s, 10 * s),
          winPaint,
        );
      }
    }
    // Alley gap
    final alleyPaint = Paint()..color = mossPaint.color..strokeWidth = 2 * s..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - 19 * s, cy + 40 * s), Offset(cx + 5 * s, cy + 40 * s), alleyPaint);
  }

  void _drawBreeze(Canvas canvas, Size size, double cx, double cy,
      Paint inkPaint, Paint mossPaint, Paint copperPaint) {
    final s = size.width / 192;
    // Horizon line
    final horizPaint = Paint()..color = inkPaint.color..strokeWidth = 2 * s;
    canvas.drawLine(Offset(cx - 65 * s, cy + 15 * s), Offset(cx + 65 * s, cy + 15 * s), horizPaint);
    // Rolling hills
    final hillPaint = Paint()..color = mossPaint.color;
    final hillPath = Path();
    hillPath.moveTo(cx - 65 * s, cy + 15 * s);
    hillPath.quadraticBezierTo(cx - 30 * s, cy - 20 * s, cx, cy + 15 * s);
    hillPath.quadraticBezierTo(cx + 30 * s, cy + 40 * s, cx + 65 * s, cy + 15 * s);
    hillPath.lineTo(cx + 65 * s, cy + 65 * s);
    hillPath.lineTo(cx - 65 * s, cy + 65 * s);
    hillPath.close();
    canvas.drawPath(hillPath, hillPaint);
    // Sun
    final sunPaint = Paint()..color = copperPaint.color;
    canvas.drawCircle(Offset(cx + 40 * s, cy - 35 * s), 18 * s, sunPaint);
    // Wind lines
    final windPaint = Paint()..color = inkPaint.color..strokeWidth = 1.5 * s..style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      canvas.drawLine(
        Offset(cx - 50 * s, cy - 45 * s + i * 10 * s),
        Offset(cx - 20 * s, cy - 45 * s + i * 10 * s),
        windPaint,
      );
    }
  }

  void _drawReflection(Canvas canvas, Size size, double cx, double cy,
      Paint inkPaint, Paint mossPaint, Paint copperPaint) {
    final s = size.width / 192;
    // River
    final riverPaint = Paint()..color = mossPaint.color.withValues(alpha: 0.4);
    canvas.drawRect(Rect.fromLTWH(cx - 65 * s, cy + 20 * s, 130 * s, 30 * s), riverPaint);
    // Bridge arch
    final bridgePaint = Paint()..color = inkPaint.color..style = PaintingStyle.stroke..strokeWidth = 3 * s;
    final bridgePath = Path();
    bridgePath.moveTo(cx - 50 * s, cy + 20 * s);
    bridgePath.quadraticBezierTo(cx, cy - 10 * s, cx + 50 * s, cy + 20 * s);
    canvas.drawPath(bridgePath, bridgePaint);
    // Bridge deck
    canvas.drawLine(Offset(cx - 50 * s, cy + 20 * s), Offset(cx + 50 * s, cy + 20 * s), bridgePaint);
    // Figure
    final figPaint = Paint()..color = copperPaint.color;
    canvas.drawCircle(Offset(cx - 15 * s, cy + 12 * s), 5 * s, figPaint);
    canvas.drawLine(
      Offset(cx - 15 * s, cy + 17 * s),
      Offset(cx - 15 * s, cy + 30 * s),
      Paint()..color = copperPaint.color..strokeWidth = 2.5 * s,
    );
    // Reflection ripple
    final ripplePaint = Paint()..color = inkPaint.color.withValues(alpha: 0.25)..style = PaintingStyle.stroke..strokeWidth = 1.5 * s;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + 35 * s), width: 60 * s, height: 10 * s), ripplePaint);
  }

  @override
  bool shouldRepaint(_IllustPainter old) => old.type != type;
}

class _StatsThreeUp extends StatelessWidget {
  final AppThemeTokens t;
  final int elapsedMin, elapsedSec, completed, total;
  final bool allDone;
  final double distanceKm;
  final int steps;

  const _StatsThreeUp({
    required this.t,
    required this.elapsedMin,
    required this.elapsedSec,
    required this.completed,
    required this.total,
    required this.allDone,
    required this.distanceKm,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: t.paper,
        border: Border.all(color: t.ruleSoft, width: 1, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(5),
      ),
      child: IntrinsicHeight(
        child: Row(children: [
          Expanded(child: _stat(
            t: t,
            label: '걸린 시간',
            main: '$elapsedMin분',
            sub: '$elapsedSec초',
          )),
          VerticalDivider(color: t.ruleSoft, width: 1, thickness: 1),
          Expanded(child: _stat(
            t: t,
            label: '발견',
            main: '$completed/$total',
            sub: allDone ? '모두 완료' : '',
            highlight: allDone,
          )),
          VerticalDivider(color: t.ruleSoft, width: 1, thickness: 1),
          Expanded(child: _stat(
            t: t,
            label: '거리',
            main: '${distanceKm.toStringAsFixed(1)}km',
            sub: '약 $steps걸음',
          )),
        ]),
      ),
    );
  }

  Widget _stat({
    required AppThemeTokens t,
    required String label,
    required String main,
    required String sub,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(children: [
        Text(label, style: Ts.sans(11, FontWeight.w400, t.ink3)),
        const SizedBox(height: 4),
        Text(main, style: Ts.sans(18, FontWeight.w700, highlight ? t.moss : t.ink)),
        if (sub.isNotEmpty) Text(sub, style: Ts.sans(11, FontWeight.w400, t.ink3)),
      ]),
    );
  }
}
