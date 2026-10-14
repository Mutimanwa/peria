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
  String get fullNameLabel => 'Nom complet';

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
  String get days => 'Jours';

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
  String get journalCloudSync => 'Synchronisation cloud du journal';

  @override
  String get journalSyncDescription =>
      'Par défaut, ton journal reste chiffré sur cet appareil. Si tu l’actives, les notes existantes et futures sont stockées dans ton compte Peria via Firebase Firestore. La copie cloud n’est pas chiffrée de bout en bout par Peria.';

  @override
  String get journalSyncEnabledDescription =>
      'Les notes existantes et nouvelles de cet appareil sont synchronisées avec ton compte Peria dans le cloud.';

  @override
  String get journalSyncDisabledDescription =>
      'La synchronisation cloud est désactivée sur cet appareil. Ton journal reste ici.';

  @override
  String get journalSyncConsentTitle => 'Avant d’activer la synchronisation';

  @override
  String get journalSyncConsentBody =>
      'Si tu acceptes, Peria envoie tes notes existantes et futures — titres, textes, humeurs, dates, étiquettes, références de pièces jointes et autres détails enregistrés — vers ton compte Firebase Firestore. Elles sont stockées dans le cloud et ne sont pas chiffrées de bout en bout par Peria. Firestore peut aussi conserver un cache hors ligne sur cet appareil, distinct de la copie chiffrée dans Hive. Tu peux arrêter la synchronisation à tout moment ; cela ne supprime pas les copies déjà envoyées ni les envois déjà en attente.';

  @override
  String get enableAndSync => 'J’accepte et j’active';

  @override
  String get journalSyncDisableTitle => 'Désactiver la synchronisation ?';

  @override
  String get journalSyncDisableBody =>
      'La désactivation sur cet appareil arrête ses prochains envois automatiques. Les copies déjà stockées dans Firestore, y compris les envois déjà en attente, peuvent rester dans le cloud jusqu’à leur suppression ci-dessous. Ton journal local reste sur cet appareil.';

  @override
  String get turnOffSync => 'Désactiver';

  @override
  String get journalSyncLocalOnly =>
      'La synchronisation est désactivée sur cet appareil. Ton journal local reste ici ; une ancienne copie cloud peut subsister jusqu’à sa suppression.';

  @override
  String get journalSyncNotYet =>
      'Aucune synchronisation cloud réussie pour le moment.';

  @override
  String journalSyncLastSynced(String time) {
    return 'Dernière synchronisation réussie : $time';
  }

  @override
  String get journalSyncFailed =>
      'La dernière synchronisation a échoué. Réessaie lorsque tu seras en ligne.';

  @override
  String get syncNow => 'Synchroniser maintenant';

  @override
  String get journalSyncCompleted => 'Ton journal a été synchronisé.';

  @override
  String get journalSyncError =>
      'Impossible de synchroniser le journal. Tes notes locales restent disponibles.';

  @override
  String get journalSyncSettingsError =>
      'Impossible de modifier le réglage de synchronisation. Réessaie.';

  @override
  String get deleteCloudCopy => 'Supprimer la copie cloud';

  @override
  String get journalCloudDeleteTitle => 'Supprimer la copie cloud ?';

  @override
  String get journalCloudDeleteBody =>
      'Cette action désactive la synchronisation sur cet appareil et supprime les notes stockées dans Firestore pour ce compte. Une connexion Internet est nécessaire. Un autre appareil dont la synchronisation est activée pourra renvoyer des notes. Les notes locales sur cet appareil ne seront pas supprimées.';

  @override
  String get journalCloudDeleteSuccess =>
      'La copie cloud a été supprimée. Ton journal local reste sur cet appareil.';

  @override
  String get journalCloudDeleteError =>
      'Impossible de supprimer la copie cloud. La synchronisation est désactivée ; vérifie ta connexion puis réessaie.';

  @override
  String get journalCloudLegacyCopyNotice =>
      'Si tu as utilisé une ancienne version de Peria, des notes peuvent déjà se trouver dans le cloud. Désactiver la synchronisation ne les supprime pas ; utilise « Supprimer la copie cloud » pour les effacer.';

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
  String get navCycle => 'Cycle';

  @override
  String get navEducation => 'Éducation';

  @override
  String get navJournal => 'Journal';

  @override
  String get notificationGenericTitle => 'Peria';

  @override
  String get notificationGenericBody => 'Un rappel discret t’attend.';

  @override
  String get notificationChannelName => 'Peria';

  @override
  String get notificationChannelDescription => 'Rappels privés de Peria.';

  @override
  String get notificationPrivacyDescription =>
      'Le texte des notifications reste neutre pour protéger les détails de ton cycle sur l’écran verrouillé.';

  @override
  String get notificationScheduleDescription =>
      'Une fois activés, les rappels du cycle sont prévus à 9 h et le rappel quotidien pour noter ses symptômes ou écrire dans le journal à 20 h.';

  @override
  String get notificationPermissionDenied =>
      'Impossible d’activer les notifications. Vérifie qu’elles sont autorisées dans les réglages de ton appareil, puis réessaie.';

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
  String get symptomJournalReminder =>
      'Noter ses symptômes ou écrire dans le journal';

  @override
  String get quickDailySymptomCapture =>
      'Saisie rapide des symptomes du jour. Appuie sur tout ce qui correspond a ce que tu ressens aujourd\'hui.';

  @override
  String get save => 'Enregistrer';

  @override
  String get notes => 'Notes';

  @override
  String get writeHowYouFeelToday => 'Ecris ce que tu ressens aujourd\'hui...';

  @override
  String get intensity => 'Intensite';

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
  String get language => 'Langue de l’application';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSaveError =>
      'Impossible d’enregistrer la langue. Réessaie.';

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
  String get unableToLoadJournal => 'Impossible de charger le journal';

  @override
  String get privateByDefault => 'Privé par défaut sur cet appareil.';

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

  @override
  String get appAccess => 'Acces App';

  @override
  String get confidentiality => 'Confidentialite';

  @override
  String get management => 'Gestion';

  @override
  String get globalSecurity => 'Securite Globale (PIN/FaceID)';

  @override
  String get biometricAuth => 'Authentification Biometrique';

  @override
  String get multitaskProtection => 'Masquage en multitache';

  @override
  String get clearLocalData => 'Supprimer les donnees locales';

  @override
  String get confirmClearData => 'Effacer toutes les donnees ?';

  @override
  String get clearDataWarning =>
      'Cette action est irreversible et supprimera tout votre historique.';

  @override
  String get securityRequired => 'Securite requise';

  @override
  String get globalSecurityRequiredForJournal =>
      'L\'acces securise (PIN/FaceID) doit d\'abord etre active pour proteger le journal.';

  @override
  String get ok => 'OK';

  @override
  String get myDairy => 'C\'est mon journal...';

  @override
  String get aboutYourDay => 'Raconte ta journée...';

  @override
  String get howDoYouFell => 'Comment te sens-tu ?';

  @override
  String get educationGreeting => 'Bonjour Peria';

  @override
  String get educationSpace => 'Votre espace educatif';

  @override
  String get educationWhatToLearn => 'Que voulez-vous apprendre aujourd\'hui ?';

  @override
  String get educationRecentArticles => 'Articles recents';

  @override
  String get educationSearchResults => 'Resultats de recherche';

  @override
  String get searchAction => 'Rechercher';

  @override
  String get cancelAction => 'Annuler';

  @override
  String get educationSearchHint => 'Rechercher un article...';

  @override
  String get educationNoArticleFound => 'Aucun article trouve';

  @override
  String get educationNoArticles => 'Pas d\'articles';

  @override
  String get educationTryAnotherSearch => 'Essayez une autre recherche';

  @override
  String get educationChooseCategory => 'Choisissez une categorie';

  @override
  String get educationHeroTitle => 'Apprendre en douceur';

  @override
  String get educationHeroSubtitle =>
      'Explorez des reponses simples a vos questions les plus frequentes.';

  @override
  String get educationHeroFooter =>
      'Accedez a des reponses claires, etape par etape.';

  @override
  String get educationSuggestionsTitle => 'Suggestions du moment';

  @override
  String get educationSuggestionsSubtitle =>
      'Basees sur votre cycle et vos dernieres entrees.';

  @override
  String get educationArticleNotFound => 'Article non trouve';

  @override
  String get educationArticleSaved => 'Article ajoute aux favoris';

  @override
  String get educationExplanation => 'Explication';

  @override
  String get educationObserve => 'A observer';

  @override
  String get educationAdvice => 'Conseils';

  @override
  String get educationWhenToConsult => 'Quand consulter';

  @override
  String get educationRelatedTags => 'Tags associes';

  @override
  String educationUpdated(String value) {
    return 'Mise a jour : $value';
  }

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyAdvanced => 'Avance';

  @override
  String get educationAxisCycleBasics => 'Comprendre le cycle';

  @override
  String get educationAxisOvulationFertility => 'Ovulation et fertilite';

  @override
  String get educationAxisMenstruationSymptoms => 'Regles et symptomes';

  @override
  String get educationAxisNormalVsAbnormal => 'Normal vs pas normal';

  @override
  String get educationAxisSolutionsWellbeing => 'Solutions et bien-etre';

  @override
  String get educationHealthNoticeTitle =>
      'Information de santé, pas un diagnostic';

  @override
  String get educationHealthNoticeBody =>
      'Ces articles sont des informations générales et ne remplacent pas l’avis d’un professionnel de santé. Demande rapidement de l’aide en cas de symptômes soudains et intenses, d’évanouissement ou de saignements abondants.';

  @override
  String get educationMovementNoticeTitle => 'Les mouvements sont facultatifs';

  @override
  String get educationMovementNoticeBody =>
      'Cette routine vise le bien-être général et ne constitue pas un traitement. Arrête si la douleur augmente ou si tu te sens étourdie ou mal. Demande conseil en cas de symptômes intenses ou inhabituels.';

  @override
  String get todayLabel => 'Aujourd\'hui';

  @override
  String get yesterdayLabel => 'Hier';

  @override
  String daysAgo(int count) {
    return 'Il y a $count jours';
  }

  @override
  String weeksAgo(int count) {
    return 'Il y a $count semaine(s)';
  }

  @override
  String monthsAgo(int count) {
    return 'Il y a $count mois';
  }

  @override
  String get articleHealthyDiet => 'Alimentation saine';

  @override
  String get articleSkinCare => 'Soins de la peau';

  @override
  String get articleYogaTips => 'Conseils de yoga';

  @override
  String get logPeriodButton => 'Noter les règles';

  @override
  String get logPeriodSheetTitle => 'Enregistrer les règles';

  @override
  String get logPeriodSheetSubtitle =>
      'Note rapide du jour. Utilise Modifier le calendrier pour corriger précisément les dates.';

  @override
  String get periodStartedToday => 'Mes règles ont commencé aujourd’hui';

  @override
  String get periodStartedTodaySubtitle =>
      'Enregistrer aujourd’hui comme premier jour des règles.';

  @override
  String get addTodayPeriodDay => 'Ajouter aujourd’hui comme jour de règles';

  @override
  String get addTodayPeriodDaySubtitle =>
      'Enregistrer aujourd’hui et prolonger le dernier journal uniquement si les jours se suivent.';

  @override
  String get periodEndedToday => 'Mes règles se terminent aujourd’hui';

  @override
  String get periodEndedTodaySubtitle =>
      'Terminer un journal commencé aujourd’hui ou hier.';

  @override
  String get openStructuredPeriodEdit =>
      'Ouvrir la modification du calendrier';

  @override
  String get periodLogLoading => 'Chargement des journaux de règles…';

  @override
  String get periodLogSaving => 'Enregistrement du journal de règles…';

  @override
  String get periodLogLoadError =>
      'Impossible de charger les journaux. Réessaie ou utilise Modifier le calendrier.';

  @override
  String get periodLogAlreadyLoggedToday =>
      'Aujourd’hui est déjà enregistré comme jour de règles.';

  @override
  String get periodLogNoRecentToEnd =>
      'Aucun journal d’aujourd’hui ou d’hier à terminer. Utilise Modifier le calendrier pour corriger les dates.';

  @override
  String get periodLogSaveError =>
      'Impossible d’enregistrer le journal. Vérifie ta connexion puis réessaie.';
  @override
  String get update => 'Mettre à jour';

  @override
  String get calendarTitle => 'Calendrier du cycle';

  @override
  String get calendarNoCycleData => 'Aucune donnée de cycle';

  @override
  String get calendarNoCyclePredictionAvailable => 'Aucune prévision de cycle n’est disponible pour cette date.';

  @override
  String get calendarOverdue => 'En retard';

  @override
  String get calendarExpectedNotLogged => 'Tes règles sont attendues mais n’ont pas été enregistrées.';

  @override
  String get calendarLoggedPeriodDay => 'Jour de règles enregistré';

  @override
  String get calendarLoggedPeriodDescription => 'Cette date figure dans ton journal des règles.';

  @override
  String get calendarPredictedPeriodDay => 'Jour de règles prévu';

  @override
  String get calendarPredictedPeriodDescription => 'Cette date est une estimation fondée sur les données de ton cycle.';

  @override
  String get calendarFertilityWindow => 'Fenêtre fertile';

  @override
  String get calendarFertilityWindowDescription => 'Cette date se situe dans la fenêtre fertile estimée.';

  @override
  String get calendarPmsDay => 'Jour de SPM';

  @override
  String get calendarPmsDayDescription => 'Cette date se trouve dans la phase prémenstruelle estimée.';

  @override
  String get calendarSelectedDay => 'Jour sélectionné.';

  @override
  String get calendarRegularDay => 'Jour ordinaire';

  @override
  String get calendarNoTrackedCycleEvent => 'Aucun événement de cycle suivi n’est associé à cette date.';

  @override
  String get calendarMonthlyOverview => 'Aperçu mensuel';

  @override
  String get calendarMonthlyOverviewHelp => 'Consulte l’évolution de ton cycle. Utilise la saisie rapide au quotidien et Modifier le calendrier pour corriger les dates.';

  @override
  String get calendarQuickCapture => 'Saisie rapide';

  @override
  String get calendarQuickCaptureHelp => 'Des actions rapides pour noter tes règles et tes symptômes sans ouvrir l’éditeur détaillé.';

  @override
  String get calendarDateRangeHelp => 'Tu veux définir ou corriger une période ? Utilise Modifier le calendrier.';

  @override
  String get calendarEditTitle => 'Modifier le calendrier';

  @override
  String get calendarStructuredEditTitle => 'Modification détaillée des règles';

  @override
  String get calendarStartDateSelected => 'Date de début sélectionnée';

  @override
  String get calendarPeriodRangeReady => 'Période sélectionnée';

  @override
  String get calendarSelectRangeInstruction => 'Utilise cet écran pour définir ou corriger précisément une période de règles.';

  @override
  String get calendarChooseLastDay => 'Choisis le dernier jour de ces règles.';

  @override
  String get calendarCorrectionHelp => 'Cet écran sert à corriger précisément les dates. Pour une saisie rapide, utilise Noter les règles depuis le calendrier.';

  @override
  String get calendarSavedPeriod => 'Règles enregistrées';

  @override
  String get calendarPredictedPeriodLegend => 'Règles prévues';

  @override
  String get calendarSaveStartDate => 'Enregistrer la date de début';

  @override
  String get calendarSavePeriodRange => 'Enregistrer la période';

  @override
  String get calendarLegendPmsDay => 'Jour de SPM';

  @override
  String get calendarLegendLoggedPeriod => 'Règles enregistrées';

  @override
  String get calendarLegendPredictedPeriod => 'Règles prévues';

  @override
  String get calendarLegendFertilityWindow => 'Fenêtre fertile';

  @override
  String get calendarLegendSymptoms => 'Symptômes';

  @override
  String get calendarLegendJournal => 'Journal';

  @override
  String get calendarLegendToday => 'Aujourd’hui';

  @override
  String get goalTrackPeriod => 'Suivre mes règles';

  @override
  String get goalUnderstandBody => 'Mieux comprendre mon corps';

  @override
  String get goalTrackOvulation => 'Suivre mon ovulation';

  @override
  String get goalHealthInsights => 'Recevoir des informations sur ma santé';

  @override
  String get goalShareDoctor => 'Partager mes données avec mon médecin';

  @override
  String get goalAiGuidance => 'Conseils personnalisés par IA';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get myGoal => 'Mon objectif';

  @override
  String get noGoalsSelected => 'Aucun objectif sélectionné';

  @override
  String get goalsSelected => 'Objectifs sélectionnés';

  @override
  String get helpSearchHint => 'Rechercher…';

  @override
  String get helpContactUs => 'Nous contacter';

  @override
  String get helpFaqLogQuestion => 'Comment noter mes règles et mes symptômes ?';

  @override
  String get helpFaqLogAnswer => 'Ouvre le calendrier du cycle et choisis Noter les règles ou Noter les symptômes. Utilise Modifier le calendrier pour corriger une période.';

  @override
  String get helpFaqDataQuestion => 'Mes données de santé sont-elles protégées ?';

  @override
  String get helpFaqDataAnswer => 'Par défaut, le journal reste sur cet appareil dans un stockage chiffré; sa synchronisation cloud est facultative et exige un consentement distinct. Les données du profil, du cycle, des symptômes, du partenaire et des réglages utilisent Firebase. Consulte la politique de confidentialité pour les détails et les limites actuelles de suppression.';

  @override
  String get helpFaqPartnerQuestion => 'Comment fonctionne le partage avec un partenaire ?';

  @override
  String get helpFaqPartnerAnswer => 'Cette version conserve l’adresse du partenaire et les préférences de partage dans ton compte Firebase. Elle n’envoie pas encore d’invitation et ne transmet pas les données de cycle ou de symptômes au partenaire.';

  @override
  String get helpFaqNotificationsQuestion => 'Comment personnaliser les notifications ?';

  @override
  String get helpFaqNotificationsAnswer => 'Ouvre Profil, puis Paramètres et Notifications pour choisir les rappels locaux à activer.';

  @override
  String get helpFaqDeleteQuestion => 'Comment supprimer mon compte ou mes données ?';

  @override
  String get helpFaqDeleteAnswer => 'Tu peux effacer les données locales dans Profil > Sécurité du compte et supprimer une copie cloud facultative du journal dans Paramètres > Synchronisation du journal. Cette version ne permet pas encore de supprimer dans l’application le compte Firebase et toutes les autres données cloud. Avant toute diffusion publique, l’éditeur doit fournir un contact de confidentialité vérifié.';

  @override
  String get helpFaqSupportQuestion => 'Comment contacter le support ?';

  @override
  String get helpFaqSupportAnswer => 'Utilise les options de contact au bas de cette page.';


  @override
  String get securityIncorrectPin => 'Code PIN incorrect.';

  @override
  String get securityAuthenticationSuccess => 'Authentification réussie';

  @override
  String get securityPinRequired => 'Code PIN requis';

  @override
  String get securityAuthenticationError => 'Échec de l’authentification. Réessaie.';

  @override
  String get securitySkipDevelopmentOnly => 'Ignorer (développement uniquement)';

  @override
  String get securityRetry => 'Réessayer';

  @override
  String securityLockedFor(int minutes, int seconds) =>
      'Verrouillé pendant $minutes min $seconds s';

  @override
  String get journalNoEntryForDay => 'Aucune note pour ce jour';

  @override
  String get journalQuickLogPrompt => 'Utilise la saisie rapide pour noter ce moment.';

  @override
  String get moodCalm => 'Calme';

  @override
  String get moodHappy => 'Heureuse';

  @override
  String get moodExcited => 'Enthousiaste';

  @override
  String get moodAnxious => 'Anxieuse';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodTired => 'Fatiguée';


  @override
  String get journalDeleteMemoryTitle => 'Supprimer ce souvenir ?';

  @override
  String get journalDeleteMemoryBody => 'Cette action est définitive et ne peut pas être annulée.';

  @override
  String get journalTimeline => 'Chronologie';

  @override
  String get journalSearchAllMoods => 'Toutes les humeurs';

  @override
  String get journalFavorites => 'Favoris';

  @override
  String get journalDateFilter => 'Date';

  @override
  String get journalSearchNoResults => 'Aucun résultat';

  @override
  String get journalFilterByMood => 'Filtrer par humeur';

  @override
  String get journalAllFilter => 'Tout';

  @override
  String get journalCurrentStreak => 'Série actuelle';

  @override
  String get journalMoodDistribution => 'Répartition des humeurs';

  @override
  String get journalWeeklyActivity => 'Activité hebdomadaire';

  @override
  String get journalTopTags => 'Tags principaux';

  @override
  String get journalInsightsNotEnoughData => 'Pas encore assez de données pour afficher des tendances 🌿';

  @override
  String get journalQuickThought => 'Note rapide';

  @override
  String get journalWrite => 'Écrire';

  @override
  String get journalQuickThoughtHint => 'Qu’as-tu en tête ?';

  @override
  String get journalCaptureMoment => 'Appuie pour noter un instant…';

  @override
  String get journalQuickThoughtSaved => 'Note rapide enregistrée 😌';

  @override
  String get journalStreak => 'Série';

  @override
  String get journalInsights => 'Tendances';

  @override
  String get journalWeekly => 'Cette semaine';

  @override
  String get journalRecentEntries => 'Notes récentes';

  @override
  String get journalSeeAll => 'Tout voir';

  @override
  String get journalNoEntriesYet => 'Aucune note pour le moment';

  @override
  String get journalPhotoGallery => 'Choisir dans la galerie';

  @override
  String get journalTakePhoto => 'Prendre une photo';

  @override
  String get journalImageAdded => 'Image ajoutée au journal.';

  @override
  String get journalAudioComingSoon => 'L’enregistrement audio sera bientôt disponible.';

  @override
  String get journalMoodQuestion => 'Comment te sens-tu ?';

  @override
  String journalNoteCount(int count) => '$count ${count == 1 ? 'note' : 'notes'}';

  @override
  String journalStreakCount(int count) => '$count ${count == 1 ? 'jour' : 'jours'}';

  @override
  String get selectDateRange => 'Sélectionner une période';

  @override
  String get journalEditAction => 'Modifier';

  @override
  String get journalQuietMoment => 'Un instant paisible';

  @override
  String get journalLockedTitle => 'Le journal est verrouillé';

  @override
  String get journalLockedDescription => 'Saisis ton code PIN ou utilise la biométrie pour accéder à tes notes privées.';

  @override
  String get journalUseBiometrics => 'Utiliser la biométrie';

  @override
  String get journalUnlockReason => 'Déverrouiller ton journal privé';

  @override
  String get securityBiometricFailed => 'Échec de l’authentification biométrique. Réessaie ou saisis ton code PIN.';

  @override
  String get journalSaveError => 'Impossible d’enregistrer ta note. Réessaie.';

  @override
  String get journalDailyQuote => '« Chaque instant est un nouveau départ. »';

  @override
  String educationReadingTime(int minutes) => 'environ $minutes min de lecture';

  @override
  String get selfCarePrompt => 'Que souhaites-tu découvrir aujourd’hui ?';

  @override
  String get selfCareFilterAll => 'Tout';

  @override
  String get selfCareFilterCramps => 'Soulager les crampes';

  @override
  String get selfCareFilterStrength => 'Force et souplesse';

  @override
  String get selfCareFilterFacial => 'Soins du visage';

  @override
  String get selfCareCategoryCramps => 'Mouvements doux contre les crampes';

  @override
  String get selfCareCategoryStrength => 'Force et souplesse';

  @override
  String get selfCareCategoryFacial => 'Soins du visage';

  @override
  String get selfCareCategoryStretching => 'Étirements relaxants';

  @override
  String get selfCareCategoryArticles => 'Articles';

  @override
  String get selfCareBadgeGetStarted => 'Commencer';

  @override
  String get selfCareCardBalance => 'Équilibre';

  @override
  String get selfCareCardFocus => 'Concentration';

  @override
  String get selfCareCardStrength => 'Renforcement';

  @override
  String get selfCareCardFlexibility => 'Souplesse';

  @override
  String get selfCareCardGentleFacialMassage => 'Massage doux du visage';

  @override
  String get selfCareCardGlowSkin => 'Révéler l’éclat de ta peau';

  @override
  String get selfCareCardNeckPainRelief => 'Soulager les tensions du cou';

  @override
  String get selfCareCardLowerBackStretch => 'Étirement du bas du dos';

  @override
  String get selfCareCardPeriodPainRelief => 'Soulager les douleurs de règles';

  @override
  String get selfCareSubtitleGentleYoga => 'Yoga doux pour relâcher les tensions';

  @override
  String get selfCareSubtitleBreathingRelease => 'Respiration et relâchement lent';

  @override
  String get selfCareSubtitleMobilityComfort => 'Mobilité et confort au quotidien';

  @override
  String get selfCareSubtitleLiftSculpt => 'Lisser et tonifier en douceur';

  @override
  String get selfCareSubtitleCleanseHydrate => 'Nettoyer et hydrater';

  @override
  String get selfCareSubtitleReleaseUpperBody => 'Relâcher les tensions du haut du corps';

  @override
  String get selfCareSubtitleSlowRestorative => 'Mouvements lents et réparateurs';

  @override
  String get selfCareDeepSleepMeditation => 'Méditation pour un sommeil profond';

  @override
  String get selfCarePlay => 'Lire';

  @override
  String get selfCareNeedYogaPillow => 'Coussin de yoga';

  @override
  String get selfCareNeedWaterBottle => 'Bouteille d’eau';

  @override
  String get selfCareNeedYogaMat => 'Tapis de yoga';

  @override
  String get selfCareStepChinToChest => 'Menton vers la poitrine';

  @override
  String get selfCareStepReclineReset => 'Posture allongée relaxante';

  @override
  String get selfCareStepSupportedPigeon => 'Posture du pigeon avec soutien';

  @override
  String get selfCareStepButterflyFold => 'Posture du papillon penché';

  @override
  String get selfCareStepLotusLift => 'Élévation en lotus';

  @override
  String get selfCareStepLegsUpWall => 'Jambes contre le mur';

  @override
  String get selfCareStepNeckLift => 'Étirement du cou';

  @override
  String get selfCareStepGuaShaMassage => 'Massage au gua sha';

  @override
  String get selfCareStepFacialCleansing => 'Nettoyage du visage';

  @override
  String get selfCareStepGlowPress => 'Pressions éclat';

  @override
  String get selfCareStepHydrationLock => 'Sceller l’hydratation';

  @override
  String get selfCareSubtitleChinUpward => 'Menton vers le haut';

  @override
  String get selfCareSubtitleSweepOutward => 'Faire glisser doucement vers l’extérieur';

  @override
  String get selfCareSubtitleGentlyCleanse => 'Nettoyer le visage en douceur';

  @override
  String get selfCareSubtitleLightCircular => 'Mouvements circulaires légers';

  @override
  String get selfCareSubtitleSealMoisture => 'Préserver l’hydratation';

  @override
  String get selfCareSleepTrackCalmFlow => 'Flux apaisant';

  @override
  String get selfCareSleepTrackBreathOfLife => 'Le souffle de la vie';

  @override
  String get selfCareSleepTrackSoulDrift => 'Dérive de l’âme';

  @override
  String get selfCareSleepTrackSoundsSerenity => 'Sons de sérénité';

  @override
  String get selfCareSleepTrackInnerPeace => 'Paix intérieure';

  @override
  String get selfCareSleepTrackMindfulJourney => 'Voyage en pleine conscience';

  @override
  String get selfCareSleepTrackWhisperingNature => 'Les murmures de la nature';

  @override
  String get selfCareSleepTrackNaturesRhythm => 'Le rythme de la nature';

  @override
  String get selfCareSleepTrackGoldenDawn => 'Aube dorée';

  @override
  String get selfCareSleepTrackHarmonyWithin => 'Harmonie intérieure';

  @override
  String get selfCareSleepTrackBreatheInSilence => 'Respirer en silence';

  @override
  String get selfCareSleepTrackDeepRestSession => 'Séance de repos profond';

  @override
  String get selfCareAlignMindBody => 'Aligner le corps et l’esprit';

  @override
  String get selfCareActivityDescription => 'Mouvements doux et facultatifs, avec un coussin si tu le souhaites. Le confort et les effets varient selon les personnes.';

  @override
  String get selfCareYouWillNeed => 'Tu auras besoin de';

  @override
  String get selfCareStart => 'C’est parti';

  @override
  String get selfCareExerciseJumpingJacks => 'Sauts avec écart';

  @override
  String get selfCareFullBodyCardio => 'Cardio pour tout le corps';

  @override
  String get selfCareWait => 'Attends !';

  @override
  String get selfCareQuit => 'Quitter';

  @override
  String get selfCareKeepGoing => 'Continuer';

  @override
  String get selfCareStartExercises => 'Commencer les exercices';

  @override
  String get selfCareGentleMovementTitle => 'Mouvements doux';

  @override
  String get selfCareGentleMovementDescription => 'Des mouvements doux et facultatifs peuvent apporter du confort à certaines personnes. Arrête si la douleur augmente, si tu as des vertiges ou si tu ne te sens pas bien.';

  @override
  String get selfCareCongratulations => 'Bravo !';

  @override
  String get selfCareCongratulationsMessage => 'Tu as terminé ta séance de bien-être et pris soin de ton corps aujourd’hui.';

  @override
  String get selfCareBackHome => 'Retour à l’accueil';

  @override
  String get selfCareArticleTitle => 'Douleurs de règles : gestes doux et quand demander de l’aide';

  @override
  String get selfCareArticleLead => 'Les crampes sont fréquentes, mais une douleur intense, nouvelle ou gênante mérite attention.';

  @override
  String get selfCareArticleComfortHeading => 'Gestes doux pour plus de confort :';

  @override
  String get selfCareArticleWarmCompress => 'Une compresse chaude ou des mouvements doux peuvent aider certaines personnes.';

  @override
  String get selfCareArticleRest => 'Repose-toi si tu en as besoin ; arrête une activité si la douleur ou les vertiges augmentent.';

  @override
  String get selfCareArticleVaries => 'Ce qui aide varie d’une personne à l’autre.';

  @override
  String get selfCareArticleMedicineHeading => 'À propos des médicaments :';

  @override
  String get selfCareArticleMedicineRisks => 'Les antidouleurs ne conviennent pas à tout le monde et peuvent présenter des risques ou des interactions.';

  @override
  String get selfCareArticlePharmacist => 'Demande à un pharmacien ou à un professionnel de santé qualifié ce qui te convient.';

  @override
  String get selfCareArticleFollowLabel => 'Suis la notice du produit. Cet article ne recommande aucun médicament ni aucune dose.';

  @override
  String get selfCareArticleSeekHelpHeading => 'Quand demander de l’aide :';

  @override
  String get selfCareArticleDailyLife => 'Prends rendez-vous si la douleur perturbe régulièrement tes études, ton travail, ton sommeil ou tes activités.';

  @override
  String get selfCareArticleUrgent => 'Demande une aide urgente en cas de douleur soudaine et intense, d’évanouissement, de fièvre, ou de douleur avec saignement si une grossesse est possible.';

  @override
  String get selfCareArticleEncouragement => 'Tu mérites d’être aidée. Une douleur qui perturbe le quotidien doit être prise au sérieux.';

  @override
  String get selfCareAddComment => 'Ajouter un commentaire';

  @override
  String get selfCareFeedbackThanks => 'Merci pour ton retour !';

  @override
  String get selfCareFeedbackReceived => 'Retour reçu. Nous ferons de notre mieux pour améliorer ton expérience.';

  @override
  String get selfCareOk => 'OK';

  @override
  String get selfCareSleepMeditationTitle => 'Méditation du sommeil';

  @override
  String get selfCareRelax => 'Se détendre';

  @override
  String get selfCarePeaceRelaxation => 'Paix et détente';

  @override
  String get selfCareTimes => 'fois';

  @override
  String get selfCarePrevious => 'Précédent';

  @override
  String get selfCareNext => 'Suivant';

  @override
  String selfCareMinutes(int minutes) => '$minutes min';

  @override
  String selfCareRound(int round) => 'Série $round';

  @override
  String selfCareOnlyMinutesLeft(int minutes) => 'Plus que $minutes minutes — continue comme ça !';

  @override
  String selfCareLowImpactExercises(int count) => '$count exercices à faible impact';

  @override
  String selfCareMinutesRead(int minutes) => '$minutes min de lecture';

  @override
  String selfCareArticleReadTime(int minutes) => '$minutes min de lecture';

  @override
  String get cyclePhasePeriod => "Menstruation";
  @override
  String get cyclePhaseLuteal => "Phase lutéale";
  @override
  String get cyclePhaseOvulation => "Ovulation";
  @override
  String get cyclePhaseFollicular => "Phase folliculaire";
  @override
  String get authPasswordResetSuccess => "Mot de passe réinitialisé";
  @override
  String get authPasswordResetSuccessMessage => "Votre mot de passe a été mis à jour. Vous pouvez maintenant vous connecter avec votre nouveau mot de passe.";
  @override
  String get aiChatCheckingIn => "Bonjour, je voulais prendre de tes nouvelles.";
  @override
  String get aiChatPmsQuestion => "Comment te sens-tu ces derniers temps pendant les jours précédant tes règles ?";
  @override
  String get aiChatCrampsOrAches => "Crampes ou douleurs corporelles";
  @override
  String get aiChatPhaseVariation => "Je comprends. Cette phase est vécue différemment par chacune.";
  @override
  String get aiChatFocusQuestion => "As-tu généralement du mal à te concentrer ou à accomplir tes tâches ces jours-ci ?";
  @override
  String get aiChatYesALot => "Oui, beaucoup";
  @override
  String get aiChatGentleSuggestions => "Voici quelques idées douces pour retrouver ton équilibre.";
  @override
  String get aiSuggestionDrinkWater => "Boire de l’eau";
  @override
  String get aiSuggestionMoveGently => "Bouger en douceur";
  @override
  String get aiSuggestionTakePause => "Faire une pause";
  @override
  String get aiChatLearnMore => "Veux-tu en apprendre un peu plus à ce sujet ?";
  @override
  String get aiChatImCurious => "Oui, je suis curieuse";
  @override
  String get aiChatArticlePrompt => "Voici un article que tu peux lire.";
  @override
  String get aiChatIReadIt => "Je l’ai lu";
  @override
  String get aiChatSymptomsPrompt => "J’ai présélectionné tes symptômes. Est-ce correct ou souhaites-tu en ajouter ?";
  @override
  String get aiChatSymptomsConfirmed => "Oui, ça me convient !";
  @override
  String get aiChatSetSymptomsTitle => "Tes symptômes sont prêts";
  @override
  String get aiChatOpenSymptoms => "Voir les symptômes";
  @override
  String get aiChatArticleTitle => "Des crampes qui persistent";
  @override
  String get aiChatArticleSubtitle => "Quand les douleurs menstruelles sortent de l’ordinaire.";
  @override
  String get aiChatArticleDescription => "Découvre pourquoi les crampes peuvent persister et quand demander de l’aide. Explore des moyens doux qui peuvent soulager l’inconfort.";
  @override
  String get aiChatReadNow => "Lire maintenant";
  @override
  String get aiChatAfterPmsSupport => "Nous savons que ces journées peuvent être difficiles. Tu n’es pas seule.";
  @override
  String get aiChatCalendarPmsDoctor => "Ton calendrier indique des jours de SPM du 13 au 17 et un rendez-vous médical le 18.";
  @override
  String get aiChatSuggestDate => "Je te propose plutôt le 19. Qu’en penses-tu ?";
  @override
  String get aiChatAssistantLabel => "Ton assistant";
  @override
  String get aiChatPmsConflict => "Conflit avec un jour de SPM";
  @override
  String get aiChatDoctorVisitConflict => "Conflit avec un rendez-vous médical";
  @override
  String get aiChatAskAnything => "Pose ta question…";
  @override
  String get appointmentConfirmed => "Rendez-vous confirmé !";
  @override
  String appointmentBooked(String doctor) => 'Ton rendez-vous avec le Dr $doctor est confirmé.';
  @override
  String appointmentReviewCount(int count) => '$count avis';
  @override
  String get appointmentGynecologist => "Gynécologue";
  @override
  String get appointmentGynOncologyFocus => "Spécialisé en dépistage oncologique gynécologique";
  @override
  String get appointmentVideoConsultation => "Consultation vidéo";
  @override
  String get appointmentDoneBackToChat => "Terminer et revenir à la conversation";
  @override
  String get aiChatSymptomCramps => "Crampes";
  @override
  String get aiChatSymptomHeadache => "Mal de tête";
  @override
  String get periodLogSheetTitle => "Enregistrer tes règles";
  @override
  String get periodLogSheetSubtitle => "Choisis l’action qui correspond le mieux à aujourd’hui.";
}
