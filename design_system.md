# Peria App — Analyse et Design System

Ce document contient l'analyse complète de l'architecture du projet Peria, ainsi que son Design System (couleurs, typographie, espacements).

## 1. Architecture du Projet (De A à Z)

Le projet est basé sur **Flutter** (SDK >=3.10.0) et utilise une architecture orientée fonctionnalités (Feature-First) avec une séparation claire des responsabilités :

### Structure Principale
- **`lib/core/`** : Contient tous les éléments centraux de l'application (thème, constantes, configuration réseau, routeur).
- **`lib/shared/`** : Contient les widgets réutilisables à travers l'application (`common_widgets.dart`), utilitaires, et éléments partagés.
- **`lib/features/`** : Implémente chaque fonctionnalité métier dans son propre dossier :
  - `auth/` : Gestion de l'authentification (login, register, OTP).
  - `onboarding/` : Flux d'embarquement utilisateur (nom, date de naissance, objectifs).
  - `calendar/` : Fonctionnalités liées au calendrier du cycle menstruel.
  - `home/` : L'écran d'accueil principal (CycleHomeScreen).

### Dépendances et Outils Clés
- **State Management** : `flutter_riverpod` (Gestion d'état globale et réactive).
- **Navigation** : `go_router` (Navigation basée sur l'URL, gestion avancée des routes).
- **Réseau / HTTP** : `dio` (Requêtes API REST fluides et modifiables via des intercepteurs).
- **Stockage Local** : `shared_preferences` (Stockage de petites données clés-valeurs).
- **Assets Vectoriels** : `flutter_svg` (Affichage optimisé d'icônes et illustrations au format SVG).

### Flux de Navigation Principal
```text
/welcome → /register → /email → /create-account → /otp
                                                     ↓
                    /home ← /last-period ← /set-goals ← /date-of-birth ← /ask-name
```

---

## 2. Design System

### 2.1 Couleurs (Palette)
L'application utilise une palette basée sur le Rose vif et le Violet clair, avec des variantes définies.

- **Primaire (Rose/Pink)**
  - Base : `#FD587A` (`primary400` / `periodBase`)
  - Clair : `#FFCCD5` (`primary200`)
- **Secondaire (Violet/Purple)**
  - Base : `#C294EC` (`secondary400`)
  - Foncé : `#A25DDE` (`secondary500` / `ovulBase`)
  - Clair : `#F3EBFC` (`secondary100`)
- **Neutres (Grey/White/Black)**
  - Fond clair : `#FFFFFF` (`neutral50`)
  - Gris de base : `#BDBDBD` (`neutral400`)
  - Texte foncé / Noir : `#121212` (`neutral950`) / `#292929` (`neutral900`)
- **Alertes / Semantique**
  - **Succès** : `#22C55E`
  - **Avertissement (PMS)** : `#FACC15` (`warning200`)
  - **Erreur** : `#EF4444`
  - **Info** : `#3B82F6`

**Gradients Définis :**
- `bgGradient` : Dégradé vertical Blanc → Rose très clair (`#FFF1F3`) → Violet très clair (`#F3EBFC`).
- `cycleHeaderGradient` : Dégradé pour les en-têtes du cycle Rose clair (`#FFF1F3`) → Blanc (`#FFFFFF`).

---

### 2.2 Typographie
La police principale de l'application est **Poppins** (déclarée sous le nom de famille `PerlApp`).

- **Display**
  - `Display Large` : 57px, Bold (w700), hauteur 1.12
  - `Display Medium` : 45px, Bold (w700), hauteur 1.16
  - `Display Small` : 36px, Semi-Bold (w600), hauteur 1.22
- **Headings**
  - `H1` : 32px, Bold (w700)
  - `H2` : 28px, Bold (w700)
  - `H3` : 24px, Semi-Bold (w600)
  - `H4` : 20px, Semi-Bold (w600)
  - `H5` : 18px, Semi-Bold (w600)
  - `H6` : 16px, Semi-Bold (w600)
- **Body & Paragraphs**
  - `Body XLarge` : 20px, Regular (w400)
  - `Body Large` : 18px, Regular (w400)
  - `Body Medium` : 16px, Regular (w400)
  - `Body Small` : 14px, Regular (w400)
  - `Body XSmall` : 12px, Regular (w400)
- **Boutons & Labels**
  - `Button Large` : 16px, Semi-Bold (w600), LetterSpacing 0.1
  - `Button Medium` : 14px, Semi-Bold (w600)
  - `Button Small` : 12px, Semi-Bold (w600)

---

### 2.3 Dimensions & Espacements (Spacing & Padding)

L'échelle d'espacement utilise des multiples de 8.

**Scale d'espacement de base :**
- `xs` (8px), `sm` (16px), `md` (24px), `lg` (32px), `xl` (40px), `xxl` (56px), `xxxl` (72px).

**Padding standard :**
- Marge globale d'écran (Screen Margin) : `24px` horizontal (`EdgeInsets.symmetric(horizontal: 24)`).
- Autres paddings courants : `p8`, `p16`, `p24`, `p32`.

---

### 2.4 Rayon de Coins (Border Radius)
Système de bordures pour lisser les containers, inputs et boutons.

- Petits arrondis : `4px`, `8px`, `12px`
- Arrondis standards : `16px`, `24px`, `32px`
- Éléments elliptiques / compléments arrondis (Pill) : `999px`

---

## 3. Informations Complémentaires

- **Éléments graphiques (CustomPainter)** : Plusieurs éléments sont tracés au code pur, pour optimiser les performances et la personnalisation : le Logo Peria, la roue cyclique, les cases OTP, le date picker, et le calendrier.
- **Cycle Menstruel (États UI)** : La couleur de l'interface change dynamiquement avec 3 états globaux (Phase, Couleur de l'UI) :
  - *Period* : Rose vif (`primary400`)
  - *PMS* : Jaune / Doré (`warning200`)
  - *Ovulation* : Violet (`secondary500`)
  
Ces éléments permettent de concevoir des composants cohérents en piochant simplement dans les classes statiques `AppColors`, `AppSpacing`, `AppTypography` et `AppRadius` du dossier `lib/core/theme/`.
