# Peria — audit complet de l'application

État au 12 novembre 2026, après les quatre lots de la PR #10 (comptes, accessibilité,
performance, contrastes). Toutes les constatations ci-dessous sont vérifiables dans le
dépôt : chemins de fichiers, chiffres mesurés, commandes citées.

## En un coup d'œil

| | |
|---|---|
| Code | 172 fichiers Dart, 37 573 lignes, 42 écrans |
| Tests | 28 fichiers, 109 tests — dont **3 tests de widgets** |
| Traductions | 683 clés (FR/EN), **68 jamais utilisées** |
| Écrans montés | 38 routes |
| Écrans inaccessibles | **13** (self-care : 9, IA : 3, journal : 1 doublon) |

**Les cinq actions les plus rentables, dans l'ordre :**

1. Supprimer ou brancher le code mort — 13 écrans et ~30 fichiers dorment, dont deux
   fonctionnalités entières (self-care, IA) et un doublon de l'accueil journal.
2. Ajouter des tests de widgets sur les 4 parcours critiques (onboarding, calendrier,
   symptômes, journal) : 3 tests de widgets pour 42 écrans, c'est le principal risque
   de régression.
3. Trancher sur les boutons Google/Apple : ils sont visibles et inertes.
4. Factoriser les états de chargement/erreur : 5 squelettes pour ~40 écrans asynchrones,
   18 gestionnaires d'erreur.
5. Déplacer l'avatar hors de Firestore (base64 dans le document utilisateur).

---

## 1. Code mort, doublons et routes fantômes — priorité haute, effort faible

### 1.1 Fonctionnalités entières inaccessibles
Aucune route ne mène à ces écrans ; aucun fichier ne les importe :

| Fichiers | Constat |
|---|---|
| `self_care/…/self_care_home_screen.dart` + 8 écrans (méditation, étirements, skincare, minuteur, félicitations…) | **9 écrans jamais montés.** La fonctionnalité self-care est morte. |
| `ai/…/ai_chat_screen.dart`, `voice_chat_screen.dart`, `appointment_confirmation_screen.dart` | **3 écrans jamais montés.** Le chat « Perry » contient en plus des données de démonstration codées en dur (`'Perry'`, `'Dr. Adrian Cole'`). |

Décision attendue : les brancher (il faut alors un backend) ou les retirer du dépôt.

### 1.2 Doublons
- `journal/presentation/screens/journal_home_screen.dart` (`JournalHomeScreen`) n'est
  jamais utilisé : l'onglet Journal est `journal_screens.dart` (`JournalScreens`). Deux
  accueils journal coexistent, dont un mort.
- `/notification` **et** `/notifications` mènent au même `NotificationInboxScreen` ;
  `profile/presentation/screens/notification.dart` (`NotificationsScreen`) est orphelin.
- `profile/data/repositories/security_repository.dart` est remplacé par
  `core/services/security_service.dart`.

### 1.3 Petits orphelins
`core/config/app_config.dart`, `core/constants/app_grind.dart` (sic),
`core/errors/app_error_handler.dart`, `core/storage/app_settings_repository.dart`,
`calendar/…/symptoms_squeleton.dart`, `cycle/domain/cycle_prediction.dart`,
`onboarding/…/welcome_controller.dart`, `shared/widgets/lock_screen.dart`.

### 1.4 Traductions mortes
68 clés de `app_fr.arb` ne sont référencées nulle part (ex. `turnOnNotifications`,
`cycleProfile`, `howDoYouFell` — faute de frappe incluse —, `difficultyEasy`,
`articleSkinCare`). À supprimer des 5 fichiers de traduction.

---

## 2. Sécurité et comptes — priorité haute

**Fait (PR #10)** : vérification d'e-mail réelle, création de compte + liaison au compte
anonyme, connexion, mot de passe oublié, suppression de compte avec purge Firestore et
locale, mots de passe à 8 caractères, erreurs explicites.

**Reste :**
- **Code OTP à 4 chiffres** : nécessite un backend (Cloud Functions + fournisseur
  d'e-mail). L'écran actuel utilise le lien signé Firebase, qui est le mécanisme natif.
- **Google / Apple** : boutons présents, `TODO` dans `register_controller.dart`. Il faut
  activer les fournisseurs dans la console Firebase et les empreintes SHA.
- **Suppression du compte** : la purge s'appuie sur une liste de modules
  (`UserRepository.userDataModules`). Le SDK Flutter n'expose pas la liste des
  sous-collections : toute nouvelle collection doit être ajoutée à cette liste, sinon
  elle survivra à la suppression.
- **Règles Firestore** (`firestore.rules`) : isolation par `uid` correcte, y compris les
  sous-collections. Pas de limite de taille ni de validation de schéma.
- **Session** : aucune expiration côté app en dehors de `local_auth` ; le PIN global
  existe et couvre le journal.

---

## 3. Fiabilité et qualité — priorité haute

- **Tests** : 109 tests, dont 3 de widgets (`app_back_navigation`, `months grid`,
  `contrast`…). Aucun test de parcours complet : onboarding, sélection de date,
  enregistrement de symptômes et rédaction d'un journal ne sont pas couverts.
- **Observabilité** : ni Crashlytics ni analytics. Une exception en production est
  invisible.
- **États d'erreur** : 18 gestionnaires `error:` pour une quarantaine d'écrans
  asynchrones ; plusieurs écrans affichent un texte brut sans action de reprise.
- **CI** : `flutter analyze --no-fatal-infos --no-fatal-warnings` + `flutter test` +
  builds. Pas de `dart format --set-exit-if-changed`, pas de seuil de couverture.
- **Hors ligne** : persistance Firestore activée (`firebase_service.dart`), journal
  chiffré en local ; en revanche aucun indicateur « hors ligne » ni état de file
  d'attente visible.

---

## 4. Accessibilité — priorité moyenne

**Fait** : phrases complètes par jour du calendrier, cibles tactiles de 44 px, libellés
des boutons icône du retour et des en-têtes, contrastes AA des textes (voir
`docs/CONTRASTE.md`), test de non-régression des ratios.

**Reste :**
- Icônes grises sous 3:1 (chevrons de listes, œil des mots de passe).
- Aucun test à l'échelle de texte 2.0 : les cartes du calendrier et les chips risquent
  de déborder.
- `Semantics` encore rare hors calendrier (les libellés de champs reposent sur le texte
  au-dessus du champ).
- Ordre de lecture et focus clavier non vérifiés.

---

## 5. Performance — priorité moyenne

**Fait** : provider unique par mois pour la grille du calendrier, mascottes en WebP
(876 Ko → 343 Ko).

**Reste :**
- `Image.asset` décode les mascottes en 640 × 640 même affichées en 96 px :
  `cacheWidth` diviserait la mémoire par 4 à 40.
- Six `ListView(children: …)` non paresseuses.
- Aucun `precacheImage` dans les carrousels : premier scroll avec images vides.
- Pas de mesure réelle (profile mode) : les gains annoncés sont structurels.

---

## 6. Cohérence de l'interface — priorité moyenne

- **États vides** : seulement 5 fichiers utilisent un squelette ; les autres écrans
  affichent un texte nu ou rien. Les états vides du journal, des notifications et de la
  recherche ne suivent pas un modèle commun.
- **Rayons et espacements** : 12 / 14 / 16 / 20 / 22 / 24 / 28 cohabitent. `AppRadius`
  et `AppSpacing` existent mais ne sont pas utilisés partout.
- **Navigation retour** : `app_back_navigation.dart` maintient une table de routes à la
  main ; toute nouvelle route doit y être déclarée, sinon le retour retombe sur le
  fallback.
- **Formats de date** : `DateFormat.yMMMM`, `yMMMMd` et formats manuels se côtoient.
- **Onboarding** : le bouton « passer » des objectifs est un `TODO` (`set_goals_screen.dart`).

---

## 7. Données et conformité — priorité moyenne

- **Avatar stocké en base64 dans le document Firestore** (`avatarBase64`, 512 px,
  qualité 70 soit ~40–60 Ko) : relu à chaque ouverture du profil, et proche de la limite
  de 1 Mio par document. À déplacer vers Firebase Storage.
- **Export de données** : absent. La suppression est en place, pas la portabilité
  (RGPD art. 20).
- **Rétention** : aucune politique écrite pour les données partenaires.
- **Consentement** : versionné et vérifié avant toute écriture (`privacy_policy_consent_service`).

---

## 8. Produit — ce qui n'existe pas encore

| Sujet | État |
|---|---|
| Rappels intelligents (règles à venir, prise de pilule, note de symptômes) | planificateur local existant (`notification_schedule_planner.dart`), non exposé dans l'UI |
| Tendances symptômes | insights présents pour le journal seulement |
| Export PDF « pour mon médecin » | absent |
| Chat IA | écran statique, non routé |
| Self-care | 9 écrans, non routés |
| Partenaire | parcours complet, mais aucune notification quand le partenaire consulte |

---

## Priorisation proposée

| # | Action | Impact | Effort |
|---|---|---|---|
| 1 | Nettoyage du code mort + 68 clés de traduction | élevé | S |
| 2 | 5–6 tests de widgets sur les parcours critiques | élevé | M |
| 3 | Décision Google/Apple (brancher ou masquer) | élevé | M |
| 4 | Modèle unique d'état vide / erreur / chargement | moyen | M |
| 5 | Avatar vers Firebase Storage | moyen | M |
| 6 | `cacheWidth` + précache des images | moyen | S |
| 7 | Icônes contrastées + test à l'échelle 2.0 | moyen | S |
| 8 | Crashlytics + seuil de couverture CI | moyen | S |
| 9 | Export de données (JSON/PDF) | moyen | L |
| 10 | Brancher self-care et IA, ou les retirer | variable | L |
