import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/app_language_selector.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final profileState = ref.watch(userProfileProvider);
    final appLocale = ref.watch(appLocaleProvider);
    final deviceLanguageCode = Localizations.localeOf(context).languageCode;
    final selectedLanguageCode = appLocale?.languageCode ??
        (deviceLanguageCode == 'fr' ? 'fr' : 'en');
    return SimplePage(
      title: l10n.settings,
      fallbackRoute: '/profile',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(l10n.appearance),
            MenuGroup(items: [
              MenuItemData(l10n.theme, Icons.palette_outlined, () {}),
            ]),
            const SizedBox(height: 22),
            SectionLabel(l10n.language),
            AppLanguageSelector(
              currentLanguageCode: selectedLanguageCode,
              englishLabel: l10n.languageEnglish,
              frenchLabel: l10n.languageFrench,
              onSelected: (languageCode) {
                _saveLanguagePreference(context, ref, languageCode);
              },
            ),
            const SizedBox(height: 22),
            SectionLabel(l10n.cycleSettings),
            MenuGroup(items: [
              MenuItemData(
                l10n.periodLength,
                Icons.water_drop_outlined,
                () => _showCycleLengthPicker(
                  context,
                  title: l10n.periodLength,
                  currentValue: profileState.value?.periodLengthDays ?? 5,
                  min: 2,
                  max: 12,
                  onSelected: (value) =>
                      ref.read(userProfileProvider.notifier).patch(
                            (current) =>
                                current.copyWith(periodLengthDays: value),
                          ),
                ),
                trailingText:
                    l10n.daysCount(profileState.value?.periodLengthDays ?? 5),
              ),
              MenuItemData(
                l10n.cycleLength,
                Icons.calendar_month_outlined,
                () => _showCycleLengthPicker(
                  context,
                  title: l10n.cycleLength,
                  currentValue:
                      profileState.value?.averageCycleLengthDays ?? 28,
                  min: 20,
                  max: 40,
                  onSelected: (value) =>
                      ref.read(userProfileProvider.notifier).patch(
                            (current) =>
                                current.copyWith(averageCycleLengthDays: value),
                          ),
                ),
                trailingText: l10n.daysCount(
                    profileState.value?.averageCycleLengthDays ?? 28),
              ),
            ]),
            const SizedBox(height: 22),
            SectionLabel(l10n.integrationsSync),
            MenuGroup(items: [
              MenuItemData(
                l10n.journalCloudSync,
                Icons.cloud_outlined,
                () => context.go('/profile/journal-sync'),
              ),
              MenuItemData(
                  l10n.connectedApps, Icons.all_inclusive_rounded, () {}),
            ]),
            const SizedBox(height: 22),
            SectionLabel(l10n.about),
            MenuGroup(items: [
              MenuItemData(
                l10n.privacyPolicy,
                Icons.verified_user_outlined,
                () => context.push('/privacy-policy'),
              ),
              MenuItemData(l10n.appVersion, Icons.info_outline_rounded, () {},
                  trailingText: '1.0.2'),
            ]),
          ],
        ),
      ),
    );
  }
}

Future<void> _saveLanguagePreference(
  BuildContext context,
  WidgetRef ref,
  String languageCode,
) async {
  try {
    await ref.read(appLocaleProvider.notifier).setLanguageCode(languageCode);
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).languageSaveError),
      ),
    );
  }
}

Future<void> _showCycleLengthPicker(
  BuildContext context, {
  required String title,
  required int currentValue,
  required int min,
  required int max,
  required ValueChanged<int> onSelected,
}) async {
  final result = await showModalBottomSheet<int>(
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

  if (result != null) {
    onSelected(result);
  }
}
