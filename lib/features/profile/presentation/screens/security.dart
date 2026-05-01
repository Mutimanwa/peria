import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peria_app/core/storage/app_settings_provider.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/pin_code_input.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

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
              loading: () => const _SecuritySettingsSkeleton(),
              error: (_, __) =>
                  Center(child: Text(l10n.unableToLoadSecuritySettings)),
            ),
          ],
        ),
        loading: () => const _AccountSettingsSkeleton(),
        error: (_, __) => Center(child: Text(l10n.unableToLoadAccountSettings)),
      ),
    );
  }
}

// Skeleton for the main account settings loading state
class _AccountSettingsSkeleton extends StatelessWidget {
  const _AccountSettingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 6),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(48),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 100,
              height: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Toggle items skeletons
          _buildToggleSkeleton(),
          const SizedBox(height: 16),
          _buildToggleSkeleton(),
          const SizedBox(height: 16),
          _buildToggleSkeleton(),
        ],
      ),
    );
  }

  Widget _buildToggleSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            height: 18,
            color: Colors.white,
          ),
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}

// Skeleton for security settings loading state
class _SecuritySettingsSkeleton extends StatelessWidget {
  const _SecuritySettingsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: Colors.white,
      child: Column(
        children: [
          // Toggle items
          _buildToggleSkeleton(),
          const SizedBox(height: 16),
          _buildToggleSkeleton(),
          const SizedBox(height: 16),
          _buildToggleSkeleton(),
          const SizedBox(height: 24),
          // Change PIN button skeleton
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 12),
          // Disable PIN button skeleton
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSkeleton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            height: 18,
            color: Colors.white,
          ),
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative: Single combined skeleton
class AccountSecuritySkeleton extends StatelessWidget {
  const AccountSecuritySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 6),
          // Security icon skeleton
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(48),
            ),
          ),
          const SizedBox(height: 24),
          // Section label skeleton
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 80,
              height: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // App Lock toggle
          _buildToggleRow(),
          const SizedBox(height: 16),
          // Journal Lock toggle
          _buildToggleRow(),
          const SizedBox(height: 16),
          // Face ID toggle
          _buildToggleRow(),
          const SizedBox(height: 24),
          // Change PIN button skeleton
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          const SizedBox(height: 12),
          // Disable PIN button skeleton
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 100,
            height: 18,
            color: Colors.white,
          ),
          Container(
            width: 50,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ],
      ),
    );
  }
}