import 'package:flutter/material.dart';

/// Perla App — Spacing, Padding & Radius
/// Generated from Style Guide

class AppSpacing {
  AppSpacing._();

  // ─── Spacing Scale ────────────────────────────────────────────────────────
  static const double s1 = 8.0;
  static const double s2 = 16.0;
  static const double s3 = 24.0;
  static const double s4 = 32.0;
  static const double s5 = 40.0;
  static const double s6 = 56.0;
  static const double s7 = 72.0;
  static const double s8 = 80.0;
  static const double s9 = 96.0;
  static const double s10 = 120.0;

  // Semantic aliases
  static const double xs = s1; //  8px
  static const double sm = s2; // 16px
  static const double md = s3; // 24px
  static const double lg = s4; // 32px
  static const double xl = s5; // 40px
  static const double xxl = s6; // 56px
  static const double xxxl = s7; // 72px
}

class AppPadding {
  AppPadding._();

  // ─── Padding Scale ────────────────────────────────────────────────────────
  static const EdgeInsets p4 = EdgeInsets.all(4);
  static const EdgeInsets p8 = EdgeInsets.all(8);
  static const EdgeInsets p16 = EdgeInsets.all(16);
  static const EdgeInsets p24 = EdgeInsets.all(24);
  static const EdgeInsets p32 = EdgeInsets.all(32);
  static const EdgeInsets p40 = EdgeInsets.all(40);

  // Horizontal only
  static const EdgeInsets hP16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets hP24 = EdgeInsets.symmetric(horizontal: 24);

  // Vertical only
  static const EdgeInsets vP8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets vP16 = EdgeInsets.symmetric(vertical: 16);

  // Grid margin (from style guide: margin = 24, gutter = 12)
  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: 24);
}

class AppRadius {
  AppRadius._();

  // ─── Corner Radius Scale ─────────────────────────────────────────────────
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;
  static const double rounded = 999.0; // Pill / fully rounded

  // BorderRadius helpers
  static const BorderRadius br4 = BorderRadius.all(Radius.circular(r4));
  static const BorderRadius br8 = BorderRadius.all(Radius.circular(r8));
  static const BorderRadius br12 = BorderRadius.all(Radius.circular(r12));
  static const BorderRadius br16 = BorderRadius.all(Radius.circular(r16));
  static const BorderRadius br24 = BorderRadius.all(Radius.circular(r24));
  static const BorderRadius br32 = BorderRadius.all(Radius.circular(r32));
  static const BorderRadius brRounded =
      BorderRadius.all(Radius.circular(rounded));
}
