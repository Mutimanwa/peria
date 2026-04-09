// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Peria';

  @override
  String get welcomeTitle => 'Bienvenue sur Peria';

  @override
  String get welcomeSubtitle =>
      'Peria t\'aide à comprendre ton corps avec un accompagnement doux et personnalisé.';

  @override
  String get turnOnNotifications => 'Activer les notifications';

  @override
  String get anotherTime => 'Plus tard';

  @override
  String get registerTitle => 'On commence';

  @override
  String get registerSubtitle =>
      'Connecte-toi ou crée un compte pour démarrer.';

  @override
  String get continueWithEmail => 'Continuer avec email';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get orDivider => 'Ou';

  @override
  String get enterYourEmailTitle => 'Saisis ton email';

  @override
  String get enterYourEmailSubtitle => 'On vérifie si tu as déjà un compte';

  @override
  String get emailAddressLabel => 'Adresse email';

  @override
  String get yourEmailAddressHint => 'Ton adresse email';

  @override
  String get continueCta => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get createAccountTitle => 'Créer ton compte';

  @override
  String get createAccountSubtitle =>
      'Choisis un mot de passe pour créer ton compte Peria.';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get enterYourPasswordHint => 'Saisis ton mot de passe';

  @override
  String get forgotYourPassword => 'Mot de passe oublié ?';

  @override
  String get setGoalsTitle => 'Quel est ton objectif ?';

  @override
  String get setGoalsSubtitle =>
      'Choisis ce sur quoi tu veux te concentrer\\npour personnaliser ton expérience.';

  @override
  String get askNameTitle => 'Comment veux-tu qu\'on t\'appelle ?';

  @override
  String get askNameSubtitle => 'Rendons cette expérience vraiment à toi.';

  @override
  String get enterYourNameHint => 'Saisis ton prénom';

  @override
  String get dateOfBirthTitle => 'Date de naissance';

  @override
  String get dateOfBirthSubtitle =>
      'Cela nous aide à personnaliser ton expérience.';

  @override
  String get whenWasYourLastPeriodTitle =>
      'Quand étaient tes dernières règles ?';

  @override
  String get whenWasYourLastPeriodSubtitle =>
      'Sélectionne le premier jour de tes dernières règles.';

  @override
  String get notSure => 'Je ne sais pas';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get madeByIm => 'Made by IM';

  @override
  String get nextPeriodUnknown => 'Prochaines règles : inconnues';

  @override
  String get periodIsDue => 'Les règles sont proches';

  @override
  String nextPeriodInDays(int days) {
    return 'Prochaines règles dans $days jours';
  }

  @override
  String get day => 'Jour';

  @override
  String get otpTitle => 'Saisis le code de vérification';

  @override
  String otpSubtitle(String email) {
    return 'Nous avons envoyé un code à $email';
  }

  @override
  String get didntGetCode => 'Tu n\'as pas reçu le code ?';

  @override
  String resendIn(int seconds) {
    return 'Renvoyer dans ${seconds}s';
  }

  @override
  String get resendNow => 'Renvoyer maintenant';

  @override
  String get otpContinue => 'Continuer';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalSubtitle =>
      'Ton espace privé pour noter tes ressentis, pensées et observations.';

  @override
  String get searchJournalHint => 'Rechercher dans le journal...';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get newEntry => 'Nouvelle note';

  @override
  String get noMatchingNotes => 'Aucune note trouvée';

  @override
  String get journalEmpty => 'Ton journal est vide';

  @override
  String get tryAnotherKeyword => 'Essaie un autre mot-clé.';

  @override
  String get startFirstNote =>
      'Commence ta première note privée. Elle reste sur cet appareil.';

  @override
  String get untitledNote => 'Note sans titre';

  @override
  String get noDetailsYet => 'Pas de détail pour l\'instant.';

  @override
  String get delete => 'Supprimer';

  @override
  String get saveEntry => 'Enregistrer';

  @override
  String get writeFreelyHint =>
      'Écris librement. Cette note reste sur ton appareil.';
}
