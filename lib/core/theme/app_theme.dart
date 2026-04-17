import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// Perla App — Theme Configuration
/// Light & Dark modes built from the Style Guide tokens.

class AppTheme {
  AppTheme._();

  // ─── Light Theme ──────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        textTheme: AppTypography.buildTextTheme(isDark: false),
        scaffoldBackgroundColor: AppColors.backgroundLight,

        // AppBar
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.neutral900,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.heading4,
        ),

        // ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonLight,
            foregroundColor: AppColors.neutral50,
            textStyle: AppTypography.buttonMedium,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.br12,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 0,
          ),
        ),

        // OutlinedButton
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            textStyle: AppTypography.buttonMedium,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.br12,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),

        // TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTypography.buttonMedium,
          ),
        ),

        // InputDecoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.neutral100,
          border: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide(color: AppColors.neutral300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide(color: AppColors.error, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle:
              AppTypography.bodyMedium.copyWith(color: AppColors.neutral500),
          labelStyle:
              AppTypography.bodySmall.copyWith(color: AppColors.neutral700),
        ),

        // Card
        cardTheme: const CardTheme(
          color: AppColors.neutral50,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.br16,
            side: BorderSide(color: AppColors.neutral200),
          ),
          margin: EdgeInsets.zero,
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: AppColors.neutral200,
          thickness: 1,
          space: 0,
        ),

        // BottomNavigationBar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.neutral500,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),

        // Chip
        chipTheme: const ChipThemeData(
          backgroundColor: AppColors.neutral100,
          selectedColor: AppColors.primary100,
          labelStyle: AppTypography.captionMedium,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.brRounded,
          ),
          side: BorderSide.none,
        ),

        // SnackBar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.neutral900,
          contentTextStyle:
              AppTypography.bodySmall.copyWith(color: AppColors.neutral50),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.br12),
          behavior: SnackBarBehavior.floating,
        ),
      );

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        textTheme: AppTypography.buildTextTheme(isDark: true),
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.neutral50,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppTypography.heading4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.buttonDark,
            foregroundColor: AppColors.neutral900,
            textStyle: AppTypography.buttonMedium,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.br12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary300,
            side: const BorderSide(color: AppColors.primary300, width: 1.5),
            textStyle: AppTypography.buttonMedium,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.br12),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary300,
            textStyle: AppTypography.buttonMedium,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.neutral900,
          border: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide(color: AppColors.neutral700),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide(color: AppColors.primary400, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: AppRadius.br12,
            borderSide: BorderSide(color: AppColors.error, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle:
              AppTypography.bodyMedium.copyWith(color: AppColors.neutral600),
          labelStyle:
              AppTypography.bodySmall.copyWith(color: AppColors.neutral400),
        ),
        cardTheme: const CardTheme(
          color: AppColors.neutral900,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.br16,
            side: BorderSide(color: AppColors.neutral800),
          ),
          margin: EdgeInsets.zero,
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.neutral800,
          thickness: 1,
          space: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundDark,
          selectedItemColor: AppColors.primary400,
          unselectedItemColor: AppColors.neutral600,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: AppColors.neutral800,
          selectedColor: AppColors.primary800,
          labelStyle: AppTypography.captionMedium,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.brRounded),
          side: BorderSide.none,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.neutral100,
          contentTextStyle:
              AppTypography.bodySmall.copyWith(color: AppColors.neutral900),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.br12),
          behavior: SnackBarBehavior.floating,
        ),
      );

  // ─── Color Schemes ────────────────────────────────────────────────────────
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.neutral50,
    primaryContainer: AppColors.primary100,
    onPrimaryContainer: AppColors.primary800,
    secondary: AppColors.secondary,
    onSecondary: AppColors.neutral50,
    secondaryContainer: AppColors.secondary100,
    onSecondaryContainer: AppColors.secondary800,
    error: AppColors.error,
    onError: AppColors.neutral50,
    errorContainer: AppColors.error50,
    onErrorContainer: AppColors.error700,
    surface: AppColors.neutral50,
    onSurface: AppColors.neutral900,
    surfaceContainerHighest: AppColors.neutral200,
    outline: AppColors.neutral300,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary400,
    onPrimary: AppColors.neutral950,
    primaryContainer: AppColors.primary800,
    onPrimaryContainer: AppColors.primary100,
    secondary: AppColors.secondary400,
    onSecondary: AppColors.neutral950,
    secondaryContainer: AppColors.secondary800,
    onSecondaryContainer: AppColors.secondary100,
    error: AppColors.error200,
    onError: AppColors.neutral950,
    errorContainer: AppColors.error700,
    onErrorContainer: AppColors.error50,
    surface: AppColors.neutral950,
    onSurface: AppColors.neutral50,
    surfaceContainerHighest: AppColors.neutral800,
    outline: AppColors.neutral700,
  );
}
