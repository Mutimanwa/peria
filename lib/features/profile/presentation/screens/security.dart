import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class AccountSecurityScreen extends ConsumerWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    return SimplePage(
      title: 'Account & Security',
      child: settingsState.when(
        data: (settings) => Column(
          children: [
            const SizedBox(height: 6),
            Image.asset('assets/images/icons/security.png',
                width: 96, height: 96),
            const SizedBox(height: 24),
            const Align(
                alignment: Alignment.centerLeft,
                child: SectionLabel('Account')),
            MenuGroup(items: [
              MenuItemData('Email Address', Icons.email_outlined, () {}),
              MenuItemData(
                  'Change Password', Icons.lock_outline_rounded, () {}),
            ]),
            const SizedBox(height: 22),
            const Align(
                alignment: Alignment.centerLeft,
                child: SectionLabel('Security')),
            ToggleGroup(items: [
              ToggleItemData(
                'Two Factor Authentication',
                settings.twoFactorEnabled,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(twoFactorEnabled: v),
                    ),
              ),
              ToggleItemData(
                'Face ID',
                settings.faceIdEnabled,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(faceIdEnabled: v),
                    ),
              ),
              ToggleItemData(
                'Discreet Mode',
                settings.discreetModeEnabled,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(discreetModeEnabled: v),
                    ),
              ),
            ]),
            const SizedBox(height: 22),
            MenuGroup(items: [
              MenuItemData(
                  'Delete Account', Icons.delete_outline_rounded, () {},
                  danger: true),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const Center(child: Text('Unable to load security settings')),
      ),
    );
  }
}
