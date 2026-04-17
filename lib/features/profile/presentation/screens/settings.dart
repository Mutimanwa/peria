import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';


class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    return SimplePage(
      title: 'Settings',
      child: settingsState.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel('Appearance'),
            MenuGroup(items: [
              MenuItemData('Theme', Icons.palette_outlined, () {}),
            ]),
            const SizedBox(height: 22),
            const SectionLabel('Cycle Settings'),
            MenuGroup(items: [
              MenuItemData(
                'Period Length',
                Icons.water_drop_outlined,
                () => _showCycleLengthPicker(
                  context,
                  title: 'Period Length',
                  currentValue: settings.periodLengthDays,
                  min: 2,
                  max: 12,
                  onSelected: (value) =>
                      ref.read(appSettingsProvider.notifier).patch(
                            (current) =>
                                current.copyWith(periodLengthDays: value),
                          ),
                ),
                trailingText: '${settings.periodLengthDays} Days',
              ),
              MenuItemData(
                'Cycle Length',
                Icons.calendar_month_outlined,
                () => _showCycleLengthPicker(
                  context,
                  title: 'Cycle Length',
                  currentValue: settings.cycleLengthDays,
                  min: 20,
                  max: 40,
                  onSelected: (value) =>
                      ref.read(appSettingsProvider.notifier).patch(
                            (current) =>
                                current.copyWith(cycleLengthDays: value),
                          ),
                ),
                trailingText: '${settings.cycleLengthDays} Days',
              ),
            ]),
            const SizedBox(height: 22),
            const SectionLabel('Integrations & Sync'),
            MenuGroup(items: [
              MenuItemData(
                  'Connected Apps', Icons.all_inclusive_rounded, () {}),
            ]),
            const SizedBox(height: 22),
            const SectionLabel('About'),
            MenuGroup(items: [
              MenuItemData(
                  'Privacy Policy', Icons.verified_user_outlined, () {}),
              MenuItemData('App Version', Icons.info_outline_rounded, () {},
                  trailingText: '1.0.2'),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load settings')),
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
                          horizontal: 16, vertical: 12),
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




