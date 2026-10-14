# Architecture du Projet Peria

## 1. Philosophie Globale
Le projet utilise une architecture orientée "Feature-First" en s'inspirant des principes Clean Architecture. Cette organisation garantit que chaque fonctionnalité de l'application (ex: profil, calendrier, ia) reste isolée et contient toutes les couches qui lui sont nécessaires.

## 2. Structure des Dossiers

```
lib/
├── core/                   # Cœur de l'application (commun à toutes les features)
│   ├── network/            # Configurations HTTP (Dio, interceptors)
│   ├── services/           # Services globaux (Sécurité, Stockage bas niveau)
│   ├── storage/            # Gestion globale de Hive / SecureStorage
│   └── theme/              # Design System (tokens, widgets fondamentaux)
│
├── features/               # Fonctionnalités principales (Features)
│   ├── auth/               # Connexion, Inscription, OTP
│   ├── chat_ia/            # Intégration du LLM, historique de discussion
│   ├── cycle/              # Saisie et prédictions des différentes phases
│   ├── journal/            # Journal intime (CRUD, cryptage)
│   └── profile/            # Gestion du compte, Sécurité (PIN/FaceID), Thème
│
└── shared/                 # Composants transverses
    └── widgets/            # Widgets réutilisables (Boutons, Bottom NavBar, PinCodeInput, etc.)
```

## 3. Gestion de l'Etat avec Riverpod

Riverpod est utilisé de façon structurée :
- **Providers** simples (`Provider`) : Injection de dépendances métier (Repositories, Services externes).
- **AsyncNotifiers** / **StateNotifiers** : Gestion de l'état asynchrone des composants de l'interface (ex: Chargement du journal).

## 4. Persistance des Données

Afin d'assurer le fonctionnement hors ligne et la sécurité :
1. **Hive (NoSQL)**: Stocke les notes du journal dans une box chiffrée, ainsi que les suppressions en attente (tombstones) afin d’éviter la restauration accidentelle de notes supprimées.
2. **Flutter Secure Storage**: Conserve le code PIN, les tokens d'authentification et les clés cryptographiques en s'appuyant sur Android KeyStore et le Keychain iOS.
3. **Shared Preferences**: Pour les réglages mineurs et le consentement local à la synchronisation du journal. Ce consentement est désactivé par défaut et n’est jamais téléchargé depuis le compte cloud.
4. **Firebase Firestore**: Synchronise les notes uniquement après une action de consentement explicite. Son cache hors ligne éventuel est distinct de la box Hive chiffrée et est signalé dans le dialogue de consentement. La synchronisation peut être arrêtée séparément ; l’arrêt ne supprime pas les copies déjà envoyées.

## 5. Composants de Sécurité

La sécurité repose sur `SecurityService` (bas niveau) et `SecurityNotifier` (état partagé via Riverpod).
La stratégie "Multitask protection" masque l'écran dans l'App Switcher. Une protection de force brute désactive l'authentification PIN pour plusieurs minutes en cas de tentatives abusives.

## 6. Données du cycle : source de vérité

Les informations de cycle suivent un seul flux :

1. **Entrées** : `periodLogsProvider` fournit les règles réellement enregistrées. `userProfileProvider` fournit les paramètres saisis (durée moyenne du cycle, durée des règles et dernière date connue) ; ces paramètres servent de repli quand aucun journal de règles n’existe, pas de second calcul de prédiction.
2. **Calcul métier** : `CycleEngine` est le moteur pur des phases, dates et fenêtres prédites. Pour une date historique, il n’ancre le calcul que sur les journaux commencés à cette date ou avant ; les journaux futurs ne déplacent pas l’ancre.
3. **État dérivé canonique** : `cycleStatusForDateProvider(date)` est le point d’accès pour une date ; `cycleStatusProvider` est son alias pour aujourd’hui. Les providers de phase, d’ovulation, de fenêtre fertile, de règles, de confiance et de retard dérivent de ces statuts.
4. **Vue journalière pour le calendrier** : `cycleDayInfoProvider(date)` réunit le statut calculé et le journal réel. Un jour enregistré a priorité sur un jour prédit et les deux restent distinguables dans l’interface.

### Écrans et services consommateurs

| Écran / service | Données à lire | Règle d’architecture |
| --- | --- | --- |
| `CycleHomeScreen` | `cycleStatusProvider` | Phase, jour, compte à rebours et progression viennent du même statut, y compris `cycleLengthDays` ; ne pas recalculer la longueur à partir du profil dans l’écran. |
| `CalendarScreen` | `cycleDayInfoProvider(date)` | Marqueurs et détail du jour utilisent la même classification ; les règles enregistrées sont libellées comme telles, séparément des prédictions. |
| `EditCalendarScreen` | `cycleDayInfoProvider(date)` pour l’affichage ; `periodLogsProvider` pour enregistrer une correction | Les jours réels et prédits ont une présentation distincte. La saisie modifie le journal, elle ne recalcule pas les prédictions dans l’écran. |
| Éducation (`education_provider.dart`) | `cycleStatusProvider`, `symptomLogsProvider`, `journalProvider` | `EducationContextService` transforme localement la phase, les tags de symptômes et l’humeur du journal en tags; les suggestions filtrent le catalogue statique sur l’appareil. Le module Éducation n’envoie pas le texte du journal à un service de recommandation. |
| Notifications locales (`local_notification_provider.dart`) | `cycleStatusProvider` | Les rappels sont dérivés du statut courant ; ils ne possèdent pas de formule de cycle parallèle. |
| Statistiques et providers dérivés | `cycleStatisticsProvider`, `cyclePredictionForDateProvider` et providers spécialisés | Les statistiques agrégées passent par `CycleEngine.computeStatistics`; un consommateur réutilise ces providers au lieu de recalculer des moyennes, phases ou dates dans un écran. |

Pour éviter les calculs parallèles dans l’interface, la progression utilise `status.cycleLengthDays`. `cycleStatisticsProvider` expose, lui, les agrégats historiques calculés sur tous les intervalles ; la prédiction de statut utilise les six journaux les plus récents au maximum. Ces deux fenêtres ont des objectifs différents et doivent être présentées comme telles.

Les écrans de profil et de paramètres qui modifient les préférences de cycle sont des **sources d’entrées**, pas des sources de prédictions. Tout nouvel écran affichant des informations de cycle doit consommer les providers ci-dessus ; il ne doit pas appeler directement `CycleEngine` ni calculer ses propres dates, phases ou longueurs.
