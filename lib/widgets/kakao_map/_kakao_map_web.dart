// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KakaoMapWidget extends StatefulWidget {
  final double lat;
  final double lng;
  final int level;

  const KakaoMapWidget({
    super.key,
    this.lat = 37.5665,
    this.lng = 126.9780,
    this.level = 14,
  });

  @override
  State<KakaoMapWidget> createState() => KakaoMapWidgetState();
}

class KakaoMapWidgetState extends State<KakaoMapWidget> {
  late final String _viewId;
  html.IFrameElement? _iframe;

  @override
  void initState() {
    super.initState();
    _viewId = 'naver-map-${DateTime.now().millisecondsSinceEpoch}';
    _init();
  }

  Future<void> _init() async {
    final htmlContent = await rootBundle.loadString('assets/map/naver_map.html');

    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);

    _iframe = html.IFrameElement()
      ..src = url
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..allow = 'geolocation';

    html.window.onMessage.listen((e) {
      final data = e.data;
      if (data is Map && data['type'] == 'ready') {
        _send({'type': 'init', 'lat': widget.lat, 'lng': widget.lng, 'zoom': widget.level});
      }
    });

    ui.platformViewRegistry.registerViewFactory(
      _viewId,
      (int id) => _iframe!,
    );

    if (mounted) setState(() {});
  }

  void _send(Map<String, dynamic> data) {
    _iframe?.contentWindow?.postMessage(data, '*');
  }

  void updatePosition(double lat, double lng) {
    _send({'type': 'updatePosition', 'lat': lat, 'lng': lng});
  }

  void clearPath() {
    _send({'type': 'clearPath'});
  }

  @override
  Widget build(BuildContext context) {
    if (_iframe == null) {
      return const ColoredBox(color: Color(0xFFF0EBE0));
    }
    return HtmlElementView(viewType: _viewId);
  }
}
