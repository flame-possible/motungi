import 'package:flutter/material.dart';
import '../../../widgets/kakao_map/kakao_map_widget.dart';

class LiveMap extends StatefulWidget {
  final int duration;
  final double progress;
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

class _LiveMapState extends State<LiveMap> {
  final GlobalKey<KakaoMapWidgetState> _mapKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: KakaoMapWidget(
        key: _mapKey,
        lat: 37.5665,
        lng: 126.9780,
        level: 16,
      ),
    );
  }

  // GPS 위치 업데이트 (walk_screen에서 호출)
  void updatePosition(double lat, double lng) {
    _mapKey.currentState?.updatePosition(lat, lng);
  }
}
