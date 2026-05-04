import 'package:flutter/material.dart';

// ── Ts — primary text style helper ─────────────────────────────────────────
// GowunBatang = serif (headlines)
// GowunDodum  = sans / body
// Both are bundled as local assets (assets/fonts/) to avoid runtime network fetching.

class Ts {
  static TextStyle serif(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
    TextStyle(
      fontFamily: 'GowunBatang',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );

  static TextStyle sans(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
    TextStyle(
      fontFamily: 'GowunDodum',
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
}

// ── Legacy aliases (kept for compatibility) ────────────────────────────────
class Serif {
  static TextStyle s(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
    Ts.serif(size, weight, color, height: height, letterSpacing: letterSpacing);
}

class Sans {
  static TextStyle s(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
    Ts.sans(size, weight, color, height: height, letterSpacing: letterSpacing);
}

// ── AppTextStyles — compatibility shim for existing screens ───────────────
class AppTextStyles {
  static TextStyle headline(Color color) =>
    Ts.serif(22, FontWeight.w600, color, height: 1.3);

  static TextStyle body(Color color) =>
    Ts.sans(15, FontWeight.w400, color, height: 1.5);

  static TextStyle label(Color color) =>
    Ts.sans(12, FontWeight.w400, color, height: 1.4);

  static TextStyle cardTitle(Color color) =>
    Ts.serif(16, FontWeight.w600, color, height: 1.3);

  static TextStyle questText(Color color) =>
    Ts.sans(14, FontWeight.w400, color, height: 1.5);
}
