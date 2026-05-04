import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/t.dart';
import '../../theme/app_text_styles.dart';
import '../../logic/route_engine.dart';

class LogScreen extends StatelessWidget {
  final List<Map<String, dynamic>> logs;
  final VoidCallback onBack;
  final Map<String, dynamic>? user;
  final VoidCallback onAuthEntry;
  final String neighborhood;
  final String locationName;

  const LogScreen({
    super.key,
    required this.logs,
    required this.onBack,
    required this.onAuthEntry,
    required this.neighborhood,
    required this.locationName,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeTokens>(
      valueListenable: themeTokensNotifier,
      builder: (context, t, _) {
        final now = DateTime.now();
        final totalDist = logs.fold<double>(
          0,
          (sum, l) => sum + ((l['route'] as RouteResult?)?.distanceKm ?? 0),
        );
        final totalFound = logs.fold<int>(
          0,
          (sum, l) => sum + ((l['completed'] as int?) ?? 0),
        );
        final lastDayAgo = logs.isEmpty
            ? null
            : now.difference(_parseDate(logs.last['date'] as String? ?? '')).inDays;

        // Group logs by month
        final Map<String, List<Map<String, dynamic>>> byMonth = {};
        for (final log in logs) {
          final dateStr = log['date'] as String? ?? '';
          final parts = dateStr.split('/');
          final monthKey = parts.isNotEmpty ? '${parts[0]}월' : '?월';
          byMonth.putIfAbsent(monthKey, () => []).add(log);
        }

        // Days walked this month
        final walkedDays = <int>{};
        for (final log in logs) {
          final dateStr = log['date'] as String? ?? '';
          final d = _parseDate(dateStr);
          if (d.month == now.month && d.year == now.year) {
            walkedDays.add(d.day);
          }
        }

        return Scaffold(
          backgroundColor: t.paper,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildMast(t, lastDayAgo)),
                SliverToBoxAdapter(
                  child: _buildStatsAndCalendar(t, now, walkedDays, totalDist, totalFound),
                ),
                if (logs.isEmpty)
                  SliverToBoxAdapter(child: _buildEmpty(t))
                else
                  ..._buildLogList(t, byMonth),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMast(AppThemeTokens t, int? lastDayAgo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            GestureDetector(
              onTap: onBack,
              child: Row(children: [
                Text('←', style: Ts.sans(16, FontWeight.w400, t.ink2)),
                const SizedBox(width: 4),
                Text('오늘', style: Ts.sans(14, FontWeight.w400, t.ink2)),
              ]),
            ),
            Expanded(
              child: Center(child: Text('기록', style: Ts.sans(15, FontWeight.w600, t.ink))),
            ),
            GestureDetector(
              onTap: onAuthEntry,
              child: Text(
                user != null ? (user!['name'] as String? ?? '계정') : '로그인',
                style: Ts.sans(13, FontWeight.w400, t.copper),
              ),
            ),
          ]),
          const SizedBox(height: 22),
          Text('걸어온 길', style: Ts.serif(30, FontWeight.w700, t.ink)),
          const SizedBox(height: 8),
          Text(
            logs.isEmpty
                ? '걸어온 길과 작은 발견을 모아둔 곳.'
                : '걸어온 날 ${logs.length}개. 마지막 걸음은 ${lastDayAgo ?? 0}일 전.',
            style: Ts.sans(14, FontWeight.w400, t.ink2),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatsAndCalendar(
      AppThemeTokens t, DateTime now, Set<int> walkedDays, double totalDist, int totalFound) {
    return Container(
      decoration: BoxDecoration(
        color: t.paper2,
        border: Border.symmetric(
          horizontal: BorderSide(color: t.ruleSoft, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats 3-up
          Row(children: [
            Expanded(child: _statGlyph(t, '산책', '${logs.length}', _buildWalkGlyph(t))),
            Expanded(child: _statGlyph(t, '발견', '$totalFound', _buildDiscoverGlyph(t))),
            Expanded(child: _statGlyph(t, '거리', '${totalDist.toStringAsFixed(1)}km', _buildDistGlyph(t))),
          ]),
          const SizedBox(height: 18),
          Divider(color: t.ruleSoft, height: 1),
          const SizedBox(height: 18),
          // Calendar header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('이번 달의 발자국', style: Ts.sans(13, FontWeight.w400, t.ink2)),
            Text('${now.month}월', style: Ts.serif(13, FontWeight.w700, t.copper)),
          ]),
          const SizedBox(height: 12),
          _buildCalendar(t, now, walkedDays),
        ],
      ),
    );
  }

  Widget _statGlyph(AppThemeTokens t, String label, String value, Widget icon) {
    return Column(children: [
      icon,
      const SizedBox(height: 6),
      Text(value, style: Ts.sans(16, FontWeight.w700, t.ink)),
      Text(label, style: Ts.sans(11, FontWeight.w400, t.ink3)),
    ]);
  }

  Widget _buildWalkGlyph(AppThemeTokens t) {
    return SizedBox(
      width: 28, height: 20,
      child: CustomPaint(painter: _WalkGlyphPainter(color: t.ink3)),
    );
  }

  Widget _buildDiscoverGlyph(AppThemeTokens t) {
    return SizedBox(
      width: 20, height: 20,
      child: CustomPaint(painter: _StarGlyphPainter(color: t.copper)),
    );
  }

  Widget _buildDistGlyph(AppThemeTokens t) {
    return SizedBox(
      width: 28, height: 18,
      child: CustomPaint(painter: _RulerGlyphPainter(color: t.ink3)),
    );
  }

  Widget _buildCalendar(AppThemeTokens t, DateTime now, Set<int> walkedDays) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // 0=Sun

    return Column(children: [
      // Weekday headers
      Row(children: weekdays.asMap().entries.map((e) {
        final i = e.key;
        final w = e.value;
        return Expanded(
          child: Center(
            child: Text(
              w,
              style: Ts.sans(11, FontWeight.w400, i == 0 ? t.copperD : t.ink2),
            ),
          ),
        );
      }).toList()),
      const SizedBox(height: 6),
      // Day grid
      Builder(builder: (context) {
        final cells = <Widget>[];
        for (int i = 0; i < startWeekday; i++) {
          cells.add(const Expanded(child: SizedBox()));
        }
        for (int day = 1; day <= daysInMonth; day++) {
          final isWalked = walkedDays.contains(day);
          final isToday = day == now.day;
          final isFuture = day > now.day;
          cells.add(Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _CalendarDay(
                day: day,
                isWalked: isWalked,
                isToday: isToday,
                isFuture: isFuture,
                t: t,
              ),
            ),
          ));
        }
        // Fill remaining
        final rem = (cells.length % 7 == 0) ? 0 : 7 - (cells.length % 7);
        for (int i = 0; i < rem; i++) {
          cells.add(const Expanded(child: SizedBox()));
        }

        final rows = <Widget>[];
        for (int r = 0; r * 7 < cells.length; r++) {
          rows.add(Row(children: cells.sublist(r * 7, (r + 1) * 7)));
        }
        return Column(children: rows);
      }),
    ]);
  }

  List<Widget> _buildLogList(
      AppThemeTokens t, Map<String, List<Map<String, dynamic>>> byMonth) {
    return byMonth.entries.expand<Widget>((entry) {
      final month = entry.key;
      final items = entry.value;
      return [
        SliverToBoxAdapter(
          child: _MonthHeader(t: t, month: month, count: items.length),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => _LogRow(t: t, log: items[i]),
            childCount: items.length,
          ),
        ),
      ];
    }).toList();
  }

  Widget _buildEmpty(AppThemeTokens t) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(children: [
        SizedBox(
          width: 64, height: 64,
          child: CustomPaint(painter: _NotebookPainter(t: t)),
        ),
        const SizedBox(height: 20),
        Text(
          '아직 기록이 비어 있습니다.\n오늘이 첫 걸음이 되는 날일지도요.',
          textAlign: TextAlign.center,
          style: Ts.sans(14, FontWeight.w400, t.ink3),
        ),
      ]),
    );
  }

  DateTime _parseDate(String dateStr) {
    // Format: "MM/DD"
    final parts = dateStr.split('/');
    if (parts.length == 2) {
      final now = DateTime.now();
      final m = int.tryParse(parts[0]) ?? now.month;
      final d = int.tryParse(parts[1]) ?? now.day;
      return DateTime(now.year, m, d);
    }
    return DateTime.now();
  }
}

class _CalendarDay extends StatelessWidget {
  final int day;
  final bool isWalked, isToday, isFuture;
  final AppThemeTokens t;

  const _CalendarDay({
    required this.day,
    required this.isWalked,
    required this.isToday,
    required this.isFuture,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isFuture ? 0.55 : 1.0,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(alignment: Alignment.center, children: [
          if (isWalked)
            Container(
              decoration: BoxDecoration(
                color: t.mossL,
                shape: BoxShape.circle,
                border: Border.all(color: t.moss, width: 1),
              ),
            ),
          if (isToday && !isWalked)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: t.ink, width: 1.5),
              ),
            ),
          Text(
            '$day',
            style: Ts.sans(
              12,
              FontWeight.w400,
              isWalked ? t.moss : t.ink2,
            ),
          ),
          if (isWalked)
            Positioned(
              bottom: 3,
              child: Container(
                width: 4, height: 4,
                decoration: BoxDecoration(color: t.moss, shape: BoxShape.circle),
              ),
            ),
        ]),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final AppThemeTokens t;
  final String month;
  final int count;

  const _MonthHeader({required this.t, required this.month, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
      child: Row(children: [
        Text(
          month,
          style: Ts.serif(16, FontWeight.w700, t.copper),
        ),
        const SizedBox(width: 10),
        Expanded(child: Divider(color: t.ruleSoft, height: 1)),
        const SizedBox(width: 10),
        Text('$count개', style: Ts.sans(12, FontWeight.w400, t.ink3)),
      ]),
    );
  }
}

class _LogRow extends StatelessWidget {
  final AppThemeTokens t;
  final Map<String, dynamic> log;

  const _LogRow({required this.t, required this.log});

  String _dayOfWeek(DateTime dt) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return days[dt.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = log['date'] as String? ?? '';
    final route = log['route'] as RouteResult?;
    final duration = log['duration'] as int? ?? 0;
    final completed = log['completed'] as int? ?? 0;
    final total = log['total'] as int? ?? 0;
    final note = log['note'] as String?;
    final allDone = total > 0 && completed >= total;
    final parts = dateStr.split('/');
    final now = DateTime.now();
    final dt = parts.length == 2
        ? DateTime(now.year, int.tryParse(parts[0]) ?? now.month, int.tryParse(parts[1]) ?? now.day)
        : now;
    final distKm = route?.distanceKm ?? 0.0;
    final illust = route?.illust ?? 'healing';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Thumbnail card
        Container(
          width: 64,
          decoration: BoxDecoration(
            color: t.paper2,
            border: Border.all(color: t.rule, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(children: [
            SizedBox(
              height: 32,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                child: CustomPaint(
                  size: const Size(64, 32),
                  painter: _MiniIllustPainter(type: illust, t: t),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
              child: Column(children: [
                Text(
                  '${dt.day}',
                  style: Ts.sans(22, FontWeight.w800, t.ink),
                ),
                Text(
                  '${dt.month}월 ${_dayOfWeek(dt)}',
                  style: Ts.sans(10.5, FontWeight.w400, t.ink3),
                ),
                if (allDone) ...[
                  const SizedBox(height: 2),
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(color: t.moss, borderRadius: BorderRadius.circular(2)),
                  ),
                ],
              ]),
            ),
          ]),
        ),
        const SizedBox(width: 14),
        // Right side
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(
                child: Text(
                  route?.flavorName ?? '산책',
                  style: Ts.serif(17, FontWeight.w700, t.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),
              if (allDone)
                Text('✺ 완주', style: Ts.sans(12, FontWeight.w400, t.moss))
              else if (total > 0)
                Text('$completed/$total', style: Ts.sans(12, FontWeight.w400, t.ink3)),
            ]),
            const SizedBox(height: 4),
            Text(
              '$duration분 · 약 ${distKm.toStringAsFixed(1)}km · 발견 $completed',
              style: Ts.sans(12, FontWeight.w400, t.ink3),
            ),
            if (note != null && note.isNotEmpty) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: t.copperL,
                  border: Border(left: BorderSide(color: t.copper, width: 2)),
                ),
                child: Text(note, style: Ts.sans(12, FontWeight.w400, t.ink2)),
              ),
            ],
          ]),
        ),
      ]),
    );
  }
}

// ── Glyph painters ────────────────────────────────────────────────────────────

class _WalkGlyphPainter extends CustomPainter {
  final Color color;
  const _WalkGlyphPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final cx = size.width / 2;
    final cy = size.height / 2;
    // Two walking figures (simplified: head oval + body line)
    // Left figure
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - 6, cy - 5), width: 5, height: 6), paint);
    canvas.drawLine(Offset(cx - 6, cy - 2), Offset(cx - 6, cy + 5), paint);
    canvas.drawLine(Offset(cx - 6, cy + 5), Offset(cx - 9, cy + 9), paint);
    canvas.drawLine(Offset(cx - 6, cy + 5), Offset(cx - 3, cy + 9), paint);
    // Right figure
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + 6, cy - 5), width: 5, height: 6), paint);
    canvas.drawLine(Offset(cx + 6, cy - 2), Offset(cx + 6, cy + 5), paint);
    canvas.drawLine(Offset(cx + 6, cy + 5), Offset(cx + 3, cy + 9), paint);
    canvas.drawLine(Offset(cx + 6, cy + 5), Offset(cx + 9, cy + 9), paint);
  }

  @override
  bool shouldRepaint(_WalkGlyphPainter old) => old.color != color;
}

class _StarGlyphPainter extends CustomPainter {
  final Color color;
  const _StarGlyphPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;
    // 8-direction star using dart:math
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarGlyphPainter old) => old.color != color;
}

class _RulerGlyphPainter extends CustomPainter {
  final Color color;
  const _RulerGlyphPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1.5..style = PaintingStyle.stroke;
    final cy = size.height / 2;
    // Main ruler line
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), paint);
    // Tick marks
    for (int i = 0; i <= 4; i++) {
      final x = i * size.width / 4;
      final tickH = i % 2 == 0 ? 5.0 : 3.0;
      canvas.drawLine(Offset(x, cy - tickH), Offset(x, cy + tickH), paint);
    }
  }

  @override
  bool shouldRepaint(_RulerGlyphPainter old) => old.color != color;
}

class _MiniIllustPainter extends CustomPainter {
  final String type;
  final AppThemeTokens t;
  const _MiniIllustPainter({required this.type, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = t.paper3;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final inkPaint = Paint()..color = t.ink2..strokeWidth = 1.0..style = PaintingStyle.stroke;
    final mossPaint = Paint()..color = t.moss;
    final copperPaint = Paint()..color = t.copper;

    switch (type) {
      case 'healing':
        // Bench + tree simplified
        canvas.drawLine(Offset(6, 20), Offset(26, 20), inkPaint);
        canvas.drawCircle(Offset(50, 10), 8, mossPaint);
        canvas.drawLine(Offset(50, 18), Offset(50, 28), Paint()..color = t.ink2..strokeWidth = 2);
        canvas.drawCircle(Offset(10, 10), 4, Paint()..color = copperPaint.color);
      case 'explore':
        canvas.drawRect(Rect.fromLTWH(5, 8, 20, 22), inkPaint);
        canvas.drawRect(Rect.fromLTWH(30, 2, 24, 28), inkPaint);
        canvas.drawRect(Rect.fromLTWH(8, 14, 5, 6), Paint()..color = copperPaint.color);
      case 'breeze':
        canvas.drawLine(Offset(0, 18), Offset(64, 18), inkPaint);
        final hillPath = Path()
          ..moveTo(0, 18)
          ..quadraticBezierTo(20, 5, 40, 18)
          ..quadraticBezierTo(52, 28, 64, 18)
          ..lineTo(64, 32)
          ..lineTo(0, 32)
          ..close();
        canvas.drawPath(hillPath, mossPaint);
        canvas.drawCircle(Offset(52, 8), 7, copperPaint);
      case 'reflection':
        final riverPaint = Paint()..color = t.mossL;
        canvas.drawRect(Rect.fromLTWH(0, 20, 64, 12), riverPaint);
        final bridgePath = Path()
          ..moveTo(10, 20)
          ..quadraticBezierTo(32, 5, 54, 20);
        canvas.drawPath(bridgePath, inkPaint);
        canvas.drawLine(Offset(10, 20), Offset(54, 20), inkPaint);
    }
  }

  @override
  bool shouldRepaint(_MiniIllustPainter old) => old.type != type;
}

class _NotebookPainter extends CustomPainter {
  final AppThemeTokens t;
  const _NotebookPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = t.rule..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(8, 4, size.width - 16, size.height - 8),
      paint,
    );
    // Spine
    canvas.drawLine(Offset(16, 4), Offset(16, size.height - 4), paint);
    // Lines
    for (int i = 0; i < 3; i++) {
      final y = 20.0 + i * 12;
      canvas.drawLine(Offset(24, y), Offset(size.width - 12, y), paint);
    }
  }

  @override
  bool shouldRepaint(_NotebookPainter old) => false;
}
