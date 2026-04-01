# Peria App — Guide d'intégration des écrans Flutter

## Structure des fichiers

```
peria_app/
├── pubspec.yaml
└── lib/
    ├── main.dart                          ← Point d'entrée + routes
    ├── core/
    │   └── theme/
    │       ├── app_colors.dart            ← Toutes les couleurs
    │       └── app_text.dart             ← Tous les styles texte
    ├── widgets/
    │   └── common_widgets.dart           ← PrimaryButton, PillTextField, OnboardingScaffold…
    └── screens/
        ├── welcome_screen.dart           ← Écran 1 : Welcome
        ├── register_screen.dart          ← Écran 2 : Register (email/Google/Apple)
        ├── auth_screens.dart             ← Écran 3 : Email + Écran 4 : Create Account
        ├── otp_screen.dart               ← Écran 5 : OTP + dialog succès
        ├── onboarding_screens.dart       ← Écran 6 : Ask Name + Écran 7 : Date of Birth
        ├── set_goals_screen.dart         ← Écran 8 : Set Goals (grille 2×3)
        ├── set_last_period_screen.dart   ← Écran 9 : Calendrier dernière période
        └── cycle_home_screen.dart        ← Écran 10 : Dashboard cycle (3 phases)
```

---

## Images 3D à fournir

Placer dans `assets/images/` :

| Fichier | Description | Écran |
|---------|-------------|-------|
| `welcome_character.png` | Personnage féminin tenant un téléphone, avec 3 avatars flottants autour | WelcomeScreen |
| `avatar_pink.png` | Avatar rond — cheveux roses | WelcomeScreen (flottant gauche) |
| `avatar_hat.png` | Avatar rond — chapeau blanc | WelcomeScreen (flottant droite haut) |
| `avatar_purple.png` | Avatar rond — cheveux violets, signe de la paix | WelcomeScreen (flottant droite bas) |
| `register_character.png` | Personnage assis en tailleur sur un canapé, yeux fermés, pull rose | RegisterScreen |
| `envelope_3d.png` | Enveloppe 3D ouverte, dégradé rose→violet | ContinueWithEmailScreen + CreateAccountScreen |
| `shield_3d.png` | Bouclier 3D avec coche, dégradé rose→violet | OtpScreen |
| `ask_name_character.png` | Personnage aux cheveux violets tenant un téléphone, souriant | AskNameScreen |
| `dob_character.png` | Personnage aux cheveux violets lisant un livre vert | DateOfBirthScreen |
| `user_avatar.png` | Photo de profil ronde de l'utilisateur | CycleHomeScreen (AppBar) |
| `article_diet.png` | Personnage 3D avec bol de salade | CycleHome — article 1 |
| `article_skin.png` | Personnage 3D appliquant soin visage | CycleHome — article 2 |
| `article_yoga.png` | Personnage 3D en posture de yoga | CycleHome — article 3 |

---

## Police Poppins

Télécharger depuis [Google Fonts](https://fonts.google.com/specimen/Poppins) et placer dans `assets/fonts/` :
- `Poppins-Regular.ttf`
- `Poppins-Medium.ttf`
- `Poppins-SemiBold.ttf`
- `Poppins-Bold.ttf`
- `Poppins-ExtraBold.ttf`

---

## Éléments dessinés en Flutter (CustomPainter)

Ces éléments graphiques sont **déjà codés** et ne nécessitent pas d'image :

- ✅ **Logo Peria** — deux cercles entrelacés rose + violet
- ✅ **Roue cyclique** — anneau pointillé + demi-cercle coloré + badge numéro + vague décorative
- ✅ **Cases OTP** — 4 cases carrées arrondies avec input
- ✅ **Date picker** — ListWheelScrollView mois/jour/année
- ✅ **Calendrier** — navigation mois, grille 7 colonnes, sélection plage rose

---

## Flux de navigation

```
/welcome → /register → /email → /create-account → /otp
                                                     ↓
                    /home ← /last-period ← /set-goals ← /date-of-birth ← /ask-name
```

---

## États de la roue cyclique (CycleHomeScreen)

Changer `_phase` dans `_CycleHomeScreenState` pour basculer entre :

| Phase | Couleur | Badge position |
|-------|---------|---------------|
| `CyclePhase.period` | Rose vif | Droite (3h) |
| `CyclePhase.pms` | Doré/Jaune | Gauche (9h) |
| `CyclePhase.ovulation` | Violet | Bas (6h) |
