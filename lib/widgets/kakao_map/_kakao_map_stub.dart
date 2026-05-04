import 'package:flutter/material.dart';

class KakaoMapWidget extends StatelessWidget {
  final double lat;
  final double lng;
  final int level;

  const KakaoMapWidget({
    super.key,
    this.lat = 37.5665,
    this.lng = 126.9780,
    this.level = 4,
  });

  @override
  Widget build(BuildContext context) =>
      const ColoredBox(color: Color(0xFFF0EBE0));
}
