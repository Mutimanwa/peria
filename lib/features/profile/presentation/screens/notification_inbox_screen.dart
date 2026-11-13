import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_spacing.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class NotificationInboxScreen extends ConsumerWidget {
  const NotificationInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(appSettingsProvider);
    final cycleStatus = ref.watch(cycleStatusProvider);

    return PageScaffold(
      title: l10n.notifications,
      onBack: () => safeRouterBack(context, fallbackRoute: '/cycle'),
      actions: [
        IconButton(
          tooltip: l10n.notificationSettings,
          onPressed: () => context.push('/profile/notifications'),
          icon: const Icon(Icons.settings_outlined, color: AppColors.grey800),
        ),
      ],
      child: settings.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unableToLoadNotifications)),
        data: (value) {
          final planned = NotificationSchedulePlanner.createPlan(
            settings: value,
            cycleStatus: cycleStatus,
          );
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              76,
              AppSpacing.page,
              32,
            ),
            children: [
              Text(
                l10n.notificationInboxSubtitle,
                style: AppText.body.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              if (!value.allowNotifications || planned.isEmpty)
                _EmptyNotifications(
                  message: l10n.notificationInboxEmpty,
                  actionLabel: l10n.notificationSettings,
                  onOpenSettings: () => context.push('/profile/notifications'),
                )
              else
                ...planned.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NotificationCard(item: item),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications({
    required this.message,
    required this.actionLabel,
    required this.onOpenSettings,
  });

  final String message;
  final String actionLabel;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          const Icon(Icons.notifications_none_rounded, color: AppColors.grey500),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center, style: AppText.body),
          const SizedBox(height: 16),
          PrimaryButton(label: actionLabel, onPressed: onOpenSettings),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item});

  final PlannedLocalNotification item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final when = DateFormat.yMMMd(locale).add_Hm().format(item.scheduledAt);
    final (icon, title) = switch (item.kind) {
      LocalReminderKind.period => (
          Icons.water_drop_outlined,
          l10n.periodStarting,
        ),
      LocalReminderKind.fertileWindow => (
          Icons.auto_awesome_outlined,
          l10n.fertileWindow,
        ),
      LocalReminderKind.ovulation => (
          Icons.brightness_5_outlined,
          l10n.ovulationDay,
        ),
      LocalReminderKind.dailyCheckIn => (
          Icons.edit_note_rounded,
          l10n.symptomJournalReminder,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.label),
                const SizedBox(height: 4),
                Text(
                  when,
                  style: AppText.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
