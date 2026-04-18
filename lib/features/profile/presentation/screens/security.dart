import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/security_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';
import 'package:perla_app/shared/widgets/pin_code_input.dart';

class AccountSecurityScreen extends ConsumerStatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  ConsumerState<AccountSecurityScreen> createState() =>
      _AccountSecurityScreenState();
}

class _AccountSecurityScreenState
    extends ConsumerState<AccountSecurityScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _showPinDialog({required bool isNew}) async {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    String? pinError;
    String? confirmError;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isNew ? 'Set PIN lock' : 'Change PIN'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${isNew ? 'Enter' : 'New'} PIN:', style: AppText.label),
                  const SizedBox(height: 12),
                  PinCodeInput(
                    length: 4,
                    autoFocus: true,
                    onChanged: (pin) {
                      pinController.text = pin;
                      setDialogState(() {
                        pinError = null;
                      });
                    },
                    error: pinError, onCompleted: (String p1) {  },
                  ),
                  const SizedBox(height: 24),
                  const Text('Confirm PIN:', style: AppText.label),
                  const SizedBox(height: 12),
                  PinCodeInput(
                    length: 4,
                    onChanged: (confirm) {
                      confirmController.text = confirm;
                      setDialogState(() {
                        if (confirm.length == 4 && confirm == pinController.text) {
                          confirmError = null;
                        } else if (confirm.length == 4) {
                          confirmError = 'PINs do not match';
                        }
                      });
                    },
                    error: confirmError, 
                    onCompleted: (String p1) {  },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (pinController.text.length == 4 && 
                        confirmController.text.length == 4 && 
                        pinController.text == confirmController.text) {
                      await ref
                          .read(securityProvider.notifier)
                          .savePin(pinController.text);
                      if (isNew) {
                        await ref
                            .read(securityProvider.notifier)
                            .setAppLockEnabled(true);
                      }
                      Navigator.of(context).pop();
                    } else {
                      setDialogState(() {
                        if (pinController.text.length != 4) pinError = 'Enter 4 digits';
                        if (confirmController.text.length != 4) confirmError = 'Enter 4 digits';
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    pinController.dispose();
    confirmController.dispose();
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
                      'Journal Lock',
                      security.journalLockEnabled,
                      (v) => ref.read(securityProvider.notifier).setJournalLockEnabled(v),
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
