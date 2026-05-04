import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/theme/app_colors.dart';

void main() {
  test('light mode colors match index.html tokens', () {
    expect(TLight.paper.toARGB32(),    0xFFF0E6D0);
    expect(TLight.paper2.toARGB32(),   0xFFFDFAF1);
    expect(TLight.ink.toARGB32(),      0xFF2D3A33);
    expect(TLight.copper.toARGB32(),   0xFFA85A2A);
    expect(TLight.moss.toARGB32(),     0xFF6B7F5E);
    expect(TLight.slate.toARGB32(),    0xFF4A6573);
    expect(TLight.rule.toARGB32(),     0xFFCFC2A8);
  });

  test('dark mode colors match index.html tokens', () {
    expect(TDark.paper.toARGB32(),  0xFF1B2520);
    expect(TDark.ink.toARGB32(),    0xFFECE3CC);
  });
}
