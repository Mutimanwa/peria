import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/profile/presentation/providers/security_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
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
    String? pin;
    String? error;
    bool isConfirming = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              title: Column(
                children: [
                  Text(
                    isConfirming
                        ? l10n.confirmPin
                        : (isNew ? l10n.setPinLock : l10n.newPin),
                    textAlign: TextAlign.center,
                    style: AppText.h4,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isConfirming
                        ? l10n.enterPin // Or a "re-enter" key
                        : (isNew ? l10n.enterPin : l10n.newPin),
                    textAlign: TextAlign.center,
                    style: AppText.caption.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: PinCodeInput(
                  key: ValueKey(
                      isConfirming), // Force rebuild for step transition
                  length: 4,
                  autoFocus: true,
                  obscureText: true,
                  showVisibilityToggle: true,
                  error: error,
                  onChanged: (v) {
                    if (error != null) {
                      setDialogState(() => error = null);
                    }
                  },
                  onCompleted: (value) async {
                    if (!isConfirming) {
                      setDialogState(() {
                        pin = value;
                        isConfirming = true;
                        error = null;
                      });
                    } else {
                      if (value == pin) {
                        final navigator = Navigator.of(context);
                        await ref
                            .read(securityProvider.notifier)
                            .createPin(pin!);
                        if (isNew) {
                          await ref
                              .read(securityProvider.notifier)
                              .setAppLockEnabled(true);
                        }
                        navigator.pop();
                      } else {
                        setDialogState(() {
                          error = l10n.pinsDoNotMatch;
                        });
                      }
                    }
                  },
                ),
              ),
              actionsPadding: const EdgeInsets.only(bottom: 16),
              actions: [
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel,
                        style: AppText.body.copyWith(color: AppColors.grey500)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDiscreteFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.grey900,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDependencyWarning() {
    final l10n = AppLocalizations.of(context);
    _showDiscreteFeedback(l10n.globalSecurityRequiredForJournal);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final securityState = ref.watch(securityProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(l10n.accountSecurity, style: AppText.h3),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.grey900),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: securityState.when(
          data: (security) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/icons/security.png',
                  width: 96,
                  height: 96,
                ),
              ),
              const SizedBox(height: 32),

              // SECTION: Accès App
              SectionLabel(l10n.appAccess),
              ToggleGroup(items: [
                ToggleItemData(
                  l10n.globalSecurity,
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
                  l10n.biometricAuth,
                  security.biometricsEnabled,
                  (v) async {
                    if (!security.appLockEnabled && v) {
                      _showDependencyWarning();
                      return;
                    }
                    await ref
                        .read(securityProvider.notifier)
                        .setBiometricsEnabled(v);
                  },
                ),
              ]),
              const SizedBox(height: 24),

              // SECTION: Confidentialité
              SectionLabel(l10n.confidentiality),
              ToggleGroup(items: [
                ToggleItemData(
                  l10n.journalLock,
                  security.journalLockEnabled,
                  (v) async {
                    if (!security.appLockEnabled && v) {
                      _showDependencyWarning();
                      return;
                    }
                    await ref
                        .read(securityProvider.notifier)
                        .setJournalLockEnabled(v);
                  },
                ),
                ToggleItemData(
                  l10n.multitaskProtection,
                  security.multitaskProtectionEnabled,
                  (v) => ref
                      .read(securityProvider.notifier)
                      .setMultitaskProtectionEnabled(v),
                ),
              ]),
              const SizedBox(height: 24),

              // SECTION: Gestion
              SectionLabel(l10n.management),
              MenuGroup(items: [
                MenuItemData(
                  l10n.changePin,
                  Icons.lock_outline,
                  () => _showPinDialog(isNew: false),
                ),
                MenuItemData(
                  l10n.clearLocalData,
                  Icons.delete_outline,
                  () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(l10n.confirmClearData),
                        content: Text(l10n.clearDataWarning),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text(l10n.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              l10n.delete,
                              style: const TextStyle(color: Color(0xFFFF6E6E)),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref
                          .read(securityProvider.notifier)
                          .clearAllLocalData();
                    }
                  },
                  danger: true,
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
          loading: () => const AccountSecuritySkeleton(),
          error: (e, __) => Center(child: Text('Erreur: $e')),
        ),
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
