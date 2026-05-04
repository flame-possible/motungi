import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class IllustratedMap extends StatefulWidget {
  final int duration;
  final String mood;
  const IllustratedMap({super.key, required this.duration, required this.mood});

  @override
  State<IllustratedMap> createState() => _IllustratedMapState();
}

class _IllustratedMapState extends State<IllustratedMap> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  List<Offset> get _routePoints {
    if (widget.duration <= 10) {
      return const [Offset(60,170),Offset(105,95),Offset(195,82),Offset(250,130),Offset(200,180),Offset(130,180)];
    } else if (widget.duration <= 20) {
      return const [Offset(50,180),Offset(90,108),Offset(160,75),Offset(240,82),Offset(285,135),Offset(270,195),Offset(180,210),Offset(80,202)];
    } else {
      return const [Offset(30,205),Offset(70,115),Offset(140,62),Offset(245,80),Offset(318,145),Offset(286,212),Offset(198,232),Offset(100,222),Offset(52,210)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (_, __) => CustomPaint(
        size: const Size(double.infinity, 200),
        painter: _MapPainter(routePoints: _routePoints, progress: _progress.value),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final List<Offset> routePoints;
  final double progress;
  const _MapPainter({required this.routePoints, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 360;
    final sy = size.height / 280;

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.paper2);
    _drawRoad(canvas, sx, sy);
    _drawPark(canvas, sx, sy);
    _drawStream(canvas, sx, sy);
    _drawLandmarks(canvas, sx, sy);
    _drawRoute(canvas, sx, sy);
    _drawMarkers(canvas, sx, sy);
    _drawCompass(canvas, sx, sy);
  }

  void _drawRoad(Canvas canvas, double sx, double sy) {
    final path = Path()..moveTo((-10)*sx, 210*sy)
      ..quadraticBezierTo(100*sx, 188*sy, 200*sx, 202*sy)
      ..quadraticBezierTo(290*sx, 216*sy, 380*sx, 208*sy);
    canvas.drawPath(path, Paint()..color = const Color(0xFFD8C8A2)..strokeWidth = 14*sx..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    canvas.drawPath(path, Paint()..color = AppColors.paper2..strokeWidth = 6*sx..style = PaintingStyle.stroke);
    canvas.drawPath(path, Paint()..color = AppColors.copper..strokeWidth = 0.6*sx..style = PaintingStyle.stroke..strokeJoin = StrokeJoin.round);
  }

  void _drawPark(Canvas canvas, double sx, double sy) {
    final path = Path()..moveTo(232*sx,30*sy)
      ..quadraticBezierTo(296*sx,24*sy,326*sx,60*sy)
      ..quadraticBezierTo(348*sx,100*sy,318*sx,132*sy)
      ..quadraticBezierTo(290*sx,160*sy,252*sx,148*sy)
      ..quadraticBezierTo(220*sx,136*sy,218*sx,100*sy)
      ..quadraticBezierTo(216*sx,56*sy,232*sx,30*sy)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.mossL.withValues(alpha: 0.5));
    for (final c in [Offset(252,62),Offset(278,74),Offset(302,58),Offset(318,90),Offset(264,110),Offset(290,100)]) {
      canvas.drawCircle(Offset(c.dx*sx, c.dy*sy), 2.6*sx, Paint()..color = AppColors.moss);
    }
  }

  void _drawStream(Canvas canvas, double sx, double sy) {
    final path = Path()..moveTo(-10*sx,60*sy)
      ..quadraticBezierTo(50*sx,56*sy,95*sx,70*sy)
      ..quadraticBezierTo(135*sx,82*sy,175*sx,70*sy);
    canvas.drawPath(path, Paint()..color = const Color(0xFF9BB7C4)..strokeWidth = 2*sx..style = PaintingStyle.stroke);
  }

  void _drawLandmarks(Canvas canvas, double sx, double sy) {
    final paint = Paint()..color = AppColors.copper;
    canvas.drawCircle(Offset(78*sx,248*sy), 3.2*sx, paint);
    canvas.drawCircle(Offset(195*sx,155*sy), 2.8*sx, paint);
  }

  void _drawRoute(Canvas canvas, double sx, double sy) {
    if (routePoints.isEmpty || progress == 0) return;
    final scaled = routePoints.map((p) => Offset(p.dx*sx, p.dy*sy)).toList();
    double totalLen = 0;
    final lens = <double>[];
    for (int i = 1; i < scaled.length; i++) {
      final d = (scaled[i] - scaled[i-1]).distance;
      lens.add(d);
      totalLen += d;
    }
    final target = totalLen * progress;
    double drawn = 0;
    final path = Path()..moveTo(scaled[0].dx, scaled[0].dy);
    for (int i = 0; i < lens.length; i++) {
      if (drawn + lens[i] <= target) {
        path.lineTo(scaled[i+1].dx, scaled[i+1].dy);
        drawn += lens[i];
      } else {
        final t = (target - drawn) / lens[i];
        final p = Offset.lerp(scaled[i], scaled[i+1], t)!;
        path.lineTo(p.dx, p.dy);
        break;
      }
    }
    canvas.drawPath(path, Paint()
      ..color = AppColors.copper
      ..strokeWidth = 2.6*sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);
  }

  void _drawMarkers(Canvas canvas, double sx, double sy) {
    if (routePoints.isEmpty) return;
    final start = Offset(routePoints.first.dx*sx, routePoints.first.dy*sy);
    final end   = Offset(routePoints.last.dx*sx, routePoints.last.dy*sy);
    canvas.drawCircle(start, 7*sx, Paint()..color = AppColors.copper.withValues(alpha: 0.25));
    canvas.drawCircle(start, 2.5*sx, Paint()..color = AppColors.copper);
    if (progress >= 1) {
      final flagPath = Path()
        ..moveTo(end.dx, end.dy)
        ..lineTo(end.dx, end.dy - 16*sy)
        ..lineTo(end.dx + 10*sx, end.dy - 11*sy)
        ..lineTo(end.dx, end.dy - 6*sy);
      canvas.drawPath(flagPath, Paint()..color = AppColors.copper..style = PaintingStyle.fill);
    }
  }

  void _drawCompass(Canvas canvas, double sx, double sy) {
    final cx = 332*sx;
    final cy = 30*sy;
    canvas.drawCircle(Offset(cx,cy), 11*sx, Paint()..color = AppColors.paper2);
    canvas.drawCircle(Offset(cx,cy), 11*sx, Paint()..color = AppColors.border..style = PaintingStyle.stroke..strokeWidth = 1);
    final arrow = Path()
      ..moveTo(cx, cy-8*sy)
      ..lineTo(cx+2.5*sx, cy)
      ..lineTo(cx, cy+8*sy)
      ..lineTo(cx-2.5*sx, cy)
      ..close();
    canvas.drawPath(arrow, Paint()..color = AppColors.copper);
  }

  @override
  bool shouldRepaint(_MapPainter old) => old.progress != progress || old.routePoints != routePoints;
}
