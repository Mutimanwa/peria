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
1. **Hive (NoSQL)**: Stocke la majorité des données structurées et rapides d'accès (profil utilisateur, logs du cycle, notes de journal). La Box du journal peut être verrouillée.
2. **Flutter Secure Storage**: Conserve le code PIN, les tokens d'authentification et les clés cryptographiques en s'appuyant sur Android KeyStore et le Keychain iOS.
3. **Shared Preferences**: Pour les réglages mineurs, comme la bascule du thème ou le statut d'onboarding.

## 5. Composants de Sécurité

La sécurité repose sur `SecurityService` (bas niveau) et `SecurityNotifier` (état partagé via Riverpod).
La stratégie "Multitask protection" masque l'écran dans l'App Switcher. Une protection de force brute désactive l'authentification PIN pour plusieurs minutes en cas de tentatives abusives.
