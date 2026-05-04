import 'package:flutter/material.dart';

// ── TLIGHT ──────────────────────────────────────────────────────────────────
class TLight {
  static const paper    = Color(0xFFF0E6D0);
  static const paper2   = Color(0xFFFDFAF1);
  static const paper3   = Color(0xFFE8DEC8);
  static const ink      = Color(0xFF2D3A33);
  static const ink2     = Color(0xFF4A574F);
  static const ink3     = Color(0xFF6B7269);
  static const rule     = Color(0xFFCFC2A8);
  static const ruleSoft = Color(0xFFE1D6BD);
  static const copper   = Color(0xFFA85A2A);
  static const copperD  = Color(0xFF7E3F1A);
  static const copperL  = Color(0xFFE9C9A8);
  static const moss     = Color(0xFF6B7F5E);
  static const mossL    = Color(0xFFD4DAC8);
  static const slate    = Color(0xFF4A6573);
  static const slateL   = Color(0xFFC8D3DC);
  static const bg       = Color(0xFFE5DBC4);
}

// ── TDARK ──────────────────────────────────────────────────────────────────
class TDark {
  static const paper    = Color(0xFF1B2520);
  static const paper2   = Color(0xFF243029);
  static const paper3   = Color(0xFF2D3B33);
  static const ink      = Color(0xFFECE3CC);
  static const ink2     = Color(0xFFB6AC95);
  static const ink3     = Color(0xFF8B8474);
  static const rule     = Color(0xFF3D4942);
  static const ruleSoft = Color(0xFF2F3B34);
  static const copper   = Color(0xFFD88150);
  static const copperD  = Color(0xFFE59A6A);
  static const copperL  = Color(0xFF4A331F);
  static const moss     = Color(0xFF97AC85);
  static const mossL    = Color(0xFF38453A);
  static const slate    = Color(0xFF92AEC2);
  static const slateL   = Color(0xFF324252);
  static const bg       = Color(0xFF0F1614);
}

// ── TMAST — walk screen always-dark stage, theme-independent ──────────────
class TMast {
  static const bg      = Color(0xFF1B2520);
  static const fg      = Color(0xFFECE3CC);
  static const fgMuted = Color(0xFFECE3CC); // apply withValues(alpha: 0.65) in code
  static const border  = Color(0xFFECE3CC); // apply withValues(alpha: 0.18) in code
}

// ── AppColors — compatibility shim for existing screens ───────────────────
// Uses light-mode values as static defaults. Screens will migrate to T.* over time.
class AppColors {
  static const paper   = TLight.paper;
  static const paper2  = TLight.paper2;
  static const paper3  = TLight.paper3;
  static const ink     = TLight.ink;
  static const ink2    = TLight.ink2;
  static const ink3    = TLight.ink3;
  static const rule    = TLight.rule;
  static const ruleSoft = TLight.ruleSoft;
  static const copper  = TLight.copper;
  static const copperD = TLight.copperD;
  static const copperL = TLight.copperL;
  static const moss    = TLight.moss;
  static const mossL   = TLight.mossL;
  static const slate   = TLight.slate;
  static const slateL  = TLight.slateL;
  static const bg      = TLight.bg;
  // 'border' was used in old screens — maps to rule
  static const border  = TLight.rule;
}
