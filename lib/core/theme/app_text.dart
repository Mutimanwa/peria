import 'package:flutter/material.dart';
import 'app_typography.dart';

class AppText {
  AppText._();

  static const TextStyle h1 = AppTypography.heading1;
  static const TextStyle h2 = AppTypography.heading2;
  static const TextStyle h3 = AppTypography.heading3;
  static const TextStyle h4 = AppTypography.heading4;
  static const TextStyle h5 = AppTypography.heading5;
  static const TextStyle h6 = AppTypography.heading6;

  static const TextStyle body = AppTypography.bodyMedium;
  static const TextStyle label = AppTypography.buttonMedium;
  static const TextStyle caption = AppTypography.captionMedium;

  static const TextStyle btnPrimary = AppTypography.buttonLarge;
  static const TextStyle btnOutline = AppTypography.buttonLarge;

  // ─── Cycle Dashboard ──────────────────────────────────────────────────────
  static const TextStyle cyclePhase = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Color(0xFF292929),
  );

  static const TextStyle cycleDays = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}
