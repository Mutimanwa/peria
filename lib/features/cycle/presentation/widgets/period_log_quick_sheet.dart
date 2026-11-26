import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/period_log_quick_actions.dart';
import 'package:peria_app/features/cycle/domain/period_rules.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/cycle/presentation/widgets/mini_month_calendar.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/pill_button.dart';

enum _QuickPeriodLogAction { startToday, addToday, endToday }

/// Feuille « Enregistrer tes règles », partagée par l'accueil du cycle et le
/// calendrier.
///
/// Les trois actions passent par [PeriodLogQuickActions] : aucune ne peut
/// étirer une période de plus de [PeriodRules.maxPeriodLengthDays] jours ni
/// toucher à un enregistrement qui ne concerne pas aujourd'hui ou hier.
class PeriodLogQuickSheet extends ConsumerStatefulWidget {
  const PeriodLogQuickSheet({super.key, required this.onOpenStructuredEdit});

  final VoidCallback onOpenStructuredEdit;

  @override
  ConsumerState<PeriodLogQuickSheet> createState() =>
      _PeriodLogQuickSheetState();
}

class _PeriodLogQuickSheetState extends ConsumerState<PeriodLogQuickSheet> {
  bool _isSaving = false;
  String? _feedback;

  String _noChangeMessage(
    _QuickPeriodLogAction action,
    List<PeriodLog> logs,
    DateTime today,
  ) {
    final l10n = AppLocalizations.of(context);
    if (action == _QuickPeriodLogAction.endToday) {
      final tooLong = logs.any((log) =>
          !log.isEstimated &&
          !PeriodRules.dayOnly(log.endDate)
              .isBefore(PeriodRules.addDays(today, -1)) &&
          PeriodRules.spanDays(log.startDate, today) >
              PeriodRules.maxPeriodLengthDays);
      return tooLong ? l10n.periodLogTooLong : l10n.periodLogNoRecentToEnd;
    }
    return l10n.periodLogAlreadyLoggedToday;
  }

  Future<void> _submit(
    _QuickPeriodLogAction action,
    List<PeriodLog> logs,
  ) async {
    if (_isSaving) return;

    final now = DateTime.now();
    final today = PeriodRules.dayOnly(now);
    final periodLog = switch (action) {
      _QuickPeriodLogAction.startToday =>
        PeriodLogQuickActions.startToday(logs: logs, today: today),
      _QuickPeriodLogAction.addToday =>
        PeriodLogQuickActions.recordToday(logs: logs, today: today),
      _QuickPeriodLogAction.endToday =>
        PeriodLogQuickActions.endToday(logs: logs, today: today),
    };

    if (periodLog == null) {
      setState(() => _feedback = _noChangeMessage(action, logs, today));
      return;
    }

    final periodLogsNotifier = ref.read(periodLogsProvider.notifier);
    setState(() {
      _isSaving = true;
      _feedback = null;
    });

    try {
      await periodLogsNotifier.add(periodLog);
      if (!mounted) return;

      // Period logs are the cycle engine's source of truth. Keep the profile's
      // legacy fallback anchor aligned when it is already available.
      final savedLogs =
          ref.read(periodLogsProvider).value ?? const <PeriodLog>[];
      final periodContainingToday = savedLogs
          .where((log) => log.contains(today) && !log.isEstimated)
          .toList()
        ..sort((a, b) => b.startDate.compareTo(a.startDate));
      final profile = ref.read(userProfileProvider).value;
      if (periodContainingToday.isNotEmpty && profile != null) {
        final loggedStart = periodContainingToday.first.startDate;
        final currentStart = profile.lastPeriodStart;
        if (currentStart == null || loggedStart.isAfter(currentStart)) {
          try {
            await ref.read(userProfileProvider.notifier).patch(
                  (current) => current.copyWith(lastPeriodStart: loggedStart),
                );
          } catch (_) {
            // The saved period log remains canonical if this legacy fallback
            // profile field cannot be refreshed.
          }
        }
      }

      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // `add` updates the provider optimistically. Reload its canonical value
      // after a failed write so a retry cannot mistake an unsaved entry for a
      // successfully recorded period.
      try {
        await periodLogsNotifier.load();
      } catch (_) {
        // Keep the original save error visible if refreshing also fails.
      }
      if (mounted) {
        final reloadedLogs =
            ref.read(periodLogsProvider).value ?? const <PeriodLog>[];
        final wasSaved = reloadedLogs.any(
          (log) => log.contains(today) && !log.isEstimated,
        );
        if (wasSaved) {
          Navigator.of(context).pop();
        } else {
          setState(() =>
              _feedback = AppLocalizations.of(context).periodLogSaveError);
        }
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final logsState = ref.watch(periodLogsProvider);
    final canSave = logsState.hasValue &&
        !logsState.isLoading &&
        !logsState.hasError &&
        !_isSaving;
    final logs = logsState.value ?? const <PeriodLog>[];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(l10n.logPeriodSheetTitle, style: AppText.h4),
                const SizedBox(height: 6),
                Text(
                  l10n.logPeriodSheetSubtitle,
                  style: AppText.body.copyWith(color: AppColors.grey600),
                ),
                const SizedBox(height: 16),
                // Le mois sous les yeux : jours déjà enregistrés (pleins) et
                // jours prévus (contour), pour situer l'action avant de la
                // choisir. Le calendrier ne modifie rien lui-même.
                const MiniMonthCalendar(),
                if (logsState.isLoading || _isSaving) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _isSaving
                            ? l10n.periodLogSaving
                            : l10n.periodLogLoading,
                        style: AppText.caption.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
                if (logsState.hasError) ...[
                  const SizedBox(height: 14),
                  Text(
                    l10n.periodLogLoadError,
                    style: AppText.caption.copyWith(color: AppColors.error),
                  ),
                ],
                if (_feedback != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    _feedback!,
                    style: AppText.caption.copyWith(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: 18),
                _QuickActionTile(
                  icon: Icons.play_arrow_rounded,
                  title: l10n.periodStartedToday,
                  subtitle: l10n.periodStartedTodaySubtitle,
                  color: AppColors.primary400,
                  enabled: canSave,
                  onTap: () => _submit(_QuickPeriodLogAction.startToday, logs),
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.water_drop_outlined,
                  title: l10n.addTodayPeriodDay,
                  subtitle: l10n.addTodayPeriodDaySubtitle,
                  color: AppColors.primary500,
                  enabled: canSave,
                  onTap: () => _submit(_QuickPeriodLogAction.addToday, logs),
                ),
                const SizedBox(height: 12),
                _QuickActionTile(
                  icon: Icons.stop_rounded,
                  title: l10n.periodEndedToday,
                  subtitle: l10n.periodEndedTodaySubtitle,
                  color: AppColors.warning700,
                  enabled: canSave,
                  onTap: () => _submit(_QuickPeriodLogAction.endToday, logs),
                ),
                const SizedBox(height: 16),
                PillButton(
                  label: l10n.openStructuredPeriodEdit,
                  filled: false,
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onOpenStructuredEdit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final actionColor = enabled ? color : AppColors.grey400;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: actionColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: actionColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: enabled ? AppColors.grey900 : AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppText.caption.copyWith(
                      color: enabled ? AppColors.grey600 : AppColors.grey400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: enabled ? AppColors.grey500 : AppColors.grey300,
            ),
          ],
        ),
      ),
    );
  }
}
