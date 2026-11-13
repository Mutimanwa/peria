import 'dart:math' as math;

import 'package:flutter/material.dart';

/// WCAG 2.1 minimum contrast for normal-sized text.
const double wcagAaNormalText = 4.5;

/// WCAG 2.1 minimum contrast for large text and meaningful graphics.
const double wcagAaLargeText = 3.0;

double _channel(double value) {
  return value <= 0.03928
      ? value / 12.92
      : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
}

/// WCAG 2.1 relative luminance of [color] (1.0 = white).
double relativeLuminance(Color color) {
  return 0.2126 * _channel(color.r) +
      0.7152 * _channel(color.g) +
      0.0722 * _channel(color.b);
}

/// Contrast ratio between two opaque colours, from 1:1 to 21:1.
///
/// The theme's text tokens are asserted against [wcagAaNormalText] in
/// `test/core/theme/contrast_test.dart`, so a palette change cannot silently
/// drop the app below WCAG AA again.
double contrastRatio(Color a, Color b) {
  final la = relativeLuminance(a);
  final lb = relativeLuminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}
