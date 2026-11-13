import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/contrast.dart';

void main() {
  test('the scale is anchored on black and white', () {
    expect(contrastRatio(Colors.black, Colors.white), closeTo(21, 0.01));
    expect(contrastRatio(Colors.white, Colors.white), closeTo(1, 0.01));
  });

  test('contrast is symmetric', () {
    expect(
      contrastRatio(AppColors.textSecondary, Colors.white),
      closeTo(contrastRatio(Colors.white, AppColors.textSecondary), 0.001),
    );
  });

  test('text tokens meet WCAG AA on white', () {
    expect(
      contrastRatio(AppColors.textSecondary, AppColors.white),
      greaterThanOrEqualTo(wcagAaNormalText),
    );
    expect(
      contrastRatio(AppColors.textError, AppColors.white),
      greaterThanOrEqualTo(wcagAaNormalText),
    );
    expect(
      contrastRatio(AppColors.textSuccess, AppColors.white),
      greaterThanOrEqualTo(wcagAaNormalText),
    );
    expect(
      contrastRatio(AppColors.neutral900, AppColors.white),
      greaterThanOrEqualTo(wcagAaNormalText),
    );
  });

  test('the neutral aliases are not legible enough for body text', () {
    // Documented on purpose: grey400/grey500 must never carry text.
    expect(
      contrastRatio(AppColors.grey400, AppColors.white),
      lessThan(wcagAaLargeText),
    );
    expect(
      contrastRatio(AppColors.grey500, AppColors.white),
      lessThan(wcagAaNormalText),
    );
  });
}
