import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

class PersonalInformationScreen extends ConsumerWidget {
  const PersonalInformationScreen({super.key});

  Future<DateTime?> _pickDate(BuildContext context, DateTime? initialDate) {
    return showDatePicker(
      context: context,
      initialDate:
          initialDate ?? DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  Future<int?> _pickNumber(
    BuildContext context, {
    required String title,
    required int currentValue,
    required int min,
    required int max,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(title, style: AppText.h4),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int value = min; value <= max; value++)
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: value == currentValue
                              ? AppColors.primary50
                              : AppColors.grey100,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: value == currentValue
                                ? AppColors.primary300
                                : AppColors.grey200,
                          ),
                        ),
                        child: Text(
                          '$value',
                          style: AppText.label.copyWith(
                            color: value == currentValue
                                ? AppColors.primary400
                                : AppColors.grey800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileState = ref.watch(userProfileProvider);
    return SimplePage(
      title: l10n.personalInformation,
      child: profileState.when(
        data: (profile) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SectionLabel(l10n.cycleProfile),
                Text(
                  l10n.cycleProfileDescription,
                  style: AppText.caption,
                ),
                const SizedBox(height: 24),
                FieldLabel(l10n.dateOfBirth),
                PillTextField(
                  hint: profile.dateOfBirth == null
                      ? l10n.selectDate
                      : '${profile.dateOfBirth!.day.toString().padLeft(2, '0')}/${profile.dateOfBirth!.month.toString().padLeft(2, '0')}/${profile.dateOfBirth!.year}',
                  readOnly: true,
                  onTap: () async {
                    final selected = await _pickDate(context, profile.dateOfBirth);
                    if (selected != null) {
                      ref.read(userProfileProvider.notifier).patch(
                            (current) => current.copyWith(dateOfBirth: selected),
                          );
                    }
                  },
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.averageCycleLength),
                PillTextField(
                  hint: l10n.daysCount(profile.averageCycleLengthDays),
                  readOnly: true,
                  onTap: () async {
                    final selected = await _pickNumber(
                      context,
                      title: l10n.averageCycleLength,
                      currentValue: profile.averageCycleLengthDays,
                      min: 21,
                      max: 35,
                    );
                    if (selected != null) {
                      ref.read(userProfileProvider.notifier).patch(
                            (current) => current.copyWith(
                              averageCycleLengthDays: selected,
                            ),
                          );
                    }
                  },
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.periodLength),
                PillTextField(
                  hint: l10n.daysCount(profile.periodLengthDays),
                  readOnly: true,
                  onTap: () async {
                    final selected = await _pickNumber(
                      context,
                      title: l10n.periodLength,
                      currentValue: profile.periodLengthDays,
                      min: 2,
                      max: 12,
                    );
                    if (selected != null) {
                      ref.read(userProfileProvider.notifier).patch(
                            (current) => current.copyWith(
                              periodLengthDays: selected,
                            ),
                          );
                    }
                  },
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.lastPeriodStartDate),
                PillTextField(
                  hint: profile.lastPeriodStart == null
                      ? l10n.selectDate
                      : '${profile.lastPeriodStart!.day.toString().padLeft(2, '0')}/${profile.lastPeriodStart!.month.toString().padLeft(2, '0')}/${profile.lastPeriodStart!.year}',
                  readOnly: true,
                  onTap: () async {
                    final selected =
                        await _pickDate(context, profile.lastPeriodStart);
                    if (selected != null) {
                      ref.read(userProfileProvider.notifier).patch(
                            (current) =>
                                current.copyWith(lastPeriodStart: selected),
                          );
                    }
                  },
                ),
                const SizedBox(height: 18),
                FieldLabel(l10n.regularCycleQuestion),
                ToggleGroup(items: [
                  ToggleItemData(
                    profile.isCycleRegular ? l10n.regular : l10n.irregular,
                    profile.isCycleRegular,
                    (value) => ref.read(userProfileProvider.notifier).patch(
                          (current) => current.copyWith(isCycleRegular: value),
                        ),
                  ),
                ]),
                const SizedBox(height: 24),
                Text(
                  l10n.changesSavedAutomatically,
                  style: AppText.caption,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unableToLoadProfile)),
      ),
    );
  }
}
