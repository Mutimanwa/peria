import 'package:flutter/material.dart';

/// Perla App — Color System
/// Generated from Style Guide

class AppColors {
  AppColors._();

  // ─── Primary Color (Pink/Rose) ───────────────────────────────────────────
  static const Color primary50 = Color(0xFFFFF1F3);
  static const Color primary100 = Color(0xFFFFE4E8);
  static const Color primary200 = Color(0xFFFFCCD5);
  static const Color primary300 = Color(0xFFFEA3B4);
  static const Color primary400 = Color(0xFFFD587A); // Base
  static const Color primary500 = Color(0xFFF73C67);
  static const Color primary600 = Color(0xFFC10F46);
  static const Color primary700 = Color(0xFFA11041);
  static const Color primary800 = Color(0xFF8A113D);
  static const Color primary900 = Color(0xFF4D041C);

  static const Color primary = primary400;

  // ─── Secondary Color (Purple) ────────────────────────────────────────────
  static const Color secondary50 = Color(0xFFFAF6FE);
  static const Color secondary100 = Color(0xFFF3EBFC);
  static const Color secondary200 = Color(0xFFEADBF9);
  static const Color secondary300 = Color(0xFFD9BEF4);
  static const Color secondary400 = Color(0xFFC294EC); // Base
  static const Color secondary500 = Color(0xFFA25DDE);
  static const Color secondary600 = Color(0xFF954CD1);
  static const Color secondary700 = Color(0xFF6B3396);
  static const Color secondary800 = Color(0xFF582B78);
  static const Color secondary900 = Color(0xFF3B1457);

  static const Color secondary = secondary400;

  // ─── Neutral ─────────────────────────────────────────────────────────────
  static const Color neutral50 = Color(0xFFFFFFFF);
  static const Color neutral100 = Color(0xFFF9F9F9);
  static const Color neutral200 = Color(0xFFEFEFEF);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD); // Base
  static const Color neutral500 = Color(0xFF989898);
  static const Color neutral600 = Color(0xFF7C7C7C);
  static const Color neutral700 = Color(0xFF464646);
  static const Color neutral800 = Color(0xFF3D3D3D);
  static const Color neutral900 = Color(0xFF292929);
  static const Color neutral950 = Color(0xFF121212);

  // ─── Background ──────────────────────────────────────────────────────────
  static const Color backgroundLight = neutral50; // #FFFFFF
  static const Color backgroundDark = neutral950; // #121212

  // surface
  static const Color surfaceLight = neutral50;
  static const Color surfaceDark = neutral900;

  // ─── Button Colors ────────────────────────────────────────────────────────
  static const Color buttonLight = Color(0xFF292929); // 900
  static const Color buttonDark = Color(0xFFF9F9F9); // 100

  // ─── Semantic: Success ────────────────────────────────────────────────────
  static const Color success50 = Color(0xFFD1FAE5);
  static const Color success200 = Color(0xFF22C55E); // Base
  static const Color success700 = Color(0xFF15803D);

  static const Color success = success200;

  // ─── Semantic: Warning ────────────────────────────────────────────────────
  static const Color warning50 = Color(0xFFFEF9C3);
  static const Color warning200 = Color(0xFFFACC15); // Base
  static const Color warning700 = Color(0xFFCA8A04);

  static const Color warning = warning200;

  // ─── Semantic: Error ──────────────────────────────────────────────────────
  static const Color error50 = Color(0xFFFFEEEE);
  static const Color error200 = Color(0xFFEF4444); // Base
  static const Color error700 = Color(0xFFB91C1C);

  static const Color error = error200;

  // ─── Semantic: Info ───────────────────────────────────────────────────────
  static const Color info50 = Color(0xFFE0F2FE);
  static const Color info200 = Color(0xFF3B82F6); // Base
  static const Color info700 = Color(0xFF1D4ED8);

  static const Color info = info200;

  // ─── Aliases & Compatibility ──────────────────────────────────────────────
  static const Color white = neutral50;
  static const Color black = neutral950;
  static const Color grey50 = neutral50;
  static const Color grey100 = neutral100;
  static const Color grey200 = neutral200;
  static const Color grey300 = neutral300;
  static const Color grey400 = neutral400;
  static const Color grey500 = neutral500;
  static const Color grey600 = neutral600;
  static const Color grey700 = neutral700;
  static const Color grey800 = neutral800;
  static const Color grey900 = neutral900;

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFF1F3),
      Color(0xFFF3EBFC),
    ],
  );

  // ─── Cycle Phases ──────────────────────────────────────────────────────────
  static const Color periodBase = primary400;
  static const Color periodLight = primary200;
  static const Color pmsBase = warning200;
  static const Color pmsLight = warning50;
  static const Color ovulBase = secondary500;
  static const Color ovulLight = secondary100;

  static const LinearGradient cycleHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF1F3),
      Color(0xFFFFFFFF),
    ],
  );
}
