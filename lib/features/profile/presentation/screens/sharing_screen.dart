import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class SharingSettingsScreen extends ConsumerWidget {
  const SharingSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(partnerSettingsProvider);
    return SimplePage(
      title: 'Sharing Settings',
      child: state.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose What to Share', style: AppText.h3),
            const SizedBox(height: 10),
            Text(
              'You can now manage your shared cycle data and insights below.',
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 22),
            ToggleGroup(items: [
              ToggleItemData(
                'Cycle Predictions',
                settings.shareCyclePredictions,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) =>
                          current.copyWith(shareCyclePredictions: v),
                    ),
              ),
              ToggleItemData(
                'Logged Symptoms',
                settings.shareLoggedSymptoms,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) => current.copyWith(shareLoggedSymptoms: v),
                    ),
              ),
              ToggleItemData(
                'Period Dates',
                settings.sharePeriodDates,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) => current.copyWith(sharePeriodDates: v),
                    ),
              ),
              ToggleItemData(
                'Mood Entries',
                settings.shareMoodEntries,
                (v) => ref.read(partnerSettingsProvider.notifier).patch(
                      (current) => current.copyWith(shareMoodEntries: v),
                    ),
              ),
            ]),
            const Spacer(),
            PrimaryButton(label: 'Save Changes', onPressed: () => context.pop()),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load sharing settings')),
      ),
    );
  }
}
