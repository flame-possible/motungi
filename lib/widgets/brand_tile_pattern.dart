import 'package:flutter/material.dart';
import '../theme/t.dart';

class BrandTilePattern extends StatelessWidget {
  final AppThemeTokens tone;
  const BrandTilePattern({super.key, required this.tone});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BrandTilePainter(tone));
  }
}

class _BrandTilePainter extends CustomPainter {
  final AppThemeTokens tone;
  _BrandTilePainter(this.tone);

  @override
  void paint(Canvas canvas, Size size) {
    final tilePaint = Paint()
      ..color = tone.paper2.withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;

    // 7 rows × 9 cols tiles
    for (int row = 0; row < 7; row++) {
      for (int col = 0; col < 9; col++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(col * 40.0 + 6, row * 40.0 + 6, 28, 28),
          const Radius.circular(5),
        );
        canvas.drawRRect(rect, tilePaint);
      }
    }

    // discovery dots
    final dotPaint = Paint()
      ..color = tone.moss.withValues(alpha: 0.32)
      ..style = PaintingStyle.fill;

    const dotCells = [
      [1, 0], [7, 0], [0, 3], [6, 4], [3, 6], [8, 5],
    ];
    for (final cell in dotCells) {
      final col = cell[0], row = cell[1];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(col * 40.0 + 27, row * 40.0 + 27, 2.2, 2.2),
        const Radius.circular(0.6),
      );
      canvas.drawRRect(rect, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_BrandTilePainter old) => old.tone != tone;
}
