import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/calendar/presentation/constants/symptom_constants.dart';
import 'package:peria_app/features/calendar/presentation/providers/symptom_provider.dart';
import 'package:peria_app/features/calendar/presentation/symptom_localization.dart';
import 'package:peria_app/l10n/app_localizations.dart';

/// Summary of the symptoms logged for one day, as shown under the calendar.
class DaySymptomsCard extends ConsumerWidget {
  const DaySymptomsCard({
    super.key,
    required this.date,
    required this.onEdit,
  });

  final DateTime date;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final logAsync = ref.watch(symptomLogProvider(date));
    final log = logAsync.value;

    final categories = <String, List<String>>{};
    for (final key in symptomCategories.keys) {
      final values = log?.selections[key] ?? const <String>[];
      if (values.isNotEmpty) categories[key] = values;
    }
    final water = log?.waterMl;
    final note = log?.freeNotes.trim() ?? '';
    final hasContent =
        categories.isNotEmpty || water != null || note.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat.MMMMd(locale).format(date),
                  style: AppText.h4.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Material(
                color: AppColors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onEdit,
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.grey200),
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 17,
                      color: AppColors.grey700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!hasContent)
            logAsync.isLoading
                ? const SizedBox(height: 8)
                : Text(
                    l10n.daySymptomsEmpty,
                    style: AppText.caption.copyWith(color: AppColors.textSecondary),
                  )
          else ...[
            for (final entry in categories.entries)
              _CategoryRow(
                label: symptomLabel(l10n, entry.key),
                values: entry.value,
                l10n: l10n,
              ),
            if (water != null)
              _InlineRow(
                label: l10n.symptomWater,
                icon: Icons.local_drink_outlined,
                text: '$water ml / $kWaterGoalMl ml',
                emphasized: true,
              ),
            if (note.isNotEmpty)
              _InlineRow(
                label: l10n.notes,
                icon: Icons.event_note_outlined,
                text: note,
                emphasized: false,
              ),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.values,
    required this.l10n,
  });

  final String label;
  final List<String> values;
  final AppLocalizations l10n;

  static const int _maxChips = 4;

  @override
  Widget build(BuildContext context) {
    final visible = values.take(_maxChips).toList();
    final hidden = values.length - visible.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const _RowDot(),
          const SizedBox(width: 10),
          SizedBox(
            width: 104,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                for (final value in visible)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Tooltip(
                      message: symptomLabel(l10n, value),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Icon(
                          symptomIcon(value),
                          size: 16,
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                  ),
                if (hidden > 0)
                  Text(
                    '…',
                    style: AppText.body.copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineRow extends StatelessWidget {
  const _InlineRow({
    required this.label,
    required this.icon,
    required this.text,
    required this.emphasized,
  });

  final String label;
  final IconData icon;
  final String text;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const _RowDot(),
          const SizedBox(width: 10),
          SizedBox(
            width: 104,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 17, color: AppColors.primary500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(
                      color: emphasized
                          ? AppColors.primary500
                          : AppColors.grey800,
                      fontWeight:
                          emphasized ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDot extends StatelessWidget {
  const _RowDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: AppColors.grey400,
        shape: BoxShape.circle,
      ),
    );
  }
}
