import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class LiveMap extends StatefulWidget {
  final int duration;
  final double progress; // 0~1
  const LiveMap({super.key, required this.duration, required this.progress});

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();
    _pulse = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _pulseCtrl.dispose(); super.dispose(); }

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
      animation: _pulse,
      builder: (_, __) => CustomPaint(
        size: const Size(double.infinity, 220),
        painter: _LiveMapPainter(
          routePoints: _routePoints,
          progress: widget.progress,
          pulse: _pulse.value,
        ),
      ),
    );
  }
}

class _LiveMapPainter extends CustomPainter {
  final List<Offset> routePoints;
  final double progress;
  final double pulse;
  const _LiveMapPainter({required this.routePoints, required this.progress, required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 360;
    final sy = size.height / 280;
    final scaled = routePoints.map((p) => Offset(p.dx*sx, p.dy*sy)).toList();

    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.paper2);

    // 전체 경로 (흐린 점선)
    final fullPath = Path()..moveTo(scaled[0].dx, scaled[0].dy);
    for (int i = 1; i < scaled.length; i++) fullPath.lineTo(scaled[i].dx, scaled[i].dy);
    canvas.drawPath(fullPath, Paint()
      ..color = AppColors.ink.withValues(alpha: 0.15)
      ..strokeWidth = 2*sx
      ..style = PaintingStyle.stroke);

    // 현재 위치 계산
    double totalLen = 0;
    final lens = <double>[];
    for (int i = 1; i < scaled.length; i++) {
      final d = (scaled[i] - scaled[i-1]).distance;
      lens.add(d); totalLen += d;
    }
    final target = totalLen * progress.clamp(0, 1);
    double drawn = 0;
    Offset cur = scaled[0];
    final traveledPath = Path()..moveTo(scaled[0].dx, scaled[0].dy);
    for (int i = 0; i < lens.length; i++) {
      if (drawn + lens[i] <= target) {
        traveledPath.lineTo(scaled[i+1].dx, scaled[i+1].dy);
        drawn += lens[i]; cur = scaled[i+1];
      } else {
        final t = (target - drawn) / lens[i];
        cur = Offset.lerp(scaled[i], scaled[i+1], t)!;
        traveledPath.lineTo(cur.dx, cur.dy);
        break;
      }
    }

    // 완료 구간 실선
    canvas.drawPath(traveledPath, Paint()
      ..color = AppColors.copper
      ..strokeWidth = 3.2*sx
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round);

    // 맥박 원 (pulse 애니메이션)
    final pulseR = (8 + (pulse * 8)) * sx;
    final pulseOp = 0.32 - pulse * 0.28;
    canvas.drawCircle(cur, pulseR, Paint()..color = AppColors.copper.withValues(alpha: pulseOp));
    canvas.drawCircle(cur, 5*sx, Paint()..color = AppColors.copper);
  }

  @override
  bool shouldRepaint(_LiveMapPainter old) =>
    old.progress != progress || old.pulse != pulse;
}
