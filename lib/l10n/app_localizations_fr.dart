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
      'Peria t\'aide a comprendre ton corps avec un accompagnement doux et personnalise.';

  @override
  String get turnOnNotifications => 'Activer les notifications';

  @override
  String get anotherTime => 'Plus tard';

  @override
  String get registerTitle => 'On commence';

  @override
  String get registerSubtitle =>
      'Connecte-toi ou cree un compte pour demarrer.';

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
  String get enterYourEmailSubtitle => 'On verifie si tu as deja un compte';

  @override
  String get emailAddressLabel => 'Adresse email';

  @override
  String get yourEmailAddressHint => 'Ton adresse email';

  @override
  String get continueCta => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get createAccountTitle => 'Creer ton compte';

  @override
  String get createAccountSubtitle =>
      'Choisis un mot de passe pour creer ton compte Peria.';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get enterYourPasswordHint => 'Saisis ton mot de passe';

  @override
  String get forgotYourPassword => 'Mot de passe oublie ?';

  @override
  String get setGoalsTitle => 'Quel est ton objectif ?';

  @override
  String get setGoalsSubtitle =>
      'Choisis ce sur quoi tu veux te concentrer\\npour personnaliser ton experience.';

  @override
  String get askNameTitle => 'Comment veux-tu qu\'on t\'appelle ?';

  @override
  String get askNameSubtitle => 'Rendons cette experience vraiment a toi.';

  @override
  String get enterYourNameHint => 'Saisis ton prenom';

  @override
  String get dateOfBirthTitle => 'Date de naissance';

  @override
  String get dateOfBirthSubtitle =>
      'Cela nous aide a personnaliser ton experience.';

  @override
  String get whenWasYourLastPeriodTitle =>
      'Quand etaient tes dernieres regles ?';

  @override
  String get whenWasYourLastPeriodSubtitle =>
      'Selectionne le premier jour de tes dernieres regles.';

  @override
  String get notSure => 'Je ne sais pas';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get madeByIm => 'Made by IM';

  @override
  String get nextPeriodUnknown => 'Prochaines regles : inconnues';

  @override
  String get periodIsDue => 'Les regles sont proches';

  @override
  String nextPeriodInDays(int days) {
    return 'Prochaines regles dans $days jours';
  }

  @override
  String get day => 'Jour';

  @override
  String get otpTitle => 'Saisis le code de verification';

  @override
  String otpSubtitle(String email) {
    return 'Nous avons envoye un code a $email';
  }

  @override
  String get didntGetCode => 'Tu n\'as pas recu le code ?';

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
      'Ton espace prive pour noter tes ressentis, pensees et observations.';

  @override
  String get searchJournalHint => 'Rechercher dans le journal...';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get newEntry => 'Nouvelle note';

  @override
  String get noMatchingNotes => 'Aucune note trouvee';

  @override
  String get journalEmpty => 'Ton journal est vide';

  @override
  String get tryAnotherKeyword => 'Essaie un autre mot-cle.';

  @override
  String get startFirstNote =>
      'Commence ta premiere note privee. Elle reste sur cet appareil.';

  @override
  String get untitledNote => 'Note sans titre';

  @override
  String get noDetailsYet => 'Pas de detail pour l\'instant.';

  @override
  String get delete => 'Supprimer';

  @override
  String get saveEntry => 'Enregistrer';

  @override
  String get writeFreelyHint =>
      'Ecris librement. Cette note reste sur ton appareil.';

  @override
  String get myProfile => 'Mon profil';

  @override
  String get myAccount => 'Mon compte';

  @override
  String get personalInformation => 'Informations personnelles';

  @override
  String get partner => 'Partenaire';

  @override
  String get accountSecurity => 'Compte et securite';

  @override
  String get appSetting => 'Parametres de l\'application';

  @override
  String get settings => 'Parametres';

  @override
  String get notifications => 'Notifications';

  @override
  String get supportLegal => 'Support et mentions legales';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get logOut => 'Se deconnecter';

  @override
  String get cycleProfile => 'Profil du cycle';

  @override
  String get cycleProfileDescription =>
      'Ces parametres sont la source de verite pour calculer tes prochaines regles et tes fenetres de fertilite.';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get selectDate => 'Selectionner une date';

  @override
  String get averageCycleLength => 'Duree moyenne du cycle';

  @override
  String get periodLength => 'Duree des regles';

  @override
  String get lastPeriodStartDate => 'Date du dernier debut de regles';

  @override
  String get regularCycleQuestion => 'Cycle regulier ?';

  @override
  String get regular => 'Regulier';

  @override
  String get irregular => 'Irregulier';

  @override
  String get changesSavedAutomatically =>
      'Les modifications sont enregistrees automatiquement des que tu changes une valeur.';

  @override
  String get unableToLoadProfile => 'Impossible de charger le profil';

  @override
  String daysCount(int count) {
    return '$count jours';
  }

  @override
  String get logSymptoms => 'Ajouter des symptomes';

  @override
  String get quickDailySymptomCapture =>
      'Saisie rapide des symptomes du jour. Appuie sur tout ce qui correspond a ce que tu ressens aujourd\'hui.';

  @override
  String get save => 'Enregistrer';

  @override
  String get sexualActivity => 'Activite sexuelle';

  @override
  String get protectedSex => 'Rapport protege';

  @override
  String get orgasm => 'Orgasme';

  @override
  String get highActivity => 'Activite elevee';

  @override
  String get unprotectedSex => 'Rapport non protege';

  @override
  String get mental => 'Mental';

  @override
  String get breathingExercises => 'Exercices de respiration';

  @override
  String get stress => 'Stress';

  @override
  String get yoga => 'Yoga';

  @override
  String get meditation => 'Meditation';

  @override
  String get discharge => 'Pertes';

  @override
  String get unusual => 'Inhabituel';

  @override
  String get sticky => 'Collant';

  @override
  String get bleeding => 'Saignement';

  @override
  String get heavyBleeding => 'Saignement abondant';

  @override
  String get lowBleeding => 'Saignement leger';

  @override
  String get physicalActivity => 'Activite physique';

  @override
  String get noExercise => 'Pas d\'exercice';

  @override
  String get teamSports => 'Sport collectif';

  @override
  String get cycling => 'Velo';

  @override
  String get gym => 'Salle de sport';

  @override
  String get dancing => 'Danse';

  @override
  String get aerobics => 'Aerobic';

  @override
  String get swimming => 'Natation';

  @override
  String get mood => 'Humeur';

  @override
  String get anxious => 'Anxieuse';

  @override
  String get sad => 'Triste';

  @override
  String get happy => 'Heureuse';

  @override
  String get calm => 'Calme';

  @override
  String get angry => 'En colere';

  @override
  String get energetic => 'Energique';

  @override
  String get confused => 'Confuse';

  @override
  String get depressed => 'Deprimee';

  @override
  String get sharingSettings => 'Parametres de partage';

  @override
  String get chooseWhatToShare => 'Choisir quoi partager';

  @override
  String get manageSharedCycleData =>
      'Tu peux maintenant gerer les donnees et informations de cycle que tu partages ci-dessous.';

  @override
  String get cyclePredictions => 'Predictions du cycle';

  @override
  String get loggedSymptoms => 'Symptomes enregistres';

  @override
  String get periodDates => 'Dates des regles';

  @override
  String get moodEntries => 'Entrees d\'humeur';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get unableToLoadSharingSettings =>
      'Impossible de charger les parametres de partage';

  @override
  String get allowNotifications => 'Autoriser les notifications';

  @override
  String get periodStarting => 'Debut des regles';

  @override
  String get fertileWindow => 'Fenetre fertile';

  @override
  String get ovulationDay => 'Jour d\'ovulation';

  @override
  String get reminders => 'Rappels';

  @override
  String get partnerUpdates => 'Mises a jour du partenaire';

  @override
  String get unableToLoadNotifications =>
      'Impossible de charger les notifications';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Theme';

  @override
  String get cycleSettings => 'Parametres du cycle';

  @override
  String get cycleLength => 'Duree du cycle';

  @override
  String get integrationsSync => 'Integrations et synchronisation';

  @override
  String get connectedApps => 'Applications connectees';

  @override
  String get about => 'A propos';

  @override
  String get privacyPolicy => 'Politique de confidentialite';

  @override
  String get appVersion => 'Version de l\'application';

  @override
  String get unableToLoadSettings => 'Impossible de charger les parametres';

  @override
  String connectedPartnerTitle(String partnerName) {
    return 'Tu es connectee avec $partnerName !';
  }

  @override
  String get yourPartnerFallback => 'ton partenaire';

  @override
  String get partnerConnectedDescription =>
      'Tu peux maintenant gerer les donnees et informations de cycle partagees.';

  @override
  String get statusConnected => 'Statut : connecte';

  @override
  String get manageSharingSettings => 'Gerer les parametres de partage';

  @override
  String get disconnectPartner => 'Deconnecter le partenaire';

  @override
  String get unableToLoadPartner => 'Impossible de charger le partenaire';

  @override
  String disconnectFromPartnerTitle(String partnerName) {
    return 'Se deconnecter de $partnerName ?';
  }

  @override
  String get disconnectWarning =>
      'Cela arretera immediatement tout partage de donnees.';

  @override
  String get cancel => 'Annuler';

  @override
  String get disconnect => 'Deconnecter';

  @override
  String get invitePartner => 'Inviter un partenaire';

  @override
  String get inviteYourPartner => 'Invite ton partenaire';

  @override
  String get partnerInviteDescription =>
      'Nous enverrons un lien d\'invitation securise et prive a ton partenaire.';

  @override
  String get partnerEmailAddress => 'Adresse email du partenaire';

  @override
  String get sendInvitation => 'Envoyer l\'invitation';

  @override
  String get shareLinkManually => 'Partager le lien manuellement';

  @override
  String get invitationSent => 'Invitation envoyee !';

  @override
  String get partnerInvitationSentDescription =>
      'Ton partenaire a recu une invitation a accepter.';

  @override
  String get gotIt => 'J\'ai compris';

  @override
  String get partnerInvitationPendingTitle => 'Tu as invite ton partenaire !';

  @override
  String get partnerInvitationPendingDescription =>
      'Nous te previendrons quand il ou elle acceptera.';

  @override
  String get statusPendingApproval => 'Statut : en attente de validation';

  @override
  String get resendInvitation => 'Renvoyer l\'invitation';

  @override
  String get cancelInvitation => 'Annuler l\'invitation';

  @override
  String get unableToLoadInvitation => 'Impossible de charger l\'invitation';

  @override
  String get yourPartnerIsConnected => 'Ton partenaire est connecte';

  @override
  String get invitationPending => 'Invitation en attente';

  @override
  String get connectWithYourPartner => 'Connecte-toi avec ton partenaire';

  @override
  String get partnerConnectedBody =>
      'Gere ce que ton partenaire peut voir de ton cycle et de ton bien-etre.';

  @override
  String get partnerPendingBody =>
      'Ton invitation a ete envoyee. Tu peux la gerer ou la renvoyer depuis l\'ecran suivant.';

  @override
  String get partnerInviteBody =>
      'Partage en toute securite les dates cles du cycle, les predictions et les fenetres d\'ovulation.';

  @override
  String get manageSharing => 'Gerer le partage';

  @override
  String get viewInvitation => 'Voir l\'invitation';

  @override
  String get learnMore => 'En savoir plus';

  @override
  String get unableToLoadPartnerSettings =>
      'Impossible de charger les parametres du partenaire';

  @override
  String get security => 'Securite';

  @override
  String get setPinLock => 'Definir le verrou PIN';

  @override
  String get changePin => 'Changer le PIN';

  @override
  String get enterPin => 'Saisis le PIN :';

  @override
  String get newPin => 'Nouveau PIN :';

  @override
  String get confirmPin => 'Confirme le PIN :';

  @override
  String get pinsDoNotMatch => 'Les PIN ne correspondent pas';

  @override
  String get enter4Digits => 'Saisis 4 chiffres';

  @override
  String get appLock => 'Verrouillage de l\'application';

  @override
  String get journalLock => 'Verrouillage du journal';

  @override
  String get faceId => 'Face ID';

  @override
  String get changePinButton => 'Changer le PIN';

  @override
  String get disablePinLock => 'Desactiver le verrou PIN';

  @override
  String get unableToLoadSecuritySettings =>
      'Impossible de charger les parametres de securite';

  @override
  String get unableToLoadAccountSettings =>
      'Impossible de charger les parametres du compte';
}
