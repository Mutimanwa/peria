import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';

void safeRouterBack(BuildContext context, {String fallbackRoute = '/cycle'}) {
  final router = GoRouter.of(context);
  final canPop = router.canPop();
  debugPrint(
    '[Navigation] safeRouterBack canPop=$canPop fallback=$fallbackRoute',
  );
  if (canPop) {
    router.pop();
    return;
  }
  router.go(fallbackRoute);
}

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

// ══════════════════════════════════════════════════════════════════
// ICON BOUTON - carré arrondi avec icône au centre
// ══════════════════════════════════════════════════════════════════
class IconButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const IconButtonWidget({
    super.key,
    this.onPressed,
    required this.icon,
    this.backgroundColor = AppColors.white,
    this.iconColor = AppColors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: iconColor, size: 24),
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
  final List<Widget>? actions; 

  const PageScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.showTitle = true,
    this.onBack,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // 1. LE CONTENU PRINCIPAL
              child,

              // 2. LE HEADER FIXE (Placé après le child pour être au-dessus)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60, // Hauteur fixe du header
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    // On utilise le blanc avec une légère opacité ou le début du dégradé
                    // pour masquer les éléments qui scrollent derrière.
                    color: AppColors.white.withOpacity(0.98),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Bouton retour (à gauche)
                      if (showBack)
                        Positioned(
                          left: 0,
                          child: BackIconButton(onPressed: onBack),
                        ),

                      // Titre (centré)
                      if (showTitle && title != null)
                        Text(
                          title!,
                          style: AppText.h4
                        ),
                      
                      // Actions (à droite si tu en as besoin, comme le bouton Edit)
                      if (actions != null)
                        Positioned(
                          right: 0,
                          child: Row(children: actions!),
                        ),
                    ],
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
  final String fallbackRoute;

  const SimplePage({
    super.key,
    required this.title,
    required this.child,
    this.fallbackRoute = '/cycle',
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => safeRouterBack(context, fallbackRoute: fallbackRoute),
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


// ═══════════════════════════════════════════════════════════════════
// JOURNAL COMPONENTS
// ═══════════════════════════════════════════════════════════════════
class JournalMoodTone  {
  const JournalMoodTone({
    required this.label,
    required this.accent,
    required this.softBackground,
  });

  final String label;
  final Color accent;
  final Color softBackground;

  factory JournalMoodTone.fromMood(String mood) {
    switch (mood) {
      case 'happy':
        return const JournalMoodTone(
          label: 'Happy',
          accent: Color(0xFFB46900),
          softBackground: Color(0xFFFFF1D6),
        );
      case 'sad':
        return const JournalMoodTone(
          label: 'Sad',
          accent: AppColors.info700,
          softBackground: AppColors.info50,
        );
      case 'anxious':
        return const JournalMoodTone(
          label: 'Anxious',
          accent: AppColors.secondary600,
          softBackground: AppColors.secondary100,
        );
      case 'tired':
        return const JournalMoodTone(
          label: 'Tired',
          accent: Color(0xFF8A6A43),
          softBackground: Color(0xFFF2E9DF),
        );
      default:
        return const JournalMoodTone(
          label: 'Calm',
          accent: AppColors.primary500,
          softBackground: AppColors.primary50,
        );
    }
  }
}

class EmptyJournal extends StatelessWidget {
  const EmptyJournal({super.key, 
    required this.hasQuery,
    required this.selectedDate,
  });

  final bool hasQuery;
  final DateTime selectedDate;

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.78),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.edit_note_rounded, size: 30, color: AppColors.primary500),
          ),
          const SizedBox(height: 14),
          Text(
            hasQuery
                ? l10n.noMatchingNotes
                : (_isToday(selectedDate) ? l10n.journalEmpty : 'No entry for this day'),
            textAlign: TextAlign.center,
            style: AppText.h5,
          ),
          const SizedBox(height: 8),
          Text(
            hasQuery
                ? l10n.tryAnotherKeyword
                : (_isToday(selectedDate)
                    ? l10n.startFirstNote
                    : 'Use quick log to capture this moment.'),
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class JournalMetaChip extends StatelessWidget {
  const JournalMetaChip({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: AppColors.grey600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppText.label.copyWith(
              color: AppColors.grey600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({super.key, 
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, color: AppColors.grey700, size: 21),
      ),
    );
  }
}

