import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/l10n/app_localizations.dart';

// ═══════════════════════════════════════════════════════════════════
//  BOUTON PRIMAIRE — fond noir, texte blanc, pill shape
// ═══════════════════════════════════════════════════════════════════
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed; // null = état désactivé (gris)
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? AppColors.grey900 : AppColors.grey200,
          disabledBackgroundColor: AppColors.grey200,
          foregroundColor: enabled ? AppColors.white : AppColors.grey500,
          elevation: 0,
          shape: const StadiumBorder(),
        ),
        child: Text(label,
            style: enabled
                ? AppText.btnPrimary
                : AppText.btnPrimary.copyWith(color: AppColors.grey500)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOUTON OUTLINE — bordure noire, fond blanc
// ═══════════════════════════════════════════════════════════════════
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const OutlineButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          elevation: 0,
          side: const BorderSide(color: AppColors.black, width: 1.5),
          shape: const StadiumBorder(),
        ),
        child: Text(label, style: AppText.btnOutline),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOUTON SOCIAL (Google / Apple) — outline, avec logo
// ═══════════════════════════════════════════════════════════════════
class SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  const SocialButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.grey200, width: 1.5),
          shape: const StadiumBorder(),
          backgroundColor: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(label, style: AppText.label),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOUTON RETOUR — carré arrondi avec chevron
// ═══════════════════════════════════════════════════════════════════
class BackIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const BackIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).maybePop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: const Icon(Icons.chevron_left_rounded,
            color: AppColors.black, size: 24),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  CHAMP DE SAISIE — pill shape, fond gris clair
// ═══════════════════════════════════════════════════════════════════
class PillTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  const PillTextField({
    super.key,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.keyboardType,
    this.suffix,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: AppText.label,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppText.caption.copyWith(fontSize: 14),
        filled: true,
        fillColor: AppColors.grey100,
        suffixIcon: suffix != null
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffix,
              )
            : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            // borderSide: const BorderSide(color: AppColors.black, width: 1.5),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: AppColors.black, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SCAFFOLD ONBOARDING — gradient bg + back + skip
// ═══════════════════════════════════════════════════════════════════
class OnboardingScaffold extends StatelessWidget {
  final Widget child;
  final bool showBack;
  final bool showSkip;
  final VoidCallback? onSkip;
  final VoidCallback? onBack;

  const OnboardingScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.showSkip = false,
    this.onSkip,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Contenu principal
              child,
              // ── Bouton retour
              if (showBack)
                Positioned(
                  top: 12,
                  left: 20,
                  child: BackIconButton(onPressed: onBack),
                ),
              // ── Lien Skip
              if (showSkip)
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: onSkip,
                    child: Text(AppLocalizations.of(context).skip,
                        style: AppText.body.copyWith(
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  SCAFFOLD PAGES — gradient bg + back + title
// ═══════════════════════════════════════════════════════════════════
class PageScaffold extends StatelessWidget {
  final Widget child;
  final bool showBack;
  final bool showTitle;
  final VoidCallback? onBack;
  final String? title;

  const PageScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.showTitle = true,
    this.onBack,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Contenu principal
              child,

              // ── Bouton retour (à gauche)
              if (showBack)
                Positioned(
                  top: 12,
                  left: 20,
                  child: BackIconButton(onPressed: onBack),
                ),

              // ── Titre (au milieu)
              if (showTitle && title != null)
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// SIMPLE PAGE SCAFFOLD - 
// ==========================================
class SimplePage extends StatelessWidget {
  final String title;
  final Widget child;

  const SimplePage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: title,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 80, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
