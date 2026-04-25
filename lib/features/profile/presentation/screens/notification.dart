import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

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
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(allowNotifications: v),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            SectionLabel(l10n.cyclePredictions),
            ToggleGroup(items: [
              ToggleItemData(
                l10n.periodStarting,
                settings.notifyPeriodStarting,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPeriodStarting: v),
                    ),
              ),
              ToggleItemData(
                l10n.fertileWindow,
                settings.notifyFertileWindow,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyFertileWindow: v),
                    ),
              ),
              ToggleItemData(
                l10n.ovulationDay,
                settings.notifyOvulationDay,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyOvulationDay: v),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            SectionLabel(l10n.reminders),
            ToggleGroup(items: [
              ToggleItemData(
                l10n.logSymptoms,
                settings.remindLogSymptoms,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(remindLogSymptoms: v),
                    ),
              ),
              ToggleItemData(
                l10n.partnerUpdates,
                settings.notifyPartnerUpdates,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPartnerUpdates: v),
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
