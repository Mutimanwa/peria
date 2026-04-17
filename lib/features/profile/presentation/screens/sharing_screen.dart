import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class SharingSettingsScreen extends StatefulWidget {
  const SharingSettingsScreen({super.key});

  @override
  State<SharingSettingsScreen> createState() => _SharingSettingsScreenState();
}

class _SharingSettingsScreenState extends State<SharingSettingsScreen> {
  bool loggedSymptoms = true;
  bool moodEntries = true;

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Sharing Settings',
      child: Column(
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
            ToggleItemData('Cycle Predictions', false, (_) {}),
            ToggleItemData('Logged Symptoms', loggedSymptoms,
                (v) => setState(() => loggedSymptoms = v)),
            ToggleItemData('Period Dates', false, (_) {}),
            ToggleItemData('Mood Entries', moodEntries,
                (v) => setState(() => moodEntries = v)),
          ]),
          const Spacer(),
          PrimaryButton(label: 'Save Changes', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}
