# TODO - Futures Améliorations de Peria

Ce document liste les tâches de développement, d'amélioration et de maintenance identifiées pour l'application Peria.

## Technique & Architecture
- [ ] Mettre en place un système de notifications locales (rappels pour les médicaments, menstruations, etc.).
- [ ] Ajouter une couverture de tests automatisés (tests de widgets et tests d'intégration complets, particulièrement pour isoler l'environnement de la base de données).
- [ ] Finaliser l'intégration du backend (remplacement progressif de la logique locale de démonstration par les endpoints finaux via `dio`).
- [ ] Séparer les secrets de l'application dans des variables d'environnement (`.env`) avec le package `flutter_dotenv`.

## UI & Expérience Utilisateur (UX)
- [ ] Ajouter de nouvelles animations Hero entre les pages du journal pour rendre l'expérience plus fluide.
- [ ] Introduire le mode "Dark Mode" complet (le Design System possède déjà les tokens nécessaires, il reste à harmoniser les Widgets `Material`).
- [ ] Ajouter un système de graphiques interactifs (ex: `fl_chart`) pour suivre l'historique du cycle sur les 6 derniers mois.

## Sécurité
- [ ] Exiger la vérification biométrique/PIN pour effacer la base de données ("Danger Zone" de l'écran Profil).
- [ ] Gérer l'expiration des tokens d'authentification et forcer la déconnexion après un laps de temps prédéfini.
