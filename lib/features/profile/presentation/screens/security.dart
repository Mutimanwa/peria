import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/features/profile/presentation/widgets/delete_account_dialog.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
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

enum _PinStep { current, create, confirm }

class _AccountSecurityScreenState extends ConsumerState<AccountSecurityScreen> {
  /// Saisie du code : création, confirmation, et vérification du code actuel
  /// avant d'en changer.
  ///
  /// L'ancien flux ne demandait jamais le code existant : n'importe qui
  /// pouvait remplacer le code puis désactiver le verrouillage.
  Future<bool> _showPinSheet({required bool enableJournalLock}) async {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(securityProvider.notifier);
    final pinConfigured =
        ref.read(securityProvider).value?.pinConfigured == true;

    var step = pinConfigured ? _PinStep.current : _PinStep.create;
    String? currentPin;
    String? pendingPin;
    String? error;
    var attempts = 0;
    var saved = false;

    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.46),
      elevation: 0,
      clipBehavior: Clip.none,
      builder: (sheetContext) {
        final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
        return Padding(
          padding: EdgeInsets.only(top: 28, bottom: bottomInset),
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              final title = switch (step) {
                _PinStep.current => l10n.securityCurrentPin,
                _PinStep.create => pinConfigured ? l10n.newPin : l10n.setPinLock,
                _PinStep.confirm => l10n.confirmPin,
              };
              final subtitle = step == _PinStep.confirm
                  ? l10n.confirmPin
                  : (enableJournalLock
                      ? l10n.globalSecurityRequiredForJournal
                      : l10n.enterPin);

              return DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      blurRadius: 28,
                      spreadRadius: 2,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.grey300,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppText.h4,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: AppText.body
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 20),
                        PinCodeInput(
                          // La clé change à chaque étape et à chaque refus :
                          // les cases repartent vides, sinon plus aucune
                          // frappe n'était prise.
                          key: ValueKey('$step-$attempts'),
                          length: 4,
                          autoFocus: true,
                          obscureText: true,
                          showVisibilityToggle: true,
                          error: error,
                          onChanged: (value) {
                            if (error != null && value.isNotEmpty) {
                              setSheetState(() => error = null);
                            }
                          },
                          onCompleted: (value) async {
                            if (step == _PinStep.current) {
                              final result =
                                  await notifier.authenticateWithPin(value);
                              if (result.isSuccess) {
                                setSheetState(() {
                                  currentPin = value;
                                  step = _PinStep.create;
                                  error = null;
                                });
                              } else {
                                setSheetState(() {
                                  error = l10n.securityIncorrectPin;
                                  attempts++;
                                });
                              }
                              return;
                            }

                            if (step == _PinStep.create) {
                              setSheetState(() {
                                pendingPin = value;
                                step = _PinStep.confirm;
                                error = null;
                              });
                              return;
                            }

                            if (value != pendingPin) {
                              setSheetState(() {
                                error = l10n.pinsDoNotMatch;
                                attempts++;
                              });
                              return;
                            }

                            try {
                              if (pinConfigured) {
                                await notifier.changePin(
                                  currentPin ?? '',
                                  pendingPin!,
                                );
                              } else {
                                await notifier.createPin(pendingPin!);
                                await notifier.setAppLockEnabled(true);
                              }
                              if (enableJournalLock) {
                                await notifier.setJournalLockEnabled(true);
                              }
                              saved = true;
                              if (sheetContext.mounted) {
                                Navigator.of(sheetContext).pop();
                              }
                            } catch (_) {
                              setSheetState(() {
                                error = l10n.securityAuthenticationError;
                                attempts++;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          child: Text(
                            l10n.cancel,
                            style: AppText.body
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
    return saved;
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

    return SimplePage(
      fallbackRoute: '/profile',
      title: l10n.accountSecurity,
      child: SingleChildScrollView(
        child: securityState.when(
          data: (security) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  AppAssets.security,
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
                      await _showPinSheet(enableJournalLock: false);
                      return;
                    }
                    if (v) _showDiscreteFeedback(l10n.securityAppLockOnNotice);
                    try {
                      await ref
                          .read(securityProvider.notifier)
                          .setAppLockEnabled(v);
                    } catch (_) {
                      if (mounted) _showDiscreteFeedback(l10n.securityToggleError);
                    }
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
                    try {
                      await ref
                          .read(securityProvider.notifier)
                          .setBiometricsEnabled(v);
                    } catch (_) {
                      if (mounted) _showDiscreteFeedback(l10n.securityToggleError);
                    }
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
                    if (v && !security.pinConfigured) {
                      await _showPinSheet(enableJournalLock: true);
                      return;
                    }
                    if (v) {
                      _showDiscreteFeedback(l10n.securityJournalLockOnNotice);
                    }
                    try {
                      if (v && !security.appLockEnabled) {
                        await ref
                            .read(securityProvider.notifier)
                            .setAppLockEnabled(true);
                      }
                      await ref
                          .read(securityProvider.notifier)
                          .setJournalLockEnabled(v);
                    } catch (_) {
                      if (mounted) _showDiscreteFeedback(l10n.securityToggleError);
                    }
                  },
                ),
                ToggleItemData(
                  l10n.multitaskProtection,
                  security.multitaskProtectionEnabled,
                  (v) async {
                    try {
                      await ref
                          .read(securityProvider.notifier)
                          .setMultitaskProtectionEnabled(v);
                    } catch (_) {
                      if (mounted) _showDiscreteFeedback(l10n.securityToggleError);
                    }
                  },
                ),
              ]),
              const SizedBox(height: 24),

              // SECTION: Gestion
              SectionLabel(l10n.management),
              MenuGroup(items: [
                if (security.appLockEnabled)
                  MenuItemData(
                    l10n.securityLockNow,
                    Icons.lock_clock_outlined,
                    () => ref.read(securityProvider.notifier).endSession(),
                  ),
                MenuItemData(
                  l10n.changePin,
                  Icons.lock_outline,
                  () => _showPinSheet(enableJournalLock: false),
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
                MenuItemData(
                  l10n.deleteAccount,
                  Icons.person_remove_outlined,
                  () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final deleted = await showDeleteAccountDialog(context);
                    if (!deleted) return;
                    if (!context.mounted) return;
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.deleteAccountSuccess)),
                    );
                    context.go('/welcome');
                  },
                  danger: true,
                ),
              ]),
              const SizedBox(height: 40),
            ],
          ),
          loading: () => const AccountSecuritySkeleton(),
          error: (e, __) => Center(child: Text(l10n.unableToLoadSecuritySettings)),
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
