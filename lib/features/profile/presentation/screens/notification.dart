import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    return SimplePage(
      title: 'Notifications',
      child: settingsState.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleGroup(items: [
              ToggleItemData(
                'Allow Notifications',
                settings.allowNotifications,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(allowNotifications: v),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            const SectionLabel('Cycle Predictions'),
            ToggleGroup(items: [
              ToggleItemData(
                'Period Starting',
                settings.notifyPeriodStarting,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPeriodStarting: v),
                    ),
              ),
              ToggleItemData(
                'Fertile Window',
                settings.notifyFertileWindow,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyFertileWindow: v),
                    ),
              ),
              ToggleItemData(
                'Ovulation Day',
                settings.notifyOvulationDay,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyOvulationDay: v),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            const SectionLabel('Reminders'),
            ToggleGroup(items: [
              ToggleItemData(
                'Log Symptoms',
                settings.remindLogSymptoms,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(remindLogSymptoms: v),
                    ),
              ),
              ToggleItemData(
                'Partner Updates',
                settings.notifyPartnerUpdates,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPartnerUpdates: v),
                    ),
              ),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Unable to load notifications')),
      ),
    );
  }
}
