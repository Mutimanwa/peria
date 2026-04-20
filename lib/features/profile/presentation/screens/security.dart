import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/security_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/pin_code_input.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class AccountSecurityScreen extends ConsumerStatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  ConsumerState<AccountSecurityScreen> createState() =>
      _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends ConsumerState<AccountSecurityScreen> {
  Future<void> _showPinDialog({required bool isNew}) async {
    final l10n = AppLocalizations.of(context);
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
              title: Text(isNew ? l10n.setPinLock : l10n.changePin),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isNew ? l10n.enterPin : l10n.newPin, style: AppText.label),
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
                    error: pinError,
                    onCompleted: (String p1) {},
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.confirmPin, style: AppText.label),
                  const SizedBox(height: 12),
                  PinCodeInput(
                    length: 4,
                    onChanged: (confirm) {
                      confirmController.text = confirm;
                      setDialogState(() {
                        if (confirm.length == 4 && confirm == pinController.text) {
                          confirmError = null;
                        } else if (confirm.length == 4) {
                          confirmError = l10n.pinsDoNotMatch;
                        }
                      });
                    },
                    error: confirmError,
                    onCompleted: (String p1) {},
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
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
                      if (!mounted) return;
                      navigator.pop();
                    } else {
                      setDialogState(() {
                        if (pinController.text.length != 4) {
                          pinError = l10n.enter4Digits;
                        }
                        if (confirmController.text.length != 4) {
                          confirmError = l10n.enter4Digits;
                        }
                      });
                    }
                  },
                  child: Text(l10n.save),
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
    final l10n = AppLocalizations.of(context);
    final settingsState = ref.watch(appSettingsProvider);
    final securityState = ref.watch(securityProvider);
    return SimplePage(
      title: l10n.accountSecurity,
      child: settingsState.when(
        data: (settings) => Column(
          children: [
            const SizedBox(height: 6),
            Image.asset('assets/images/icons/security.png', width: 96, height: 96),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: SectionLabel(l10n.security),
            ),
            securityState.when(
              data: (security) => Column(
                children: [
                  ToggleGroup(items: [
                    ToggleItemData(
                      l10n.appLock,
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
                      l10n.journalLock,
                      security.journalLockEnabled,
                      (v) => ref
                          .read(securityProvider.notifier)
                          .setJournalLockEnabled(v),
                    ),
                    ToggleItemData(
                      l10n.faceId,
                      settings.faceIdEnabled,
                      (v) => ref.read(appSettingsProvider.notifier).patch(
                            (current) => current.copyWith(faceIdEnabled: v),
                          ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  if (security.pinConfigured)
                    PrimaryButton(
                      label: l10n.changePinButton,
                      onPressed: () => _showPinDialog(isNew: false),
                    ),
                  if (security.pinConfigured) const SizedBox(height: 12),
                  if (security.pinConfigured)
                    OutlineButton(
                      label: l10n.disablePinLock,
                      onPressed: () async {
                        await ref.read(securityProvider.notifier).clearPin();
                      },
                    ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  Center(child: Text(l10n.unableToLoadSecuritySettings)),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unableToLoadAccountSettings)),
      ),
    );
  }
}
