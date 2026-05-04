import 'package:flutter/material.dart';
import '../../../theme/t.dart';

class IllustratedMap extends StatelessWidget {
  final int duration;
  final String mood;
  final double height;
  final bool withBorders;

  const IllustratedMap({
    super.key,
    required this.duration,
    required this.mood,
    this.height = 200,
    this.withBorders = true,
  });

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
    const tone = kIllustTokens;
    final pts = _pts(duration);
    final sp = pts.first;
    final ep = pts.last;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: tone.paper3,
        border: Border(
          top: withBorders
              ? BorderSide(color: tone.rule)
              : BorderSide.none,
          bottom: withBorders
              ? BorderSide(color: tone.rule)
              : BorderSide.none,
        ),
      ),
      child: ClipRect(
        child: CustomPaint(
          painter: _MapPainter(tone: tone, pts: pts, sp: sp, ep: ep),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final AppThemeTokens tone;
  final List<Offset> pts;
  final Offset sp, ep;

  const _MapPainter({
    required this.tone,
    required this.pts,
    required this.sp,
    required this.ep,
  });

  // viewBox 360×280 → actual size transform
  Offset _t(Offset p, Size size) =>
      Offset(p.dx * size.width / 360, p.dy * size.height / 280);
  double _sx(Size size) => size.width / 360;
  double _sy(Size size) => size.height / 280;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = _sx(size), sy = _sy(size);

    // BrandTilePattern tiles
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
                (col * 40 + 6) * sx, (row * 40 + 6) * sy, 28 * sx, 28 * sy),
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
          Rect.fromLTWH((cell[0] * 40 + 27) * sx, (cell[1] * 40 + 27) * sy,
              2.2 * sx, 2.2 * sy),
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
    parkPath.cubicTo(
        296 * sx, 24 * sy, 326 * sx, 60 * sy, 318 * sx, 132 * sy);
    parkPath.cubicTo(
        276 * sx, 148 * sy, 234 * sx, 132 * sy, 218 * sx, 68 * sy);
    parkPath.close();
    canvas.drawPath(
      parkPath,
      Paint()
        ..color = tone.mossL.withValues(alpha: 0.78)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      parkPath,
      Paint()
        ..color = tone.moss.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1 * sx,
    );

    // Park tree dots
    final treePaint = Paint()
      ..color = tone.moss.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;
    for (final d in [
      [252.0, 62.0, 2.6],
      [278.0, 74.0, 2.2],
      [298.0, 94.0, 2.6],
      [266.0, 108.0, 2.2],
      [240.0, 98.0, 2.4],
      [290.0, 118.0, 2.0],
    ]) {
      canvas.drawCircle(Offset(d[0] * sx, d[1] * sy), d[2] * sx, treePaint);
    }

    // Park label
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
    canvas.drawCircle(Offset(78 * sx, 248 * sy), 3.2 * sx,
        Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(
      Offset(78 * sx, 248 * sy),
      3.2 * sx,
      Paint()
        ..color = tone.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * sx,
    );
    _drawText(canvas, '시장', 86 * sx, 252 * sy, 9 * sx, tone.ink2,
        FontWeight.w700, TextAlign.left);

    canvas.drawCircle(Offset(156 * sx, 148 * sy), 3.2 * sx,
        Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(
      Offset(156 * sx, 148 * sy),
      3.2 * sx,
      Paint()
        ..color = tone.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * sx,
    );
    _drawText(canvas, '사거리', 162 * sx, 146 * sy, 9 * sx, tone.ink2,
        FontWeight.w700, TextAlign.left);

    // Route polyline (dashed copper)
    final scaledPts = pts.map((p) => _t(p, size)).toList();
    _drawPolylineDashed(
      canvas,
      scaledPts,
      Paint()
        ..color = tone.copper.withValues(alpha: 0.95)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6 * sx
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
      6 * sx,
      4 * sx,
    );

    // Start marker
    final spt = _t(sp, size);
    canvas.drawCircle(
        spt, 7 * sx, Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(
      spt,
      7 * sx,
      Paint()
        ..color = tone.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8 * sx,
    );
    canvas.drawCircle(
        spt, 2.5 * sx, Paint()..color = tone.ink..style = PaintingStyle.fill);

    // End flag
    final ept = _t(ep, size);
    canvas.drawLine(
      ept,
      Offset(ept.dx, ept.dy - 16 * sy),
      Paint()
        ..color = tone.ink
        ..strokeWidth = 1.6 * sx
        ..strokeCap = StrokeCap.round,
    );
    final flagPath = Path();
    flagPath.moveTo(ept.dx, ept.dy - 16 * sy);
    flagPath.lineTo(ept.dx + 12 * sx, ept.dy - 12 * sy);
    flagPath.lineTo(ept.dx, ept.dy - 8 * sy);
    flagPath.close();
    canvas.drawPath(
        flagPath, Paint()..color = tone.copper..style = PaintingStyle.fill);
    canvas.drawPath(
      flagPath,
      Paint()
        ..color = tone.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4 * sx
        ..strokeJoin = StrokeJoin.round,
    );

    // Compass (top right)
    final cx = 332 * sx, cy = 30 * sy;
    canvas.drawCircle(Offset(cx, cy), 11 * sx,
        Paint()..color = tone.paper2..style = PaintingStyle.fill);
    canvas.drawCircle(
      Offset(cx, cy),
      11 * sx,
      Paint()
        ..color = tone.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 * sx,
    );
    final compassPath = Path();
    compassPath.moveTo(cx, cy - 8 * sy);
    compassPath.lineTo(cx + 2.5 * sx, cy);
    compassPath.lineTo(cx, cy + 8 * sy);
    compassPath.lineTo(cx - 2.5 * sx, cy);
    compassPath.close();
    canvas.drawPath(
        compassPath, Paint()..color = tone.copper..style = PaintingStyle.fill);
    _drawText(canvas, 'N', cx, cy - 14 * sy, 7.5 * sx, tone.ink2,
        FontWeight.w800, TextAlign.center);
  }

  void _drawCubicBezier(Canvas canvas, Size size, Offset p0, Offset cp1,
      Offset cp2, Offset p3, Paint paint) {
    final sx = _sx(size), sy = _sy(size);
    final path = Path();
    path.moveTo(p0.dx * sx, p0.dy * sy);
    path.cubicTo(
        cp1.dx * sx, cp1.dy * sy, cp2.dx * sx, cp2.dy * sy,
        p3.dx * sx, p3.dy * sy);
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

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.pts != pts || old.tone != tone;
}
