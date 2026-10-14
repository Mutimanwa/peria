import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/services/local_notification_service.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _setNotificationsAllowed(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    if (enabled) {
      final permissionGranted =
          await LocalNotificationService.instance.requestPermission();
      if (!permissionGranted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).notificationPermissionDenied,
            ),
          ),
        );
        return;
      }
    }

    await ref.read(appSettingsProvider.notifier).patch(
          (current) => current.copyWith(allowNotifications: enabled),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settingsState = ref.watch(appSettingsProvider);
    return SimplePage(
      title: l10n.notifications,
      child: settingsState.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleGroup(items: [
              ToggleItemData(
                l10n.allowNotifications,
                settings.allowNotifications,
                (value) => _setNotificationsAllowed(context, ref, value),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.notificationPrivacyDescription,
                    style: AppText.caption.copyWith(
                      color: AppColors.grey600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.notificationScheduleDescription,
                    style: AppText.caption.copyWith(
                      color: AppColors.grey600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SectionLabel(l10n.cyclePredictions),
            ToggleGroup(items: [
              ToggleItemData(
                l10n.periodStarting,
                settings.notifyPeriodStarting,
                (value) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPeriodStarting: value),
                    ),
              ),
              ToggleItemData(
                l10n.fertileWindow,
                settings.notifyFertileWindow,
                (value) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyFertileWindow: value),
                    ),
              ),
              ToggleItemData(
                l10n.ovulationDay,
                settings.notifyOvulationDay,
                (value) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyOvulationDay: value),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            SectionLabel(l10n.reminders),
            ToggleGroup(items: [
              ToggleItemData(
                l10n.symptomJournalReminder,
                settings.remindLogSymptoms,
                (value) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(remindLogSymptoms: value),
                    ),
              ),
              ToggleItemData(
                l10n.partnerUpdates,
                settings.notifyPartnerUpdates,
                (value) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPartnerUpdates: value),
                    ),
              ),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unableToLoadNotifications)),
      ),
    );
  }
}
