import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/features/profile/presentation/providers/security_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class AccountSecurityScreen extends ConsumerStatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  ConsumerState<AccountSecurityScreen> createState() =>
      _AccountSecurityScreenState();
}

class _AccountSecurityScreenState
    extends ConsumerState<AccountSecurityScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _showPinDialog({required bool isNew}) async {
    _pinController.clear();
    _confirmPinController.clear();
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isNew ? 'Set PIN lock' : 'Change PIN'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return 'Enter at least 4 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Confirm PIN',
                  ),
                  validator: (value) {
                    if (value != _pinController.text) {
                      return 'PINs do not match';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  await ref
                      .read(securityProvider.notifier)
                      .savePin(_pinController.text.trim());
                  await ref
                      .read(securityProvider.notifier)
                      .setAppLockEnabled(true);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(appSettingsProvider);
    final securityState = ref.watch(securityProvider);
    return SimplePage(
      title: 'Account & Security',
      child: settingsState.when(
        data: (settings) => Column(
          children: [
            const SizedBox(height: 6),
            Image.asset('assets/images/icons/security.png', width: 96, height: 96),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: SectionLabel('Security'),
            ),
            securityState.when(
              data: (security) => Column(
                children: [
                  ToggleGroup(items: [
                    ToggleItemData(
                      'App Lock',
                      security.appLockEnabled,
                      (v) async {
                        if (!security.pinConfigured && v) {
                          await _showPinDialog(isNew: true);
                          return;
                        }
                        await ref
                            .read(securityProvider.notifier)
                            .setAppLockEnabled(v);
                      },
                    ),
                    ToggleItemData(
                      'Face ID',
                      settings.faceIdEnabled,
                      (v) => ref.read(appSettingsProvider.notifier).patch(
                            (current) => current.copyWith(faceIdEnabled: v),
                          ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  if (security.pinConfigured)
                    PrimaryButton(
                      label: 'Change PIN',
                      onPressed: () => _showPinDialog(isNew: false),
                    ),
                  if (security.pinConfigured)
                    const SizedBox(height: 12),
                  if (security.pinConfigured)
                    OutlineButton(
                      label: 'Disable PIN lock',
                      onPressed: () async {
                        await ref.read(securityProvider.notifier).clearPin();
                      },
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('Unable to load security settings')),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load account settings')),
      ),
    );
  }
}
