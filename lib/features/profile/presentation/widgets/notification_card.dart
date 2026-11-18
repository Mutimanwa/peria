import 'package:flutter/material.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';

/// One reminder in the notification feed.
///
/// Unread messages are brighter than read ones, so the list reads like a real
/// feed instead of a flat list of rows.
class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.title,
    required this.body,
    required this.timeLabel,
    this.onTap,
    this.onDelete,
    this.deleteLabel = '',
  });

  final AppNotification notification;
  final String title;
  final String body;
  final String timeLabel;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final String deleteLabel;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    final unread = !notification.read;
    final palette = _paletteFor(notification.kind);

    final card = Material(
      color: AppColors.white,
      elevation: unread ? 2 : 0,
      shadowColor: Colors.black.withAlpha(20),
      borderRadius: _radius,
      child: InkWell(
        onTap: onTap,
        onLongPress: onDelete,
        borderRadius: _radius,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: _radius,
            border: Border.all(
              color: unread ? AppColors.primary100 : AppColors.grey200,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _KindChip(
                  icon: palette.icon,
                  background: palette.background,
                  foreground: palette.foreground,
                  unread: unread,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.label.copyWith(
                                fontWeight:
                                    unread ? FontWeight.w700 : FontWeight.w600,
                                color: AppColors.grey900,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              timeLabel,
                              style: AppText.caption.copyWith(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(
                          height: 1.35,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (onDelete == null) return card;

    return Dismissible(
      key: ValueKey('notification-${notification.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete!(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error700,
          borderRadius: _radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.delete_outline_rounded,
                color: AppColors.white, size: 20),
            if (deleteLabel.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                deleteLabel,
                style: AppText.caption.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
      child: card,
    );
  }

  static ({IconData icon, Color background, Color foreground}) _paletteFor(
    LocalReminderKind kind,
  ) {
    switch (kind) {
      case LocalReminderKind.period:
        return (
          icon: Icons.water_drop_outlined,
          background: AppColors.primary50,
          foreground: AppColors.primary600,
        );
      case LocalReminderKind.fertileWindow:
        return (
          icon: Icons.auto_awesome_outlined,
          background: AppColors.secondary100,
          foreground: AppColors.secondary700,
        );
      case LocalReminderKind.ovulation:
        return (
          icon: Icons.brightness_5_outlined,
          background: AppColors.warning50,
          foreground: AppColors.warning800,
        );
      case LocalReminderKind.dailyCheckIn:
        return (
          icon: Icons.edit_note_rounded,
          background: AppColors.success50,
          foreground: AppColors.success700,
        );
    }
  }
}

class _KindChip extends StatelessWidget {
  const _KindChip({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.unread,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: unread ? background : AppColors.grey100,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 22,
              color: unread ? foreground : AppColors.grey600,
            ),
          ),
          if (unread)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 11,
                height: 11,
                decoration: BoxDecoration(
                  color: AppColors.primary500,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
