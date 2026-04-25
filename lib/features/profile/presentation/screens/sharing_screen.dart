import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

class SharingSettingsScreen extends ConsumerWidget {
  const SharingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(partnerSettingsProvider);
    return SimplePage(
      title: l10n.sharingSettings,
      child: state.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.chooseWhatToShare, style: AppText.h3),
            const SizedBox(height: 10),
            Text(
              l10n.manageSharedCycleData,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 22),
            ToggleGroup(items: [
              ToggleItemData(
                l10n.cyclePredictions,
                settings.shareCyclePredictions,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) =>
                          current.copyWith(shareCyclePredictions: v),
                    ),
              ),
              ToggleItemData(
                l10n.loggedSymptoms,
                settings.shareLoggedSymptoms,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) => current.copyWith(shareLoggedSymptoms: v),
                    ),
              ),
              ToggleItemData(
                l10n.periodDates,
                settings.sharePeriodDates,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) => current.copyWith(sharePeriodDates: v),
                    ),
              ),
              ToggleItemData(
                l10n.moodEntries,
                settings.shareMoodEntries,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) => current.copyWith(shareMoodEntries: v),
                    ),
              ),
            ]),
            const Spacer(),
            PrimaryButton(
              label: l10n.saveChanges,
              onPressed: () => context.pop(),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            Center(child: Text(l10n.unableToLoadSharingSettings)),
      ),
    );
  }
}
