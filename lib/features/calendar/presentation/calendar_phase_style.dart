import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/features/cycle/domain/cycle_phase.dart';

/// Visual identity for one cycle phase on the calendar.
///
/// Every phase has its own fill, text color, and accent so a month can show
/// menstrual, follicular, ovulation, and luteal days at the same time.
class CalendarPhaseStyle {
  const CalendarPhaseStyle({
    required this.background,
    required this.foreground,
    required this.accent,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final Color accent;
  final IconData icon;

  static CalendarPhaseStyle of(CyclePhase phase) {
    switch (phase) {
      case CyclePhase.menstrual:
        return const CalendarPhaseStyle(
          background: AppColors.primary100,
          foreground: AppColors.primary700,
          accent: AppColors.primary400,
          icon: Icons.water_drop_rounded,
        );
      case CyclePhase.follicular:
        return const CalendarPhaseStyle(
          background: AppColors.secondary100,
          foreground: AppColors.secondary800,
          accent: AppColors.secondary500,
          icon: Icons.spa_outlined,
        );
      case CyclePhase.ovulation:
        return const CalendarPhaseStyle(
          background: AppColors.secondary300,
          foreground: AppColors.secondary900,
          accent: AppColors.secondary700,
          icon: Icons.auto_awesome_rounded,
        );
      case CyclePhase.luteal:
        return const CalendarPhaseStyle(
          background: AppColors.warning50,
          foreground: AppColors.warning700,
          accent: AppColors.warning700,
          icon: Icons.nights_stay_outlined,
        );
    }
  }
}
