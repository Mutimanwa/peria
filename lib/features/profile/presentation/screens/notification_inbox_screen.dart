import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_inbox_provider.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_spacing.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/cycle/presentation/providers/cycle_provider.dart';
import 'package:peria_app/features/profile/presentation/widgets/notification_card.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// The reminder feed: what Peria already told the user on this device.
class NotificationInboxScreen extends ConsumerStatefulWidget {
  const NotificationInboxScreen({super.key});

  @override
  ConsumerState<NotificationInboxScreen> createState() =>
      _NotificationInboxScreenState();
}

class _NotificationInboxScreenState
    extends ConsumerState<NotificationInboxScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _catchUp();
    });
  }

  /// Adds the reminders that became due while the app stayed open, so opening
  /// the screen never shows an outdated list.
  Future<void> _catchUp() async {
    final settings = ref.read(appSettingsProvider).value;
    if (settings == null) return;
    final plan = settings.allowNotifications
        ? NotificationSchedulePlanner.createPlan(
            settings: settings,
            cycleStatus: ref.read(cycleStatusProvider),
          )
        : const <PlannedLocalNotification>[];
    await ref.read(notificationInboxProvider.notifier).sync(plan);
  }

  Future<void> _open(AppNotification notification) async {
    await ref.read(notificationInboxProvider.notifier).markRead(notification.id);
    if (!mounted) return;

    final route = notification.route;
    // Cycle reminders land on the tab the inbox was opened from.
    if (route == '/cycle') {
      safeRouterBack(context, fallbackRoute: '/cycle');
      return;
    }
    context.push(route);
  }

  Future<void> _delete(AppNotification notification) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final notifier = ref.read(notificationInboxProvider.notifier);

    await notifier.delete(notification.id);
    if (!mounted) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.notificationDeleted),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: l10n.cancel,
            onPressed: () => notifier.restore(notification),
          ),
        ),
      );
  }

  Future<void> _clearAll() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.notificationClearAllTitle),
        content: Text(l10n.notificationClearAllBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.notificationClearAll,
              style: const TextStyle(color: AppColors.error700),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await ref.read(notificationInboxProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = ref.watch(notificationInboxProvider);
    final hasUnread = items.any((item) => !item.read);

    return PageScaffold(
      title: l10n.notifications,
      onBack: () => safeRouterBack(context, fallbackRoute: '/cycle'),
      actions: [
        IconButton(
          tooltip: l10n.notificationSettings,
          onPressed: () => context.push('/profile/notifications'),
          icon: const Icon(Icons.tune_rounded, color: AppColors.grey800),
        ),
      ],
      child: ListView(
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
          if (items.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l10n.notificationInboxHint,
              style: AppText.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: [
                if (hasUnread)
                  _InboxTextAction(
                    icon: Icons.done_all_rounded,
                    label: l10n.notificationMarkAllRead,
                    onPressed: () =>
                        ref.read(notificationInboxProvider.notifier).markAllRead(),
                  ),
                _InboxTextAction(
                  icon: Icons.delete_outline_rounded,
                  label: l10n.notificationClearAll,
                  color: AppColors.error700,
                  onPressed: _clearAll,
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          if (items.isEmpty)
            _EmptyNotifications(
              message: l10n.notificationInboxEmpty,
              actionLabel: l10n.notificationSettings,
              onOpenSettings: () => context.push('/profile/notifications'),
            )
          else
            ..._buildGroups(items),
        ],
      ),
    );
  }

  List<Widget> _buildGroups(List<AppNotification> items) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    final sections = <NotificationPeriod, List<AppNotification>>{
      NotificationPeriod.today: [],
      NotificationPeriod.yesterday: [],
      NotificationPeriod.earlier: [],
    };
    for (final item in items) {
      sections[AppNotification.periodFor(item.scheduledAt, now)]!.add(item);
    }
    final todayItems = sections[NotificationPeriod.today]!;

    Widget buildSection(String label, List<AppNotification> section) {
      if (section.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10),
              child: Text(
                label.toUpperCase(),
                style: AppText.caption.copyWith(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            for (final item in section)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildCard(item, isToday: todayItems.contains(item)),
              ),
          ],
        ),
      );
    }

    return [
      buildSection(l10n.notificationToday, sections[NotificationPeriod.today]!),
      buildSection(
        l10n.notificationYesterday,
        sections[NotificationPeriod.yesterday]!,
      ),
      buildSection(
        l10n.notificationEarlier,
        sections[NotificationPeriod.earlier]!,
      ),
    ];
  }

  Widget _buildCard(AppNotification item, {required bool isToday}) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final texts = _textsFor(item.kind, l10n);
    final timeLabel = isToday
        ? DateFormat.Hm(locale).format(item.scheduledAt)
        : DateFormat.MMMd(locale).format(item.scheduledAt);

    return NotificationCard(
      notification: item,
      title: texts.$1,
      body: texts.$2,
      timeLabel: timeLabel,
      deleteLabel: l10n.delete,
      onDelete: () => _delete(item),
      onTap: () => _open(item),
    );
  }

  (String, String) _textsFor(LocalReminderKind kind, AppLocalizations l10n) {
    switch (kind) {
      case LocalReminderKind.period:
        return (l10n.periodStarting, l10n.notificationPeriodBody);
      case LocalReminderKind.fertileWindow:
        return (l10n.fertileWindow, l10n.notificationFertileBody);
      case LocalReminderKind.ovulation:
        return (l10n.ovulationDay, l10n.notificationOvulationBody);
      case LocalReminderKind.dailyCheckIn:
        return (l10n.symptomJournalReminder, l10n.notificationCheckInBody);
    }
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary500,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.label.copyWith(color: AppColors.grey800),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).notificationInboxSubtitle,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: actionLabel,
            onPressed: onOpenSettings,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}

class _InboxTextAction extends StatelessWidget {
  const _InboxTextAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.grey800,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: AppText.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: color,
      ),
    );
  }
}
