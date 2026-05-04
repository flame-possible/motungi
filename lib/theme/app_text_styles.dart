import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle headline(Color color) => GoogleFonts.gowunBatang(
    fontSize: 22, fontWeight: FontWeight.w700, color: color, height: 1.35,
  );

  static TextStyle cardTitle(Color color) => GoogleFonts.gowunBatang(
    fontSize: 17, fontWeight: FontWeight.w700, color: color, height: 1.4,
  );

  static TextStyle body(Color color) => GoogleFonts.gowunDodum(
    fontSize: 14, color: color, height: 1.6,
  );

  static TextStyle label(Color color) => GoogleFonts.gowunDodum(
    fontSize: 11, color: color.withValues(alpha: 0.65),
    letterSpacing: 0.04,
  );

  static TextStyle questText(Color color) => GoogleFonts.gowunDodum(
    fontSize: 13, color: color, height: 1.5,
  );
}
