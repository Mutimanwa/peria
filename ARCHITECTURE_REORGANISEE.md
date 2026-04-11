# Architecture Réorganisée - Peria App

## Vue d'ensemble
L'application a été restructurée autour de **3 axes fondamentaux** pour un MVP plus cohérent et maintenable :

## 🗓️ **Cycle** - Suivi menstruel et fertilité
- **Écran principal** : Calendrier simplifié avec visualisation claire des cycles
- **Fonctionnalités** :
  - Distinction cycles réguliers/irréguliers
  - Légende explicite des couleurs/états
  - Panneau d'information dynamique
  - Prédictions basées sur les données historiques

## 📔 **Journal** - Suivi intime et sécurisé
- **Écran principal** : Interface de saisie rapide (humeur + note)
- **Fonctionnalités** :
  - Verrouillage biométrique obligatoire
  - Saisie simplifiée : mood + note textuelle
  - Historique chronologique sécurisé
  - Corrélation avec les données de cycle

## 🎓 **Éducation** - Contenus pédagogiques ciblés
- **Écran principal** : Bibliothèque de contenus éducatifs
- **Fonctionnalités** :
  - Articles sur l'irrégularité des cycles
  - Guides sur l'ovulation et la fertilité
  - Informations sur les douleurs menstruelles
  - Contenus connectés aux données utilisateur

## 🧭 Navigation
- **Shell Navigation** : Bottom navigation bar persistante avec 3 onglets
- **Routes simplifiées** : Hiérarchie claire et maintenable
- **Authentification** : Gestion des redirections automatique

## 🏗️ Structure Technique
```
lib/
├── core/router/
│   ├── router.dart          # Configuration des routes principales
│   └── shell_navigation.dart # Navigation shell avec bottom bar
├── features/
│   ├── cycle/               # Module de suivi des cycles
│   ├── journal/             # Module de journal intime
│   └── self_care/           # Module éducatif (à renommer)
```

## 🔄 États d'authentification
- **Non authentifié** → Redirection vers `/welcome`
- **Authentifié + Onboarding incomplet** → Redirection vers `/ask-name`
- **Authentifié + Onboarding complet** → Accès aux 3 modules principaux

## 🎯 Prochaines étapes
1. **Renforcer la sécurité du journal** (biométrie)
2. **Améliorer la lisibilité du calendrier** (légende, feedback)
3. **Repositionner les contenus éducatifs** (focus problématiques réelles)
4. **Structurer les données** pour analyses prédictives