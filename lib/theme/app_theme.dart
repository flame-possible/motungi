import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildTheme({bool dark = false}) {
  final bg   = dark ? AppColors.paperDark : AppColors.paper;
  final fg   = dark ? AppColors.inkDark   : AppColors.ink;

  return ThemeData(
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme(
      brightness: dark ? Brightness.dark : Brightness.light,
      primary:    AppColors.copper,
      secondary:  AppColors.moss,
      surface:    dark ? AppColors.paperDark : AppColors.paper2,
      error:      Colors.red,
      onPrimary:  Colors.white,
      onSecondary: Colors.white,
      onSurface:  fg,
      onError:    Colors.white,
    ),
    useMaterial3: true,
  );
}
