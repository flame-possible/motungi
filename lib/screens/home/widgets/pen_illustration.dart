import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../theme/t.dart';

class PenIllustration extends StatelessWidget {
  final String kind; // healing | breeze | reflection | explore
  final String mood; // 고요 | 활기 | 즉흥

  const PenIllustration({
    super.key,
    required this.kind,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PenPainter(kind: kind, mood: mood),
      child: const SizedBox.expand(),
    );
  }
}

class _PenPainter extends CustomPainter {
  final String kind;
  final String mood;

  _PenPainter({required this.kind, required this.mood});

  // viewBox 360 × 200
  double sx(Size s) => s.width / 360;
  double sy(Size s) => s.height / 200;
  Offset t(double x, double y, Size s) => Offset(x * sx(s), y * sy(s));

  @override
  void paint(Canvas canvas, Size size) {
    const tone = kIllustTokens;
    final ink = tone.ink;
    final accent = tone.copper;
    final quiet = mood == '고요';
    final lively = mood == '활기';

    // Mood wash
    final washColor = quiet
        ? const Color(0xFF788CA0).withValues(alpha: 0.07)
        : lively
            ? const Color(0xFFDC9650).withValues(alpha: 0.06)
            : const Color(0xFFA85A2A).withValues(alpha: 0.04);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = washColor,
    );

    // Normalize kind aliases
    final k = kind == 'exploration'
        ? 'explore'
        : kind == 'clearing'
            ? 'breeze'
            : kind == 'recovery'
                ? 'healing'
                : kind;

    switch (k) {
      case 'healing':
        _paintHealing(canvas, size, tone, ink, accent);
        break;
      case 'explore':
        _paintExplore(canvas, size, tone, ink, accent);
        break;
      case 'breeze':
        _paintBreeze(canvas, size, tone, ink, accent);
        break;
      case 'reflection':
        _paintReflection(canvas, size, tone, ink, accent);
        break;
      default:
        _paintHealing(canvas, size, tone, ink, accent);
    }
  }

  Paint _stroke(Color c, double w,
          {StrokeCap cap = StrokeCap.round}) =>
      Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = w
        ..strokeCap = cap
        ..strokeJoin = StrokeJoin.round;

  Paint _fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;

  // healing — 벤치 + 나무 + 해
  void _paintHealing(Canvas canvas, Size size, AppThemeTokens T, Color ink,
      Color accent) {
    final sxV = sx(size), syV = sy(size);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _fill(T.paper3));

    // ground line
    final groundY = 155 * syV;
    canvas.drawLine(Offset(0, groundY), Offset(size.width, groundY),
        _stroke(ink.withValues(alpha: 0.25), 1.0 * syV));

    // sun (top right)
    canvas.drawCircle(
        t(295, 55, size), 28 * sxV, _fill(T.copperL.withValues(alpha: 0.7)));
    canvas.drawCircle(t(295, 55, size), 28 * sxV, _stroke(accent, 1.2 * sxV));

    // tree trunk
    canvas.drawLine(
        t(100, 155, size), t(100, 80, size), _stroke(ink, 2.2 * sxV));
    // tree canopy
    canvas.drawCircle(t(100, 70, size), 26 * sxV, _fill(T.paper2));
    canvas.drawCircle(t(100, 70, size), 26 * sxV, _stroke(ink, 1.4 * sxV));

    // foliage texture
    final foliagePaint = Paint()
      ..color = T.moss.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * sxV
      ..strokeCap = StrokeCap.round;
    for (final d in [
      [80.0, 58.0, 92.0, 56.0],
      [84.0, 52.0, 92.0, 50.0],
      [100.0, 50.0, 108.0, 50.0],
    ]) {
      canvas.drawLine(Offset(d[0] * sxV, d[1] * syV),
          Offset(d[2] * sxV, d[3] * syV), foliagePaint);
    }

    // bench seat
    canvas.drawLine(
        t(195, 155, size), t(260, 155, size), _stroke(ink, 2.8 * sxV));
    // bench legs
    canvas.drawLine(
        t(198, 155, size), t(198, 168, size), _stroke(ink, 2 * sxV));
    canvas.drawLine(
        t(257, 155, size), t(257, 168, size), _stroke(ink, 2 * sxV));
    // bench back
    canvas.drawLine(
        t(193, 148, size), t(262, 148, size), _stroke(ink, 1.8 * sxV));
  }

  // explore — 골목 양옆 가게
  void _paintExplore(Canvas canvas, Size size, AppThemeTokens T, Color ink,
      Color accent) {
    final sxV = sx(size), syV = sy(size);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _fill(T.paper3));

    // left building
    canvas.drawRect(
        Rect.fromLTWH(20 * sxV, 30 * syV, 95 * sxV, 140 * syV),
        _fill(T.paper2));
    canvas.drawRect(
        Rect.fromLTWH(20 * sxV, 30 * syV, 95 * sxV, 140 * syV),
        _stroke(ink, 1.6 * sxV));

    // windows (left building)
    for (final pos in [
      [32.0, 55.0], [65.0, 55.0],
      [32.0, 95.0], [65.0, 95.0],
      [32.0, 135.0], [65.0, 135.0],
    ]) {
      canvas.drawRect(
        Rect.fromLTWH(pos[0] * sxV, pos[1] * syV, 18 * sxV, 20 * syV),
        Paint()
          ..color = ink.withValues(alpha: 0.12)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        Rect.fromLTWH(pos[0] * sxV, pos[1] * syV, 18 * sxV, 20 * syV),
        _stroke(ink.withValues(alpha: 0.4), 0.8 * sxV),
      );
    }

    // right building
    canvas.drawRect(
        Rect.fromLTWH(245 * sxV, 15 * syV, 95 * sxV, 155 * syV),
        _fill(T.paper2));
    canvas.drawRect(
        Rect.fromLTWH(245 * sxV, 15 * syV, 95 * sxV, 155 * syV),
        _stroke(ink, 1.6 * sxV));

    // windows (right building)
    for (final pos in [
      [258.0, 40.0], [292.0, 40.0],
      [258.0, 80.0], [292.0, 80.0],
      [258.0, 120.0], [292.0, 120.0],
    ]) {
      canvas.drawRect(
        Rect.fromLTWH(pos[0] * sxV, pos[1] * syV, 18 * sxV, 20 * syV),
        Paint()
          ..color = ink.withValues(alpha: 0.12)
          ..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        Rect.fromLTWH(pos[0] * sxV, pos[1] * syV, 18 * sxV, 20 * syV),
        _stroke(ink.withValues(alpha: 0.4), 0.8 * sxV),
      );
    }

    // alley path (dashed copper)
    final alleyPath = Path();
    alleyPath.moveTo(115 * sxV, 180 * syV);
    alleyPath.quadraticBezierTo(
        160 * sxV, 155 * syV, 200 * sxV, 165 * syV);
    alleyPath.quadraticBezierTo(
        230 * sxV, 175 * syV, 245 * sxV, 150 * syV);
    _drawDashedPath(canvas, alleyPath,
        _stroke(accent.withValues(alpha: 0.85), 1.6 * sxV), 8 * sxV, 5 * sxV);
  }

  // breeze — 트인 풍경 + 바람
  void _paintBreeze(Canvas canvas, Size size, AppThemeTokens T, Color ink,
      Color accent) {
    final sxV = sx(size), syV = sy(size);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _fill(T.paper3));

    // distant hills
    final hill1 = Path();
    hill1.moveTo(0, 130 * syV);
    hill1.quadraticBezierTo(90 * sxV, 100 * syV, 180 * sxV, 118 * syV);
    hill1.quadraticBezierTo(270 * sxV, 136 * syV, 360 * sxV, 118 * syV);
    hill1.lineTo(360 * sxV, size.height);
    hill1.lineTo(0, size.height);
    hill1.close();
    canvas.drawPath(hill1, _fill(T.mossL.withValues(alpha: 0.55)));

    // sun
    canvas.drawCircle(
        t(290, 72, size), 32 * sxV, _fill(T.copperL.withValues(alpha: 0.8)));
    canvas.drawCircle(t(290, 72, size), 32 * sxV, _stroke(accent, 1.4 * sxV));

    // sun rays (8 radial lines)
    final rayPaint = _stroke(accent.withValues(alpha: 0.6), 1.0 * sxV);
    final sunCx = 290 * sxV, sunCy = 72 * syV;
    final inner = 36 * sxV, outer = 44 * sxV;
    for (int i = 0; i < 8; i++) {
      final angle = i * 45.0 * (math.pi / 180);
      canvas.drawLine(
        Offset(sunCx + inner * math.cos(angle), sunCy + inner * math.sin(angle)),
        Offset(sunCx + outer * math.cos(angle), sunCy + outer * math.sin(angle)),
        rayPaint,
      );
    }

    // wind lines
    final windPaint = _stroke(ink.withValues(alpha: 0.45), 1.2 * syV);
    for (final y in [110.0, 135.0, 158.0]) {
      final wp = Path();
      wp.moveTo(0, y * syV);
      wp.quadraticBezierTo(
          90 * sxV, (y - 6) * syV, 180 * sxV, y * syV);
      wp.quadraticBezierTo(
          270 * sxV, (y + 6) * syV, 360 * sxV, y * syV);
      canvas.drawPath(wp, windPaint);
    }
  }

  // reflection — 천변 + 다리 + 인물
  void _paintReflection(Canvas canvas, Size size, AppThemeTokens T, Color ink,
      Color accent) {
    final sxV = sx(size), syV = sy(size);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), _fill(T.paper3));

    // distant hill
    final hill = Path();
    hill.moveTo(0, 100 * syV);
    hill.quadraticBezierTo(90 * sxV, 75 * syV, 180 * sxV, 95 * syV);
    hill.quadraticBezierTo(270 * sxV, 115 * syV, 360 * sxV, 95 * syV);
    hill.lineTo(360 * sxV, 140 * syV);
    hill.lineTo(0, 140 * syV);
    hill.close();
    canvas.drawPath(hill, _fill(T.mossL.withValues(alpha: 0.7)));

    // water band
    canvas.drawRect(
      Rect.fromLTWH(0, 140 * syV, size.width, 40 * syV),
      _fill(const Color(0xFFC8D6DA).withValues(alpha: 0.7)),
    );

    // ripples
    for (final row in [
      [4.0, 153.0, 52.0],
      [30.0, 162.0, 80.0],
    ]) {
      final rp = Path();
      rp.moveTo(row[0] * sxV, row[1] * syV);
      rp.quadraticBezierTo(
        (row[0] + row[2] / 2) * sxV,
        (row[1] - 3) * syV,
        (row[0] + row[2]) * sxV,
        row[1] * syV,
      );
      canvas.drawPath(
          rp,
          _stroke(
              const Color(0xFF7BA0B0).withValues(alpha: 0.6), 0.8 * syV));
    }

    // bridge
    final bridge = Path();
    bridge.moveTo(200 * sxV, 140 * syV);
    bridge.lineTo(200 * sxV, 158 * syV);
    bridge.lineTo(295 * sxV, 156 * syV);
    bridge.lineTo(295 * sxV, 138 * syV);
    bridge.close();
    canvas.drawPath(bridge, _fill(T.paper2));
    canvas.drawPath(bridge, _stroke(ink, 1.1 * sxV));
    canvas.drawLine(
        t(200, 136, size), t(295, 134, size), _stroke(ink, 0.9 * sxV));

    // figure (head)
    canvas.drawCircle(t(90, 95, size), 5 * sxV, _fill(ink));
    // body
    canvas.drawLine(
        t(90, 100, size), t(90, 118, size), _stroke(ink, 2 * sxV));
    // legs
    canvas.drawLine(
        t(83, 122, size), t(90, 118, size), _stroke(ink, 1.6 * sxV));
    canvas.drawLine(
        t(97, 122, size), t(90, 118, size), _stroke(ink, 1.6 * sxV));

    // bank line
    canvas.drawLine(
      t(0, 182, size),
      t(360, 180, size),
      _stroke(ink.withValues(alpha: 0.25), 0.8 * syV),
    );
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashLen,
      double gapLen) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double dist = 0;
      bool draw = true;
      while (dist < metric.length) {
        final len = draw ? dashLen : gapLen;
        if (draw) {
          canvas.drawPath(
            metric.extractPath(dist, (dist + len).clamp(0.0, metric.length)),
            paint,
          );
        }
        dist += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_PenPainter old) =>
      old.kind != kind || old.mood != mood;
}
