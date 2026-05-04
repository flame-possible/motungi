import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildTheme({bool dark = false}) {
  final bg  = dark ? TDark.paper  : TLight.paper;
  final fg  = dark ? TDark.ink    : TLight.ink;
  final cop = dark ? TDark.copper : TLight.copper;
  final mos = dark ? TDark.moss   : TLight.moss;

  return ThemeData(
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme(
      brightness:  dark ? Brightness.dark : Brightness.light,
      primary:     cop,
      secondary:   mos,
      surface:     dark ? TDark.paper2 : TLight.paper2,
      error:       Colors.red,
      onPrimary:   Colors.white,
      onSecondary: Colors.white,
      onSurface:   fg,
      onError:     Colors.white,
    ),
    useMaterial3: true,
  );
}
