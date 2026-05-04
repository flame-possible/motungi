import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motungi/theme/app_colors.dart';

void main() {
  test('light mode colors match index.html tokens', () {
    expect(AppColors.paper.value,   0xFFE5DBC4);
    expect(AppColors.paper2.value,  0xFFD9CEAF);
    expect(AppColors.ink.value,     0xFF2D3A33);
    expect(AppColors.copper.value,  0xFFA85A2A);
    expect(AppColors.moss.value,    0xFF6B7F5E);
    expect(AppColors.slate.value,   0xFF4A6573);
    expect(AppColors.border.value,  0xFFBBB09A);
  });

  test('dark mode colors match index.html tokens', () {
    expect(AppColors.paperDark.value, 0xFF1B2520);
    expect(AppColors.inkDark.value,   0xFFECE3CC);
  });
}
