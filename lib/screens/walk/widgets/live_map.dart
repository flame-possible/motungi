import 'package:flutter/material.dart';
import '../../../theme/t.dart';

// viewBox: 360×280, actual height: 220
// Accent colors:
//   allDone=true  → T.moss / T.mossL
//   allDone=false → T.slate / T.slateL

class LiveMap extends StatefulWidget {
  final int duration;
  final double progress; // 0.0 ~ 1.0
  final bool allDone;

  const LiveMap({
    super.key,
    required this.duration,
    required this.progress,
    this.allDone = false,
  });

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  static List<Offset> _pts(int duration) {
    if (duration <= 10) {
      return const [
        Offset(60, 170), Offset(105, 95), Offset(195, 82),
        Offset(250, 130), Offset(200, 180), Offset(130, 180),
      ];
    } else if (duration <= 20) {
      return const [
        Offset(50, 180), Offset(90, 108), Offset(160, 75),
        Offset(240, 82), Offset(285, 135), Offset(270, 195),
        Offset(180, 210), Offset(80, 202),
      ];
    } else {
      return const [
        Offset(30, 205), Offset(70, 115), Offset(140, 62),
        Offset(245, 80), Offset(318, 145), Offset(286, 212),
        Offset(198, 232), Offset(100, 222), Offset(52, 210),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final pts = _pts(widget.duration);
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) => CustomPaint(
        size: const Size(double.infinity, 220),
        painter: _LiveMapPainter(
          pts: pts,
          progress: widget.progress,
          pulse: _pulse.value,
          allDone: widget.allDone,
        ),
      ),
    );
  }
}

class _LiveMapPainter extends CustomPainter {
  final List<Offset> pts;
  final double progress;
  final double pulse;
  final bool allDone;

  const _LiveMapPainter({
    required this.pts,
    required this.progress,
    required this.pulse,
    required this.allDone,
  });

  // viewBox 360×280 → actual size transform
  Offset _t(Offset p, Size size) =>
      Offset(p.dx * size.width / 360, p.dy * size.height / 280);
  double _sx(Size size) => size.width / 360;
  double _sy(Size size) => size.height / 280;

  @override
  void paint(Canvas canvas, Size size) {
    // Always-light illustration tokens
    const tone = kIllustTokens;

    final accentColor = allDone ? const Color(0xFF97AC85) : const Color(0xFF92AEC2);

    final sx = _sx(size);
    final sy = _sy(size);

    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = tone.paper3);

    // BrandTilePattern (inline)
    final tilePaint = Paint()
      ..color = tone.paper2.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    final dotPaint = Paint()
      ..color = tone.moss.withValues(alpha: 0.32)
      ..style = PaintingStyle.fill;
    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 9; col++) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              (col * 40 + 6) * sx,
              (row * 40 + 6) * sy,
              28 * sx,
              28 * sy,
            ),
            Radius.circular(5 * sx),
          ),
          tilePaint,
        );
      }
    }
    for (final cell in [
      [1, 0], [7, 0], [0, 3], [6, 4], [3, 6], [8, 5],
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            (cell[0] * 40 + 27) * sx,
            (cell[1] * 40 + 27) * sy,
            2.2 * sx,
            2.2 * sy,
          ),
          Radius.circular(0.6 * sx),
        ),
        dotPaint,
      );
    }

    // Main road (avenue) — 3 layers
    _drawCubicBezier(
      canvas, size,
      const Offset(-10, 210), const Offset(100, 188),
      const Offset(200, 202), const Offset(380, 208),
      Paint()
        ..color = const Color(0xFFD8C8A2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14 * sy
        ..strokeCap = StrokeCap.round,
    );
    _drawCubicBezier(
      canvas, size,
      const Offset(-10, 210), const Offset(100, 188),
      const Offset(200, 202), const Offset(380, 208),
      Paint()
        ..color = tone.paper2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6 * sy
        ..strokeCap = StrokeCap.round,
    );
    _drawCubicBezier(
      canvas, size,
      const Offset(-10, 210), const Offset(100, 188),
      const Offset(200, 202), const Offset(380, 208),
      Paint()
        ..color = tone.copper.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6 * sy,
    );

    // Secondary cross-street
    _drawCubicBezier(
      canvas, size,
      const Offset(150, -10), const Offset(145, 100),
      const Offset(156, 200), const Offset(152, 290),
      Paint()
        ..color = const Color(0xFFE1D2AC)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9 * sx
        ..strokeCap = StrokeCap.round,
    );
    _drawCubicBezier(
      canvas, size,
      const Offset(150, -10), const Offset(145, 100),
      const Offset(156, 200), const Offset(152, 290),
      Paint()
        ..color = tone.paper2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5 * sx
        ..strokeCap = StrokeCap.round,
    );

    // Alleyways
    _drawQuadBezier(
      canvas, size,
      const Offset(30, 80), const Offset(90, 84), const Offset(140, 78),
      Paint()
        ..color = const Color(0xFFE1D2AC).withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5 * sy
        ..strokeCap = StrokeCap.round,
    );
    _drawQuadBezier(
      canvas, size,
      const Offset(230, 250), const Offset(290, 246), const Offset(340, 252),
      Paint()
        ..color = const Color(0xFFE1D2AC).withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5 * sy
        ..strokeCap = StrokeCap.round,
    );

    // Park (top right)
    final parkPath = Path();
    parkPath.moveTo(232 * sx, 30 * sy);
    parkPath.cubicTo(296 * sx, 24 * sy, 326 * sx, 60 * sy, 318 * sx, 132 * sy);
    parkPath.cubicTo(276 * sx, 148 * sy, 234 * sx, 132 * sy, 218 * sx, 68 * sy);
    parkPath.close();
    canvas.drawPath(parkPath,
        Paint()..color = tone.mossL.withValues(alpha: 0.78)..style = PaintingStyle.fill);
    canvas.drawPath(parkPath,
        Paint()..color = tone.moss.withValues(alpha: 0.5)..style = PaintingStyle.stroke..strokeWidth = 1.1 * sx);

    // Park tree dots
    final treePaint = Paint()..color = tone.moss.withValues(alpha: 0.7)..style = PaintingStyle.fill;
    for (final d in [
      [252.0, 62.0, 2.6], [278.0, 74.0, 2.2], [298.0, 94.0, 2.6],
      [266.0, 108.0, 2.2], [240.0, 98.0, 2.4], [290.0, 118.0, 2.0],
    ]) {
      canvas.drawCircle(Offset(d[0] * sx, d[1] * sy), d[2] * sx, treePaint);
    }
    _drawText(canvas, '공원', 276 * sx, 92 * sy, 9.5 * sx,
        tone.ink.withValues(alpha: 0.78), FontWeight.w700, TextAlign.center);

    // Stream (top left)
    _drawCubicBezier(
      canvas, size,
      const Offset(-10, 60), const Offset(50, 56),
      const Offset(95, 70), const Offset(175, 70),
      Paint()
        ..color = const Color(0xFF9BB7C4).withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * sy
        ..strokeCap = StrokeCap.round,
    );
    _drawText(canvas, '개천', 60 * sx, 46 * sy, 9 * sx,
        tone.ink.withValues(alpha: 0.6), FontWeight.w700, TextAlign.center);

    // Landmark dots
    _drawLandmarkDot(canvas, Offset(78 * sx, 248 * sy), sx, tone);
    _drawText(canvas, '시장', 86 * sx, 252 * sy, 9 * sx, tone.ink2, FontWeight.w700, TextAlign.left);
    _drawLandmarkDot(canvas, Offset(156 * sx, 148 * sy), sx, tone);
    _drawText(canvas, '사거리', 162 * sx, 146 * sy, 9 * sx, tone.ink2, FontWeight.w700, TextAlign.left);

    // ── Route polylines ──

    final scaledPts = pts.map((p) => _t(p, size)).toList();

    // Full route (faint dashed, opacity: 0.3)
    _drawPolylineDashed(
      canvas,
      scaledPts,
      Paint()
        ..color = accentColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6 * sx
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
      6 * sx,
      4 * sx,
    );

    // Current position calculation
    double totalLen = 0;
    final lens = <double>[];
    for (int i = 1; i < scaledPts.length; i++) {
      final d = (scaledPts[i] - scaledPts[i - 1]).distance;
      lens.add(d);
      totalLen += d;
    }
    final target = totalLen * progress.clamp(0.0, 1.0);
    double drawn = 0;
    Offset cur = scaledPts[0];
    final traveledPath = Path()..moveTo(scaledPts[0].dx, scaledPts[0].dy);
    for (int i = 0; i < lens.length; i++) {
      if (drawn + lens[i] <= target) {
        traveledPath.lineTo(scaledPts[i + 1].dx, scaledPts[i + 1].dy);
        drawn += lens[i];
        cur = scaledPts[i + 1];
      } else {
        final t = lens[i] > 0 ? (target - drawn) / lens[i] : 0.0;
        cur = Offset.lerp(scaledPts[i], scaledPts[i + 1], t)!;
        traveledPath.lineTo(cur.dx, cur.dy);
        break;
      }
    }

    // Traveled route (solid, opacity: 0.95)
    canvas.drawPath(traveledPath, Paint()
      ..color = accentColor.withValues(alpha: 0.95)
      ..strokeWidth = 3.2 * sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    // ── Start marker ──
    final spt = scaledPts[0];
    canvas.drawCircle(spt, 7 * sx, Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(spt, 7 * sx,
        Paint()..color = tone.ink..style = PaintingStyle.stroke..strokeWidth = 1.8 * sx);
    canvas.drawCircle(spt, 2.5 * sx, Paint()..color = tone.ink..style = PaintingStyle.fill);

    // ── End flag marker ──
    final ept = scaledPts.last;
    canvas.drawLine(
      ept, Offset(ept.dx, ept.dy - 16 * sy),
      Paint()..color = tone.ink..strokeWidth = 1.6 * sx..strokeCap = StrokeCap.round,
    );
    final flagPath = Path();
    flagPath.moveTo(ept.dx, ept.dy - 16 * sy);
    flagPath.lineTo(ept.dx + 12 * sx, ept.dy - 12 * sy);
    flagPath.lineTo(ept.dx, ept.dy - 8 * sy);
    flagPath.close();
    canvas.drawPath(flagPath, Paint()..color = tone.copper..style = PaintingStyle.fill);
    canvas.drawPath(flagPath, Paint()
      ..color = tone.ink..style = PaintingStyle.stroke..strokeWidth = 1.4 * sx..strokeJoin = StrokeJoin.round);

    // ── Current position dot (pulse animation) ──
    // Outer pulse: r 8→16→8, opacity 0.32→0.04→0.32
    final pulseR = (8 + pulse * 8) * sx;
    final pulseOp = 0.32 - pulse * 0.28;
    canvas.drawCircle(cur, pulseR, Paint()..color = accentColor.withValues(alpha: pulseOp));
    // Middle ring: paper2 fill + ink stroke (r: 6.4)
    canvas.drawCircle(cur, 6.4 * sx, Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(cur, 6.4 * sx,
        Paint()..color = tone.ink..style = PaintingStyle.stroke..strokeWidth = 1.2 * sx);
    // Inner dot: accent fill (r: 3.2)
    canvas.drawCircle(cur, 3.2 * sx, Paint()..color = accentColor..style = PaintingStyle.fill);

    // "지금" label
    _drawTextWithHalo(canvas, '지금', cur.dx, cur.dy - 16 * sy, 9 * sx,
        accentColor, tone.paper2);

    // ── Compass (bottom right: translate(326, 232)) ──
    final cx = 326 * sx, cy = 232 * sy;
    canvas.drawCircle(Offset(cx, cy), 11 * sx,
        Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(cx, cy), 11 * sx,
        Paint()..color = tone.ink..style = PaintingStyle.stroke..strokeWidth = 1 * sx);
    final compassPath = Path();
    compassPath.moveTo(cx, cy - 8 * sy);
    compassPath.lineTo(cx + 2.5 * sx, cy);
    compassPath.lineTo(cx, cy + 8 * sy);
    compassPath.lineTo(cx - 2.5 * sx, cy);
    compassPath.close();
    canvas.drawPath(compassPath, Paint()..color = tone.copper..style = PaintingStyle.fill);
    _drawText(canvas, 'N', cx, cy - 14 * sy, 7.5 * sx, tone.ink2, FontWeight.w800, TextAlign.center);
  }

  void _drawLandmarkDot(Canvas canvas, Offset pt, double sx, AppThemeTokens tone) {
    canvas.drawCircle(pt, 3.2 * sx, Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(pt, 3.2 * sx,
        Paint()..color = tone.ink..style = PaintingStyle.stroke..strokeWidth = 1.2 * sx);
  }

  void _drawCubicBezier(Canvas canvas, Size size, Offset p0, Offset cp1,
      Offset cp2, Offset p3, Paint paint) {
    final sx = _sx(size), sy = _sy(size);
    final path = Path();
    path.moveTo(p0.dx * sx, p0.dy * sy);
    path.cubicTo(
      cp1.dx * sx, cp1.dy * sy,
      cp2.dx * sx, cp2.dy * sy,
      p3.dx * sx, p3.dy * sy,
    );
    canvas.drawPath(path, paint);
  }

  void _drawQuadBezier(Canvas canvas, Size size, Offset p0, Offset cp,
      Offset p1, Paint paint) {
    final sx = _sx(size), sy = _sy(size);
    final path = Path();
    path.moveTo(p0.dx * sx, p0.dy * sy);
    path.quadraticBezierTo(cp.dx * sx, cp.dy * sy, p1.dx * sx, p1.dy * sy);
    canvas.drawPath(path, paint);
  }

  void _drawPolylineDashed(Canvas canvas, List<Offset> points, Paint paint,
      double dashLen, double gapLen) {
    if (points.length < 2) return;
    for (int i = 0; i < points.length - 1; i++) {
      final start = points[i], end = points[i + 1];
      final dx = end.dx - start.dx, dy = end.dy - start.dy;
      final len = (end - start).distance;
      double traveled = 0;
      bool drawing = true;
      while (traveled < len) {
        final segLen = drawing ? dashLen : gapLen;
        final next = (traveled + segLen).clamp(0.0, len);
        if (drawing) {
          final t0 = traveled / len, t1 = next / len;
          canvas.drawLine(
            Offset(start.dx + dx * t0, start.dy + dy * t0),
            Offset(start.dx + dx * t1, start.dy + dy * t1),
            paint,
          );
        }
        traveled += segLen;
        drawing = !drawing;
      }
    }
  }

  void _drawText(Canvas canvas, String text, double x, double y,
      double fontSize, Color color, FontWeight weight, TextAlign align) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, color: color, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout();
    final ox = align == TextAlign.center ? x - tp.width / 2 : x;
    tp.paint(canvas, Offset(ox, y - tp.height / 2));
  }

  void _drawTextWithHalo(Canvas canvas, String text, double x, double y,
      double fontSize, Color textColor, Color haloColor) {
    final haloTp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          color: haloColor,
          fontWeight: FontWeight.w700,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = haloColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    haloTp.paint(canvas, Offset(x - haloTp.width / 2, y - haloTp.height / 2));

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, color: textColor, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(_LiveMapPainter old) =>
      old.progress != progress || old.pulse != pulse || old.allDone != allDone;
}
