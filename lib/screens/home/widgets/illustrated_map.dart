import 'package:flutter/material.dart';
import '../../../theme/t.dart';
import '../../../widgets/kakao_map/kakao_map_widget.dart';

class IllustratedMap extends StatelessWidget {
  final int duration;
  final String mood;
  final double height;
  final bool withBorders;

  // 기본 중심 좌표 (서울 시청)
  static const double _defaultLat = 37.5665;
  static const double _defaultLng = 126.9780;

  const IllustratedMap({
    super.key,
    required this.duration,
    required this.mood,
    this.height = 200,
    this.withBorders = true,
  });

  @override
  Widget build(BuildContext context) {
    const tone = kIllustTokens;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: tone.paper3,
        border: Border(
          top: withBorders ? BorderSide(color: tone.rule) : BorderSide.none,
          bottom: withBorders ? BorderSide(color: tone.rule) : BorderSide.none,
        ),
      ),
      child: ClipRect(
        child: KakaoMapWidget(
          lat: _defaultLat,
          lng: _defaultLng,
          level: _zoomLevel(duration),
        ),
      ),
    );
  }

  // 거리가 길수록 더 넓은 범위 표시
  int _zoomLevel(int duration) {
    if (duration <= 10) return 16;
    if (duration <= 20) return 15;
    return 14;
  }
}
