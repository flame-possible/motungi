import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Current theme token set.
class AppThemeTokens {
  final Color paper, paper2, paper3;
  final Color ink, ink2, ink3;
  final Color rule, ruleSoft;
  final Color copper, copperD, copperL;
  final Color moss, mossL;
  final Color slate, slateL;
  final Color bg;
  final bool isDark;

  const AppThemeTokens({
    required this.paper,  required this.paper2,   required this.paper3,
    required this.ink,    required this.ink2,     required this.ink3,
    required this.rule,   required this.ruleSoft,
    required this.copper, required this.copperD,  required this.copperL,
    required this.moss,   required this.mossL,
    required this.slate,  required this.slateL,
    required this.bg,     required this.isDark,
  });
}

const kLightTokens = AppThemeTokens(
  paper:    TLight.paper,    paper2:   TLight.paper2,   paper3:   TLight.paper3,
  ink:      TLight.ink,      ink2:     TLight.ink2,     ink3:     TLight.ink3,
  rule:     TLight.rule,     ruleSoft: TLight.ruleSoft,
  copper:   TLight.copper,   copperD:  TLight.copperD,  copperL:  TLight.copperL,
  moss:     TLight.moss,     mossL:    TLight.mossL,
  slate:    TLight.slate,    slateL:   TLight.slateL,
  bg:       TLight.bg,       isDark:   false,
);

const kDarkTokens = AppThemeTokens(
  paper:    TDark.paper,    paper2:   TDark.paper2,   paper3:   TDark.paper3,
  ink:      TDark.ink,      ink2:     TDark.ink2,     ink3:     TDark.ink3,
  rule:     TDark.rule,     ruleSoft: TDark.ruleSoft,
  copper:   TDark.copper,   copperD:  TDark.copperD,  copperL:  TDark.copperL,
  moss:     TDark.moss,     mossL:    TDark.mossL,
  slate:    TDark.slate,    slateL:   TDark.slateL,
  bg:       TDark.bg,       isDark:   true,
);

// Illustration always uses light tokens (TILLUST = TLIGHT per index.html)
const kIllustTokens = kLightTokens;

/// Global notifier — update this when the user switches theme.
final themeTokensNotifier = ValueNotifier<AppThemeTokens>(kLightTokens);

/// Convenience getter — use as `T.paper`, `T.ink`, etc. in widgets.
AppThemeTokens get T => themeTokensNotifier.value;
