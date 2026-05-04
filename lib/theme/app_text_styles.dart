import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Ts — primary text style helper ─────────────────────────────────────────
// Gowun Batang = serif (headlines)
// Gowun Dodum  = sans / body

class Ts {
  static TextStyle serif(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
    GoogleFonts.gowunBatang(
        fontSize: size, fontWeight: weight, color: color,
        height: height, letterSpacing: letterSpacing);

  static TextStyle sans(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
    GoogleFonts.gowunDodum(
        fontSize: size, fontWeight: weight, color: color,
        height: height, letterSpacing: letterSpacing);
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
