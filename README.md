# Peria - Suivi de Cycle & Assistant Santé

Peria est une application mobile moderne (Flutter) dédiée au bien-être féminin. Elle offre un suivi de cycle menstruel avancé, un journal intime sécurisé (biométrie/PIN), des conseils personnalisés assistés par l'intelligence artificielle, ainsi que la possibilité de partager des informations spécifiques avec un partenaire.

## 🚀 Fonctionnalités Principales

- **Suivi de Cycle Intelligent** : Calendrier interactif, prédictions intelligentes et suivi des symptômes quotidiens (phases menstruelle, lutéale, folliculaire, ovulation).
- **Journal Sécurisé** : Un espace intime protégé par un code PIN et/ou FaceID/TouchID pour noter quotidiennement son humeur et ses ressentis.
- **Sécurité et Confidentialité (Privacy First)** : Mode "Multitask protection", effacement des données, et sécurité granulaire.
- **Assistant IA (ChatIA)** : Conseils personnalisés sur la santé, accès rapide à des articles éducatifs.
- **Espace Partenaire** : Partage sélectif et sécurisé pour impliquer son partenaire dans son bien-être.

## 🏗 Stack Technique

- **Framework** : Flutter (Dart)
- **Architecture** : Feature-First (Clean Architecture)
- **Gestion d'état** : `flutter_riverpod`
- **Stockage Local** : `hive` (base de données NoSQL locale), `flutter_secure_storage` (PIN et clés), `shared_preferences`.
- **Réseau** : `dio` pour les requêtes HTTP (Assistant IA / Backend).
- **Navigation** : Routage via `go_router`.
- **Design System** : Créé sur mesure (cf. `docs/design_system.md`) orienté expérience utilisateur fluide avec des bordures arrondies, animations discrètes et une typographie moderne (Inter).

## 📁 Documentation

La documentation détaillée se trouve dans le dossier `docs/` :

- [Architecture du Projet](docs/ARCHITECTURE.md) : Modèles, Services, Providers et la logique de l'application.
- [Design System](docs/design_system.md) : Couleurs, typographies, règles de design et composants métier.
- [Cahier des charges (Initial)](docs/cahier.md) : Le document de conception initial.

Pour toute nouvelle fonctionnalité ou amélioration prévue, consultez le fichier [TODO.md](TODO.md).

## 🛠 Lancement Rapide

```bash
flutter clean
flutter pub get
flutter run
```
