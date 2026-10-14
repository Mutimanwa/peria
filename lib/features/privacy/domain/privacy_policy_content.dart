class PrivacyPolicySection {
  const PrivacyPolicySection({
    required this.title,
    this.paragraphs = const [],
    this.bullets = const [],
  });

  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
}

/// Product-facing privacy text for the data flows present in this app build.
class PrivacyPolicyContent {
  const PrivacyPolicyContent({
    required this.title,
    required this.versionAndDate,
    required this.introduction,
    required this.acceptancePrompt,
    required this.journalSyncNotice,
    required this.continuingLabel,
    required this.continueFailedMessage,
    required this.sections,
  });

  final String title;
  final String versionAndDate;
  final String introduction;
  final String acceptancePrompt;
  final String journalSyncNotice;
  final String continuingLabel;
  final String continueFailedMessage;
  final List<PrivacyPolicySection> sections;

  static PrivacyPolicyContent forLanguageCode(String languageCode) {
    return languageCode.toLowerCase().startsWith('fr')
        ? _french
        : _english;
  }

  static const PrivacyPolicyContent _french = PrivacyPolicyContent(
    title: 'Politique de confidentialité',
    versionAndDate: 'Version 1.1 · Mise à jour le 14 octobre 2026',
    introduction:
        'Cette page décrit les données traitées par la version actuelle de Peria, leurs lieux de stockage et les choix disponibles. Les informations sur le cycle, les symptômes et la santé sont sensibles : ne renseigne que ce que tu souhaites conserver. Peria est un outil de suivi et de bien-être, pas un service médical.',
    acceptancePrompt:
        'J’ai lu cette politique et j’accepte le traitement des données qui y est décrit pour utiliser Peria.',
    journalSyncNotice:
        'Cette acceptation n’active pas la synchronisation cloud du journal. Elle reste facultative, désactivée par défaut et nécessite un accord séparé dans Paramètres > Synchronisation du journal.',
    continuingLabel: 'Patiente…',
    continueFailedMessage:
        'Impossible de continuer. Vérifie ta connexion et réessaie ; aucun compte n’est créé tant que l’acceptation n’a pas été enregistrée.',
    sections: [
      PrivacyPolicySection(
        title: '1. Données traitées',
        paragraphs: [
          'Les données sont associées à un identifiant Firebase propre à ton compte. Un compte anonyme est créé uniquement après ta confirmation de cette politique.',
        ],
        bullets: [
          'Compte : identifiant Firebase (UID), statut anonyme ou non, dates de création et de dernière connexion. Si tu relies un compte à une adresse e-mail, cette adresse est traitée par Firebase Authentication et enregistrée dans le profil Peria. Le mot de passe est géré par Firebase Authentication et n’est pas enregistré dans le document de profil Peria.',
          'Profil et cycle : nom affiché, date de naissance, adresse e-mail si renseignée, objectifs, durée moyenne et régularité du cycle, durée des règles, date des dernières règles et journaux de règles (dates de début/fin et indication estimée). L’âge et les prévisions de cycle sont calculés à partir de ces informations.',
          'Symptômes : date du journal, choix renseignés dans les catégories activité sexuelle, état mental, pertes/saignements, activité physique et humeur, ainsi que l’intensité et les notes libres. Dans cette version, ces journaux sont lus et enregistrés dans Cloud Firestore sous ton compte.',
          'Journal : titre, texte, humeur, tags, intensité, favoris, indicateur privé, dates de création/modification, niveaux d’énergie et de stress, et, lorsque ces champs sont utilisés, libellé de lieu ou références de pièces jointes. Le formulaire actuel ne demande pas la position GPS et ne téléverse pas de fichier image séparément.',
          'Partenaire : adresse e-mail saisie, état de l’invitation/connexion et préférences de partage (prédictions, règles, symptômes et humeur). Ces réglages sont conservés dans Firestore sous ton compte.',
          'Préférences : réglages de rappels/notifications et indicateurs de configuration de l’application (par exemple mode discret, Face ID ou authentification à deux facteurs) enregistrés dans le document de paramètres Firestore. Le choix de langue anglais/français est conservé séparément dans les préférences locales de l’appareil et n’est pas transmis à Firebase.',
          'Sécurité locale : le code PIN n’est pas conservé en clair par le service de sécurité actif ; son empreinte et son sel, la clé de chiffrement locale et les réglages de verrouillage sont conservés dans le stockage sécurisé du système. Les données biométriques restent gérées par le système d’exploitation.',
        ],
      ),
      PrivacyPolicySection(
        title: '2. Stockage et prestataires',
        paragraphs: [
          'Les données de compte, de profil, de cycle, de symptômes, de partenaire et de préférences décrites ci-dessus sont envoyées à Firebase Authentication et/ou Cloud Firestore de Google, puis rattachées à ton UID. La région du projet Firebase n’est pas indiquée dans le code de l’application ; son choix relève de la configuration du projet Peria.',
          'Les entrées du journal sont conservées localement dans une base Hive chiffrée avec une clé gardée dans le stockage sécurisé de l’appareil. Lors d’une mise à niveau ancienne, une cache Hive historique non chiffrée peut être conservée sur l’appareil si la migration échoue, afin de ne pas perdre les notes ; Effacer les données locales supprime aussi cette cache. L’acceptation de la présente politique (version et date) est enregistrée sur cet appareil dans les préférences locales ; elle n’est pas utilisée pour activer la synchronisation du journal.',
          'Google/Firebase peut aussi traiter les informations techniques nécessaires au fonctionnement, à la sécurité et à l’authentification de ses services, conformément à ses propres conditions et politiques. Le code actuel n’intègre pas de régie publicitaire ni de SDK d’analyse comportementale.',
        ],
      ),
      PrivacyPolicySection(
        title: '3. Journal : local par défaut, synchronisation facultative',
        paragraphs: [
          'Le journal reste local par défaut. Il n’est ni lu ni écrit dans Firestore tant que tu n’as pas activé la synchronisation dans Paramètres > Synchronisation du journal et confirmé le dialogue de consentement distinct. Cette décision est indépendante de la case cochée sur Welcome.',
          'Si tu actives cette fonction, les champs du journal décrits plus haut sont synchronisés dans Firestore pour le compte concerné, y compris les entrées dont l’indicateur « privé » est activé. La copie cloud n’est pas chiffrée de bout en bout par Peria. Désactiver la synchronisation arrête les nouveaux échanges depuis cet appareil mais ne supprime pas à elle seule la copie déjà présente ; l’écran de synchronisation propose une action séparée pour supprimer la copie cloud.',
        ],
      ),
      PrivacyPolicySection(
        title: '4. Rappels et partage avec un partenaire',
        paragraphs: [
          'Les préférences de notification sont enregistrées dans Firestore. Les rappels eux-mêmes sont planifiés localement sur l’appareil, après activation et autorisation du système. Leur contenu est générique ; aucun service de notification push distant n’a été trouvé dans cette version.',
          'L’écran partenaire enregistre l’adresse saisie et les choix de partage dans Firestore. Dans le code actuel, aucun envoi réel d’invitation par e-mail ni aucun transfert des règles, symptômes, prédictions ou entrées d’humeur à un partenaire n’est implémenté. La case de Welcome ne constitue donc pas un accord de partage avec un partenaire. Toute fonction de partage effective devra être déclenchée séparément et expliquer les données transmises.',
        ],
      ),
      PrivacyPolicySection(
        title: '5. Écrans de démonstration et traitements automatisés',
        paragraphs: [
          'Les calculs de phase et de prévision du cycle sont effectués dans l’application à partir des paramètres et journaux renseignés ; ce sont des estimations, pas un diagnostic ni une garantie de contraception ou de fertilité.',
          'Dans cette version, les écrans de discussion IA, de conversation vocale et de rendez-vous affichent des contenus de démonstration. Aucun appel à un modèle d’IA, enregistrement de voix ou service de réservation médicale n’a été trouvé dans leur code ; les exemples affichés ne sont pas tes conversations.',
        ],
      ),
      PrivacyPolicySection(
        title: '6. Choix et suppression',
        paragraphs: [
          'Tu peux modifier les informations de profil et les réglages dans l’application, refuser l’autorisation de notifications dans le système et désactiver la synchronisation facultative du journal. Tu peux effacer les données locales depuis Sécurité du compte > Effacer les données locales. Cette action ne supprime pas les documents de profil, de cycle, de symptômes ou de paramètres déjà enregistrés dans Firestore.',
          'La copie cloud du journal peut être supprimée depuis l’écran Synchronisation du journal. Cette version ne fournit pas encore de procédure intégrée pour supprimer en une fois le compte Firebase et toutes les autres données cloud ; le dépôt ne définit pas non plus de durée de conservation distante. La désinstallation de l’application ne garantit pas la suppression des données conservées dans Firebase.',
        ],
      ),
      PrivacyPolicySection(
        title: '7. Responsable et contact',
        paragraphs: [
          'Le dépôt de cette version ne précise pas l’identité juridique de l’éditeur, son adresse ni une adresse de contact dédiée à la confidentialité. Ces coordonnées et la procédure de demande d’accès ou de suppression doivent être ajoutées par l’éditeur avant toute diffusion publique. La localisation et la durée de conservation du projet Firebase doivent également être confirmées dans sa console de configuration.',
        ],
      ),
      PrivacyPolicySection(
        title: '8. Modifications',
        paragraphs: [
          'Si cette politique change de manière importante, sa version sera mise à jour. Peria demandera alors une nouvelle confirmation avant de laisser accéder aux autres écrans de l’application.',
        ],
      ),
    ],
  );

  static const PrivacyPolicyContent _english = PrivacyPolicyContent(
    title: 'Privacy Policy',
    versionAndDate: 'Version 1.1 · Updated October 14, 2026',
    introduction:
        'This page describes the data processed by the current version of Peria, where it is stored, and the choices available to you. Cycle, symptom, and health information is sensitive; enter only what you want to keep. Peria is a tracking and wellbeing tool, not a medical service.',
    acceptancePrompt:
        'I have read this policy and agree to the processing described here in order to use Peria.',
    journalSyncNotice:
        'Accepting this policy does not enable journal cloud sync. Sync is optional, off by default, and requires separate consent in Settings > Journal Sync.',
    continuingLabel: 'Please wait…',
    continueFailedMessage:
        'Could not continue. Check your connection and try again; an account is not created unless your acceptance has been saved.',
    sections: [
      PrivacyPolicySection(
        title: '1. Data processed',
        paragraphs: [
          'Data is associated with a Firebase identifier for your account. An anonymous account is created only after you confirm this policy.',
        ],
        bullets: [
          'Account: Firebase identifier (UID), anonymous/non-anonymous status, account creation and last-login timestamps. If you link an email address, Firebase Authentication processes it and Peria stores it in your profile. Firebase Authentication handles the password; Peria does not store it in the profile document.',
          'Profile and cycle: display name, date of birth, email if entered, goals, average cycle length and regularity, period length, last-period date, and period logs (start/end dates and whether a date is estimated). Age and cycle predictions are derived from this information.',
          'Symptoms: log date, entries in the sexual activity, mental wellbeing, discharge/bleeding, physical activity, and mood categories, plus intensity and free-text notes. In this version, these logs are read from and written to Cloud Firestore under your account.',
          'Journal: title, text, mood, tags, intensity, favorites, private flag, creation/update dates, energy and stress levels, and, when those fields are used, a location label or attachment references. The current form does not request GPS location or separately upload image files.',
          'Partner: entered email address, invitation/connection status, and sharing preferences for predictions, periods, symptoms, and mood. These settings are stored in Firestore under your account.',
          'Preferences: notification/reminder choices and app-configuration flags (for example, discreet mode, Face ID, or two-factor authentication) stored in the Firestore settings document. Your English/French language choice is stored separately in local device preferences and is not sent to Firebase.',
          'Local security: the active security service does not keep your PIN in plain text; its hash and salt, the local encryption key, and lock settings are stored in the device secure-storage facility. Biometric data remains managed by the operating system.',
        ],
      ),
      PrivacyPolicySection(
        title: '2. Storage and service providers',
        paragraphs: [
          'The account, profile, cycle, symptom, partner, and preference data described above is sent to Google Firebase Authentication and/or Cloud Firestore and associated with your UID. The Firebase project region is not specified in the app code; it depends on the Peria project configuration.',
          'Journal entries are stored locally in a Hive database encrypted with a key held in the device secure-storage facility. On a legacy installation, an older unencrypted Hive cache may be kept on the device if migration fails, to avoid losing entries; Clear Local Data removes that cache as well. Acceptance of this policy (version and timestamp) is stored in local device preferences; it is not used to enable journal sync.',
          'Google/Firebase may also process technical information needed to operate, secure, and authenticate its services under its own terms and privacy policies. The current code does not include an advertising network or behavioral analytics SDK.',
        ],
      ),
      PrivacyPolicySection(
        title: '3. Journal: local by default, optional sync',
        paragraphs: [
          'The journal stays local by default. Peria does not read or write journal entries in Firestore until you enable sync in Settings > Journal Sync and confirm its separate consent dialog. This choice is independent of the Welcome checkbox.',
          'If you enable this feature, the journal fields described above are synced to Firestore for the relevant account, including entries whose private flag is on. The cloud copy is not end-to-end encrypted by Peria. Turning sync off stops new sync activity from this device, but does not by itself delete an existing cloud copy; the Journal Sync screen provides a separate cloud-copy deletion action.',
        ],
      ),
      PrivacyPolicySection(
        title: '4. Reminders and partner sharing',
        paragraphs: [
          'Notification preferences are stored in Firestore. Reminders themselves are scheduled locally on your device after you enable them and grant operating-system permission. Their content is generic; this version has no remote push-notification service.',
          'The partner screen stores the entered email address and sharing choices in Firestore. The current code does not implement sending an invitation email or transferring period, symptom, prediction, or mood entries to a partner. The Welcome checkbox is not consent to partner sharing. Any actual sharing feature must be separately enabled and explain which data it sends.',
        ],
      ),
      PrivacyPolicySection(
        title: '5. Demo screens and automated processing',
        paragraphs: [
          'Cycle phase and prediction calculations run in the app using the profile and logs you enter. They are estimates, not a diagnosis or a guarantee of contraception or fertility.',
          'In this version, the AI chat, voice-conversation, and appointment screens show demonstration content. Their code contains no call to an AI model, voice recording, or medical-booking service; the displayed examples are not your conversations.',
        ],
      ),
      PrivacyPolicySection(
        title: '6. Your choices and deletion',
        paragraphs: [
          'You can edit profile information and settings in the app, deny notification permission in your operating system, and turn off optional journal sync. You can clear local data under Account Security > Clear Local Data. That action does not delete profile, cycle, symptom, or settings documents already stored in Firestore.',
          'The journal cloud copy can be deleted from the Journal Sync screen. This version does not yet provide an in-app process to delete the Firebase account and all other cloud data at once, and the repository does not define a remote retention period. Uninstalling the app does not guarantee deletion of data held in Firebase.',
        ],
      ),
      PrivacyPolicySection(
        title: '7. Publisher and contact',
        paragraphs: [
          'The repository for this version does not identify the publisher’s legal entity or address, or provide a dedicated privacy contact. The publisher must add those details and an access/deletion-request process before public release. The Firebase project location and retention settings also need to be confirmed in its configuration console.',
        ],
      ),
      PrivacyPolicySection(
        title: '8. Changes',
        paragraphs: [
          'If this policy changes materially, its version will be updated. Peria will then ask you to confirm the new version before allowing access to the rest of the app.',
        ],
      ),
    ],
  );
}
