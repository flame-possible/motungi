import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// 흰색(255,255,255)을 앱 paper 색(#F0E6D0 = 240,230,208)으로 매핑
// R 그대로, G 미세 감소, B 18% 감소 → 크림/베이지 웜톤
const List<double> _animeMatrix = [
  1.00, 0.00, 0.00, 0, 0,
  0.00, 0.97, 0.00, 0, 0,
  0.00, 0.00, 0.82, 0, 0,
  0,    0,    0,    1, 0,
];

class KakaoMapWidget extends StatefulWidget {
  final double lat;
  final double lng;
  final int level;

  const KakaoMapWidget({
    super.key,
    this.lat = 37.5665,
    this.lng = 126.9780,
    this.level = 16,
  });

  @override
  State<KakaoMapWidget> createState() => KakaoMapWidgetState();
}

class KakaoMapWidgetState extends State<KakaoMapWidget> {
  final MapController _mapController = MapController();
  LatLng? _currentPosition;
  final List<LatLng> _pathCoords = [];

  @override
  void initState() {
    super.initState();
    _initPosition();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initPosition() async {
    double lat = widget.lat;
    double lng = widget.lng;

    try {
      final permission = await Geolocator.checkPermission().then(
        (p) => p == LocationPermission.denied
            ? Geolocator.requestPermission()
            : Future.value(p),
      );
      if (permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
        lat = pos.latitude;
        lng = pos.longitude;
      }
    } catch (_) {}

    if (mounted) {
      _mapController.move(LatLng(lat, lng), widget.level.toDouble());
    }
  }

  void updatePosition(double lat, double lng) {
    final latlng = LatLng(lat, lng);
    setState(() {
      _currentPosition = latlng;
      _pathCoords.add(latlng);
    });
    _mapController.move(latlng, _mapController.camera.zoom);
  }

  void clearPath() {
    setState(() {
      _currentPosition = null;
      _pathCoords.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(_animeMatrix),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.lng),
          initialZoom: widget.level.toDouble(),
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'com.motungi.motungi',
          ),
          if (_pathCoords.length > 1)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _pathCoords,
                  strokeWidth: 4,
                  color: const Color(0xFF92AEC2),
                ),
              ],
            ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  width: 20,
                  height: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF92AEC2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
