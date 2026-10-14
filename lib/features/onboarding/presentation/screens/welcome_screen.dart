import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/core/services/local_notification_provider.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/privacy/domain/privacy_policy_content.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/app_language_selector.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final PrivacyPolicyConsentService _consentService =
      PrivacyPolicyConsentService();

  bool _policyAccepted = false;
  String? _policyAcceptedLanguageCode;
  bool _isContinuing = false;
  String? _errorMessage;

  Future<void> _continue() async {
    final currentLanguageCode = Localizations.localeOf(context).languageCode;
    if (!_policyAccepted ||
        _policyAcceptedLanguageCode != currentLanguageCode ||
        _isContinuing) {
      return;
    }

    setState(() {
      _isContinuing = true;
      _errorMessage = null;
    });

    try {
      // Save the current policy version before creating a Firebase account.
      await _consentService.acceptCurrentPolicy();
      if (!mounted) return;

      // Existing authenticated users are retained; only new users are created.
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      if (!mounted) return;

      // Refresh consent-dependent startup work now that the gate is open.
      ref.invalidate(localNotificationScheduleProvider);
      context.go('/welcome');
    } catch (_) {
      if (!mounted) return;
      final copy = PrivacyPolicyContent.forLanguageCode(
        Localizations.localeOf(context).languageCode,
      );
      setState(() => _errorMessage = copy.continueFailedMessage);
    } finally {
      if (mounted) setState(() => _isContinuing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appLocale = ref.watch(appLocaleProvider);
    final currentLanguageCode = Localizations.localeOf(context).languageCode;
    final selectedLanguageCode = appLocale?.languageCode ??
        (currentLanguageCode == 'fr' ? 'fr' : 'en');
    final policyAcceptedForCurrentLanguage = _policyAccepted &&
        _policyAcceptedLanguageCode == currentLanguageCode;
    final copy =
        PrivacyPolicyContent.forLanguageCode(currentLanguageCode);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AppLanguageSelector(
                    currentLanguageCode: selectedLanguageCode,
                    englishLabel: l10n.languageEnglish,
                    frenchLabel: l10n.languageFrench,
                    compact: true,
                    onSelected: (languageCode) async {
                      if (_isContinuing ||
                          languageCode == selectedLanguageCode) {
                        return;
                      }
                      setState(() {
                        _policyAccepted = false;
                        _policyAcceptedLanguageCode = null;
                        _errorMessage = null;
                      });
                      try {
                        await ref
                            .read(appLocaleProvider.notifier)
                            .setLanguageCode(languageCode);
                      } catch (_) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context).languageSaveError,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(child: Image.asset(AppAssets.logo)),
              const SizedBox(height: 36),
              Expanded(
                child: Image.asset(
                  AppAssets.onboardingMainFrame,
                  height: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      l10n.welcomeTitle,
                      style: AppText.h1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.welcomeSubtitle,
                      style: AppText.body,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withAlpha(220),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                          value: policyAcceptedForCurrentLanguage,
                          onChanged: _isContinuing
                              ? null
                              : (value) => setState(() {
                                    _policyAccepted = value ?? false;
                                    _policyAcceptedLanguageCode =
                                        _policyAccepted
                                            ? currentLanguageCode
                                            : null;
                                  }),
                            activeColor: AppColors.primary400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 7),
                                Text(
                                  copy.acceptancePrompt,
                                  style: AppText.body.copyWith(
                                    color: AppColors.grey800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.push('/privacy-policy'),
                                  style: TextButton.styleFrom(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 32),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    copy.title,
                                    style: AppText.label.copyWith(
                                      color: AppColors.primary600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primary600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          copy.journalSyncNotice,
                          style: AppText.caption.copyWith(
                            color: AppColors.grey600,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: AppText.caption.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: _isContinuing
                          ? copy.continuingLabel
                          : l10n.continueCta,
                      onPressed:
                          policyAcceptedForCurrentLanguage && !_isContinuing
                              ? _continue
                              : null,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
