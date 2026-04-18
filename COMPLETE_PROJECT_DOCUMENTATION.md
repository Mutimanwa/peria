# 📚 DOCUMENTATION COMPLÈTE DU PROJET PERIA

## Vue d'ensemble générale

**Peria** est une application Flutter focalisée sur le suivi du cycle menstruel, l'éducation en auto-soin, l'assistance IA, la journalisation intime sécurisée et les fonctionnalités de partage partenaire.

**Architecture**: Fondée sur une architecture orientée fonctionnalités (Feature-First) avec séparation claire des responsabilités.

**Version Flutter**: >=3.10.0  
**SDK Dart**: >=3.0.0 <4.0.0

---

## 🏗️ STRUCTURE GLOBALE DU PROJET

```
lib/
├── core/                    # Fondation technique transversale
│   ├── config/              # Configuration application
│   ├── constants/           # Constantes globales
│   ├── router/              # Navigation et routage
│   ├── storage/             # Persistance de données (Hive, SharedPreferences)
│   └── theme/               # Thème, couleurs, typographie
├── shared/                  # Widgets et utilitaires réutilisables
│   └── widgets/             # Boutons, champs, composants communs
└── features/                # Modules métier indépendants
    ├── onboarding/          # Flux d'embarquement utilisateur
    ├── auth/                # Authentification
    ├── home/                # Tableau de bord cycle
    ├── calendar/            # Calendrier et symptômes
    ├── cycle/               # Logique du cycle menstruel
    ├── journal/             # Journal intime sécurisé
    ├── self_care/           # Contenus d'auto-soin et éducation
    ├── ai/                  # Assistant IA
    ├── profile/             # Profil et paramètres
    └── educatif/            # Contenus éducatifs

assets/
├── images/                  # Images et icônes
│   ├── onboarding/
│   ├── icons/
│   ├── logo/
│   └── frames/

android/, ios/, web/, etc/   # Dossiers plateformes Flutter
```

---

## 🔑 COUCHE CORE - LA FONDATION

### 1. **core/theme/** - Système de Design

#### `theme.dart`
Centralise le thème Material 3 avec:
- `ThemeData` (light mode par défaut)
- Palette de couleurs primaires et secondaires
- Configuration Material Design

**Utilisation**: Appliqué au niveau racine dans `MaterialApp.router`

#### `app_colors.dart`
Définit l'ensemble de la palette de couleurs:

```dart
// Primaires
primary50, primary100, ..., primary900

// Secondaires
secondary50, secondary100, ..., secondary900

// Grises
grey50, grey100, ..., grey900

// États
white, black, success, error, warning

// Gradients
bgGradient (gradient de fond principal)
```

Exemple d'utilisation:
```dart
Container(
  color: AppColors.primary50,
  child: Text('Texte', style: AppText.body)
)
```

#### `app_text.dart`
Styles typographiques prédéfinis:

```dart
// Headings
h1, h2, h3, h4 (poids et tailles croissantes)

// Body
body (texte corps principal)
label (petits labels)
caption (sous-texte)

// Buttons
btnPrimary, btnOutline (styles de boutons)
```

**Méthode clé**: `.copyWith()` pour adapter les styles
```dart
AppText.body.copyWith(color: AppColors.grey500, fontWeight: FontWeight.w700)
```

#### `app_typography.dart`
Définit les familles de polices (Google Fonts) et tailles de base.

---

### 2. **core/router/** - Navigation Centralisée

#### `router.dart`
Centralise ALL les routes avec `GoRouter`:

**Routes principales**:
```
/welcome                    # Splash onboarding
/register                   # Enregistrement
/email, /create-account     # Flux d'authentification
/otp                        # Vérification OTP
/ask-name, /date-of-birth   # Onboarding données
/set-goals, /last-period    # Onboarding cycle
/home                       # Tableau de bord principal
/calendar, /edit-calendar   # Calendrier
/symptoms                   # Suivi symptômes
/journal, /journal/:id      # Journal intime
/ai, /ai/voice              # Assistant IA
/self-care, /self-care/*    # Auto-soin et éducation
/profile/*                  # Profil et paramètres
```

**Méthodes clés**:
- `_buildSlideTransitionPage()`: Crée une transition slide de droite à gauche (300ms, easeOutCubic)

**Transition standard**:
```dart
Offset begin: (1.0, 0)  // Entre par la droite
Offset end: (0, 0)      // Se positionne au centre
Curve: easeOutCubic
Duration: 300ms
```

**Structure routing**:
```dart
GoRouter(
  routes: [
    GoRoute(path: '/home', builder: (ctx, state) => HomePage()),
    GoRoute(
      path: '/profile',
      builder: (ctx, state) => ProfilePage(),
      routes: [
        GoRoute(path: 'personal-info', builder: ...)
      ]
    )
  ]
)
```

---

### 3. **core/storage/** - Persistance de Données

#### Architecture de persistance (Nouveau - Post Hive Migration)

##### `hive_boxes.dart`
Constantes pour les noms des boîtes Hive:
```dart
class HiveBoxes {
  static const journalEntries = 'journal.entries.v1';
  static const periodLogs = 'cycle.period_logs.v1';
  static const userProfile = 'profile.user_profile.v1';
}
```

##### `secure_storage_service.dart`
Gère les clés de chiffrement via `flutter_secure_storage`:

```dart
static Future<List<int>> getEncryptionKey()
// - Génère une clé 32 bits sécurisée si absente
// - La stocke en Base64 dans le stockage sécurisé
// - Retourne la clé décodée pour Hive
```

**Utilisation**: Automatique lors de l'initialisation Hive.

##### `hive_setup.dart`
Initialise Hive avec tous les adapters et boîtes chiffrées:

```dart
Future<void> HiveSetup.init()
// 1. Appelle Hive.initFlutter()
// 2. Enregistre adapters (JournalEntry, PeriodLog, UserProfile)
// 3. Récupère clé de chiffrement depuis SecureStorageService
// 4. Ouvre les 3 boîtes avec HiveAesCipher
```

**Méthode**: Appelée dans `main()` avant de lancer l'app.

##### `app_settings_repository.dart`
Gère les paramètres app SIMPLES (non cycle) via SharedPreferences:

```dart
Future<AppSettings> load()
// Lit depuis SharedPreferences:
// - allowNotifications, notifyPeriodStarting, notifyFertileWindow
// - notifyOvulationDay, remindLogSymptoms, notifyPartnerUpdates
// - periodLengthDays, cycleLengthDays
// - twoFactorEnabled, faceIdEnabled, discreetModeEnabled

Future<void> save(AppSettings settings)
// Persiste tous les paramètres ci-dessus
```

##### `app_settings.dart`
Modèle immutable pour les paramètres app:

```dart
class AppSettings {
  final bool allowNotifications;
  final int periodLengthDays;  // 2..12
  final int cycleLengthDays;   // 21..35
  final bool faceIdEnabled;
  // ... autres flags

  AppSettings copyWith({...})  // Pattern immuable
}
```

#### Repository Pattern

Pour chaque modèle persisté, un repository expose:
- `load()` / `loadEntries()`: Récupère depuis stockage
- `save()` / `upsert()`: Persiste une entité
- `delete()`: Supprime une entité

**Exemple - JournalRepository**:
```dart
class JournalRepository {
  Future<List<JournalEntry>> loadEntries() async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    return box.values.toList();
  }

  Future<void> upsert(JournalEntry entry) async {
    final box = Hive.box<JournalEntry>(HiveBoxes.journalEntries);
    await box.put(entry.id, entry);
  }
}
```

---

### 4. **core/config/** - Configuration

Contient les constantes d'app, clés API placeholder, endpoints, etc.

#### `app_config.dart`
```dart
class AppConfig {
  static const appName = 'Peria';
  static const appVersion = '1.0.0+1';
  // API endpoints, timeouts, etc.
}
```

---

## 🎨 COUCHE SHARED - COMPOSANTS RÉUTILISABLES

### **shared/widgets/common_widgets.dart**

Boutons et champs réutilisables dans TOUTE l'app.

#### Boutons

##### `PrimaryButton`
Bouton primaire (fond noir, texte blanc, pill shape):
```dart
PrimaryButton(
  label: 'Save',
  onPressed: () {},  // null = désactivé (gris)
  fullWidth: true    // true = 100% width, false = auto
)
```

Propriétés:
- Arrondi: `StadiumBorder` (50% rayon)
- États: activé (noir) / désactivé (gris 200)
- Hauteur: 56px

##### `OutlineButton`
Bouton outline (bordure noire, fond blanc):
```dart
OutlineButton(
  label: 'Cancel',
  onPressed: () {}
)
```

Propriétés:
- Bordure: 1.5px noire
- Arrondi: `StadiumBorder`
- Hauteur: 56px

##### `SocialButton`
Bouton pour login social (Google/Apple):
```dart
SocialButton(
  label: 'Continue with Google',
  icon: GoogleIcon(),
  onPressed: () {}
)
```

Propriétés:
- Bordure grise fine
- Icône + texte centrés
- Hauteur: 56px

##### `BackIconButton`
Petit bouton retour (chevron gauche en carré arrondi):
```dart
BackIconButton(
  onPressed: () => Navigator.pop(context)
)
```

Propriétés:
- 44x44px
- Fond blanc avec bordure grise
- Ombre légère

#### Champs de saisie

##### `PillTextField`
Champ texte pill-shaped avec fond gris clair:
```dart
PillTextField(
  hint: 'Enter your name',
  controller: _nameController,
  keyboardType: TextInputType.text,
  obscure: false,
  suffix: Icon(...),  // Optionnel
  readOnly: false,
  onTap: () {}  // Pour date picker, etc.
)
```

Propriétés:
- Arrondi: 50% rayon (pill)
- Padding: 20px horizontal, 20px vertical
- Focus: bordure noire 1.5px
- Pas de bordure au repos

#### Scaffolds spécialisés

##### `OnboardingScaffold`
Wrapper pour les écrans onboarding:
```dart
OnboardingScaffold(
  child: Column(...),
  showBack: true,
  showSkip: true,
  onBack: () {},
  onSkip: () {}
)
```

Propriétés:
- Gradient bg (bgGradient)
- Bouton retour top-left
- Lien skip top-right
- SafeArea

---

### **shared/widgets/profile_widgets.dart**

Composants spécifiques au profil et paramètres.

#### `SectionLabel`
Label pour une section (petit texte gris):
```dart
SectionLabel('My Account')
```

#### `FieldLabel`
Label pour un champ de saisie:
```dart
FieldLabel('Full Name')
```

#### `InfoField`
Affiche une info en read-only (fond gris):
```dart
InfoField(
  text: 'Sara Hoseini',
  trailing: Icons.edit_outlined  // Optionnel
)
```

#### `MenuItemData` et `MenuGroup`
Crée des sections de menu cliquables:

```dart
MenuItemData(
  'Personal Information',  // titre
  Icons.person_outline,    // icône
  () => context.go('/profile/personal-info'),  // callback
  trailingText: '2 days',  // optionnel
  danger: false            // rouge si true
)

MenuGroup(items: [item1, item2, ...])
// Affiche une liste d'items avec séparateurs
```

#### `ToggleItemData` et `ToggleGroup`
Switches avec icônes:

```dart
ToggleItemData(
  'Allow Notifications',
  settings.allowNotifications,
  (value) => ref.read(settingsProvider.notifier).patch(...)
)

ToggleGroup(items: [toggle1, toggle2, ...])
```

Icônes intelligentes basées sur le titre:
```dart
_toggleIcon('Cycle') → Icons.autorenew_rounded
_toggleIcon('Face ID') → Icons.fingerprint_rounded
_toggleIcon('Partner') → Icons.people_alt_outlined
```

---

## 🎯 COUCHE FEATURES - MODULES MÉTIER

Chaque feature suit un pattern Clean Architecture:

```
features/<module>/
├── data/
│   ├── models/          # Entités Hive/JSON
│   ├── repositories/    # Persistance
│   └── datasources/     # (optionnel) API calls
├── domain/
│   ├── entities/        # (optionnel) Entités métier
│   ├── repositories/    # (optionnel) Interfaces
│   └── usecases/        # (optionnel) Logique métier
└── presentation/
    ├── providers/       # Riverpod StateNotifiers
    ├── screens/         # Pages complètes
    └── widgets/         # Composants locaux
```

---

### **Module: ONBOARDING**

Flux d'embarquement utilisateur.

#### Fichiers clés

**data/models/**
- N/A (données collectées en mémoire ou via repo profil)

**presentation/screens/**
- `splash.dart`: Écran de chargement initial
- `onboarding_screens.dart`: Welcome screen
- `ask_name_screen.dart`: Saisie du nom
- `date_of_birth_screen.dart`: Date de naissance
- `set_goals_screen.dart`: Objectifs utilisateur
- `set_last_period_screen.dart`: Dernières règles

#### Flux principal

```
Splash
  ↓
/welcome (WelcomeScreen)
  ↓
/ask-name (AskNameScreen)
  ↓
/date-of-birth (DateOfBirthScreen)
  ↓
/set-goals (SetGoalsScreen)
  ↓
/last-period (SetLastPeriodScreen)
  ↓
/home (Accès app complète)
```

#### Méthodes clés par écran

**WelcomeScreen**
```dart
build(context) → OnboardingScaffold
// Affiche logo + titre + CTA "Get Started"
// Route vers /ask-name
```

**AskNameScreen**
```dart
_onNameChanged(String name) → met à jour controller
_continuePressed() → sauvegarde + navigue vers /date-of-birth
```

**SetLastPeriodScreen**
```dart
_selectDate() → date picker
_continuePeriod() → sauvegarde lastPeriodStart + navigue /home
```

---

### **Module: AUTH**

Authentification email + OTP.

#### Fichiers clés

**presentation/screens/**
- `auth_screens.dart`: RegisterScreen
- `register_screen.dart`: Détails complets
- `otp_screen.dart`: Vérification OTP

#### Flux principal

```
/register (RegisterScreen)
  ↓
/email (ContinueWithEmailScreen)
  ↓
/create-account (CreateAccountScreen - mot de passe)
  ↓
/otp (OtpScreen - vérification code)
  ↓
/ask-name (Onboarding complet ou app accès)
```

#### Méthodes clés

**RegisterScreen**
```dart
_continueWithEmail() 
  → Vérifie email format
  → Route vers /email

_continueWithGoogle() 
  → Placeholder (non connecté)
```

**OtpScreen**
```dart
_onCodeChanged(String code) 
  → Met à jour pins (array de 6 chars)
  → Active/désactive bouton selon complétude

_verifyOtp() 
  → Validation locale
  → Navigation vers onboarding/home
```

**État**: Authentification complètement UI (pas de backend actuellement).

---

### **Module: HOME / CYCLE DASHBOARD**

Tableau de bord principal avec visualisation du cycle.

#### Fichiers clés

**presentation/screens/**
- `cycle_home_screen.dart`: Écran complet avec widgets complexes

**presentation/providers/**
- Intègre `CycleProvider` (logique cycle)
- Intègre `UserProfileProvider` (données utilisateur)

#### Structure d'écran

```
AppBar
  ← Notifications + Profil buttons

CycleWheel (CustomPainter animé)
  └ Phase actuelle (menstrual/follicular/ovulation/luteal)
  └ Jour du cycle (1..28)

WeeklyCalendarStrip
  └ 7 jours à défiler
  └ Marque le jour actuel
  └ Colore phase pour chaque jour

QuickActionButtons
  └ Log Period (icône + label)
  └ Log Symptoms (icône + label)

ArticleCarousel
  └ Affiche 2-3 articles d'éducation
  └ Défilable horizontalement

BottomNav personnalisée
  └ Home, Calendar, Journal, Profile
```

#### Enum et modèles

```dart
enum CyclePhase { menstrual, follicular, ovulation, luteal }

class CyclePhaseInfo {
  final String name;
  final Color color;
  final String emoji;
  final String shortDescription;
}
```

#### Méthodes clés

**_computeCyclePhase()**
```dart
// Basé sur lastPeriodStart + cycleLengthDays
// Retourne CyclePhase + dayOfCycle (1..N)
```

**_buildCycleWheel()**
```dart
// CustomPaint animé (rotation + pulse)
// Affiche phase + jour + pourcentage
```

**_openQuickLogSheet(CycleAction action)**
```dart
// Modal bottom sheet pour:
// - Sélectionner date période
// - Saisir symptômes rapides
// - Valider et sauvegarder
```

**_navigateToCalendar()**
```dart
context.go('/calendar')
```

---

### **Module: CALENDAR / SYMPTOMS**

Calendrier mensuel et suivi symptômes.

#### Fichiers clés

**presentation/screens/**
- `calendar_screen.dart`: Calendrier + actions
- `edit_calendar_screen.dart`: Édition période
- `symptoms_screen.dart`: Suivi symptômes

#### CalendarScreen - Méthodes clés

```dart
_buildMonthlyCalendar()
  // Affiche 42 jours (6 lignes × 7 jours)
  // Colore en fonction de l'état (period/ovulation/normal)
  // Tap jour → affiche infos ou édite

_isSameDay(date1, date2)
  // Utilitaire comparaison jour

_getPhaseColor(DateTime day)
  // Retourne couleur phase pour ce jour
  // Rouge menstrual, rose ovulation, etc.

_editPeriodRange()
  // Lance EditCalendarScreen
```

#### EditCalendarScreen - Méthodes clés

```dart
_selectStartDate()
  // Date picker
  
_selectEndDate()
  // Date picker optionnel
  
_savePeriodRange()
  // Crée PeriodLog + sauvegarde via PeriodRepository
  // Pop vers calendar
```

#### SymptomsScreen - Méthodes clés

```dart
_buildSymptomChips()
  // Affiche chips sélectionnables:
  // Cramps, Headache, Mood, Energy, etc.

_addSupportEntry(type)
  // Ajoute entrée Water/Weight/Notes
  // Affiche input ou nombre selector

_saveSymptomLog()
  // Sauvegarde liste symptômes + date
  // Retour à home
```

---

### **Module: CYCLE**

Logique métier du cycle menstruel (moteur calcul).

#### Fichiers clés

**data/models/**
- `period_log.dart`: @HiveType typeId=2
  ```dart
  class PeriodLog {
    final String id;
    final DateTime startDate;
    final DateTime? endDate;      // optionnel
    final List<String> notes;
    final int daysLogged;         // calcul: endDate - startDate
  }
  ```

**data/repositories/**
- `period_repository.dart`: CRUD pour PeriodLog

**domain/**
- `cycle_engine.dart`: **Cœur métier**
  ```dart
  class CycleEngine {
    static CycleStatus compute({
      required DateTime lastPeriodStart,
      required int cycleLengthDays,
      required int periodLengthDays,
    })
    
    // Retourne:
    // - dayOfCycle (1..cycleLengthDays)
    // - phase (menstrual/follicular/ovulation/luteal)
    // - nextPeriodStart
    // - ovulationWindow
  }
  ```

- `cycle_status.dart`: Modèle immuable
  ```dart
  class CycleStatus {
    final DateTime lastPeriodStart;
    final int cycleLengthDays;
    final int periodLengthDays;
    final int dayOfCycle;
    final CyclePhase phase;
    final DateTime nextPeriodStart;
    final DateRange ovulationWindow;
  }
  ```

**presentation/providers/**
- `cycle_provider.dart`:
  ```dart
  final cycleProvider = StateNotifierProvider((ref) {
    final profile = ref.watch(userProfileProvider);
    final settings = ref.watch(appSettingsProvider);
    
    return CycleNotifier(profile, settings);
  })
  // Combine profil + settings pour calculer status
  ```

#### Formules clés

```dart
// Jour du cycle actuel
dayOfCycle = ((daysElapsed % cycleLengthDays) + 1)
           .clamp(1, cycleLengthDays)

// Phase menstruelle
isMenstrual = dayOfCycle <= periodLengthDays

// Ovulation (généralement J14)
ovulationCycleDay = (cycleLengthDays - 14).clamp(1, cycleLengthDays)

// Fenêtre fertile (5 jours avant ovulation + jour même)
fertilityWindow = [ovulationDay - 5, ovulationDay]

// Prochain début de règles
nextPeriodStart = lastPeriodStart + Duration(days: cycleLengthDays)
```

---

### **Module: JOURNAL**

Journal intime sécurisé avec persistance Hive chiffrée.

#### Fichiers clés

**data/models/**
- `journal_entry.dart`: @HiveType typeId=1
  ```dart
  class JournalEntry {
    final String id;
    final DateTime createdAt;
    final DateTime updatedAt;
    final String title;
    final String content;
    final String mood;  // calm, happy, sad, angry, etc.
  }
  ```

**data/repositories/**
- `journal_repository.dart`:
  ```dart
  Future<List<JournalEntry>> loadEntries()
    // Box.values.toList()
  
  Future<void> upsert(JournalEntry entry)
    // Box.put(entry.id, entry)
  
  Future<void> delete(String id)
    // Box.delete(id)
  ```

**presentation/providers/**
- `journal_provider.dart`:
  ```dart
  final journalProvider = StateNotifierProvider((ref) {
    return JournalNotifier(ref.read(journalRepositoryProvider));
  })
  
  class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
    Future<void> load()     // Charge tous
    Future<void> upsert()   // Crée ou met à jour
    Future<void> delete()   // Supprime
  }
  ```

**presentation/screens/**
- `journal_screens.dart`:
  - `JournalListScreen`: Liste + calendrier + recherche
  - `JournalDetailScreen`: Édition d'une entrée
  - `JournalQuickLogSheet`: Modal rapide (mood + note)

#### JournalListScreen - Méthodes clés

```dart
_buildCalendarView()
  // Calendrier avec jours contenant entrées en gras

_buildEntryList()
  // Filtre par date sélectionnée OU recherche
  // Affiche entries triées par date DESC

_filterEntries(String query)
  // Recherche sur title + content + mood
  // Case-insensitive

_deleteEntry(String id)
  // Supprime via journalProvider.notifier
  // Reload liste
```

#### Sécurité

- **Stockage**: Hive box chiffrée (AES-256)
- **Clé**: Générée et stockée en `flutter_secure_storage`
- **Accès app**: PIN/Biométrie (futur: LocalAuthProvider)

---

### **Module: SELF-CARE / ÉDUCATION**

Contenus d'auto-soin et éducation pédagogique.

#### Fichiers clés

**presentation/screens/**
- `self_care_home_screen.dart`: Page principale
- `activity_detail_screen.dart`: Détail activité
- `article_detail_screen.dart`: Détail article
- `meditation_screen.dart`: Liste méditations
- `strength_detail_screen.dart`: Entraînement force
- `skincare_screen.dart`: Routines skincare

**presentation/data/**
- `self_care_data.dart`: Mock de contenu

#### SelfCareHomeScreen - Structure

```
AppBar (custom back button)

Categories Tabs
  └ Activités, Articles, Méditation, Bien-être

Hero Card (Méditation)
  └ Grand visuel + CTA "Start"

ContentGrid
  └ Cards pour articles/activités
  └ Affiche image/titre/durée
```

#### Méthodes clés

**_buildActivityCard(Activity activity)**
```dart
// Hero animation vers detail
// Affiche durée, catégorie, image
```

**_openArticleDetail(Article article)**
```dart
// Navigate vers ArticleDetailScreen
// Affiche contenu long-form
```

**_startMeditation(Meditation med)**
```dart
// Navigate vers MeditationScreen
// Démarrage chrono + audio
```

---

### **Module: AI**

Assistant IA avec voice input.

#### Fichiers clés

**presentation/screens/**
- `ai_chat_screen.dart`: Chat interface
- Voice interface (future)

#### ChatScreen - Méthodes clés

```dart
_sendMessage(String text)
  // Affiche message utilisateur
  // Simule réponse IA (placeholder)
  // Affiche réponse

_recordVoice()
  // Futur: intégration speech_to_text
```

**État**: Actuellement mock avec réponses statiques.

---

### **Module: PROFILE**

Gestion profil et paramètres sécurisés.

#### Fichiers clés

**data/models/**
- `user_profile.dart`: @HiveType typeId=3
  ```dart
  class UserProfile {
    final String? displayName;
    final DateTime? dateOfBirth;
    final int averageCycleLengthDays;  // 21..35
    final int periodLengthDays;        // 2..12
    final DateTime? lastPeriodStart;
    final bool isCycleRegular;
  }
  ```

**data/repositories/**
- `user_profile_repository.dart`: CRUD
- `security_repository.dart`: PIN + app lock
  ```dart
  Future<bool> loadAppLockEnabled()
  Future<void> setAppLockEnabled(bool)
  Future<bool> hasPin()
  Future<void> savePin(String pin)
  Future<bool> verifyPin(String pin)
  Future<void> deletePin()
  ```

**presentation/providers/**
- `user_profile_provider.dart`: StateNotifier
- `security_provider.dart`: StateNotifier pour sécurité

**presentation/screens/**
- `profile_screens.dart`: Page principale
- `personal_info.dart`: **Éditeur données cycle**
  - Saisie date naissance
  - Durée cycle (21..35 jours) — **validation stricte**
  - Durée règles (2..12 jours)
  - Dernières règles (date picker)
  - Régularité (toggle)
  - **Sauvegarde immédiate** après chaque changement
  
- `security.dart`: Verrou PIN
  - Toggle "App Lock"
  - Modal PIN (4-6 chiffres)
  - Changement / suppression PIN
  - Toggle Face ID

- `settings.dart`:
  - Durée cycle / règles (selectors)
  - Préférences notifications cycle
  - Integrations (placeholder)

- `notification.dart`:
  - Allow Notifications
  - Cycle predictions (period starting, fertile window, ovulation)
  - Reminders (log symptoms, partner updates)

- `partner_screen.dart`: Partage partenaire

#### PersonalInformationScreen - Méthodes clés

```dart
_pickDate(context, initialDate)
  // DatePicker → retourne DateTime
  // Sauvegarde immédiatement via userProfileProvider.notifier.patch()

_pickNumber(context, min, max)
  // BottomSheet avec nombres 21..35 (ou 2..12)
  // Validation range
  // Sauvegarde immédiatement

// Tous les changements → patch() + AsyncValue.data()
// Aucune form validation globale, juste range checks
// Feedback immédiat via UI rafraîchie
```

#### Security Screen - Méthodes clés

```dart
_showPinDialog(isNew: bool)
  // AlertDialog avec 2 TextFormFields
  // Valide: min 4 chiffres, match confirmation
  // Sauvegarde + met à jour state

// Toggle App Lock
// - Si activé + pas de PIN → ouvre dialog PIN
// - Si désactivé → supprime PIN + désactive verrou
```

---

## 🔄 RIVERPOD STATE MANAGEMENT

Chaque module utilise ce pattern:

```dart
// 1. Provider du repository
final <module>RepositoryProvider = Provider((ref) {
  return <Module>Repository();
});

// 2. StateNotifier pour gestion d'état
class <Module>Notifier extends StateNotifier<AsyncValue<T>> {
  <Module>Notifier(this._repository) 
    : super(const AsyncValue.loading());
    
  final <Module>Repository _repository;
  
  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.load);
  }
  
  Future<void> update(T value) async {
    state = AsyncValue.data(value);
    await _repository.save(value);
  }
  
  Future<void> patch(T Function(T) builder) async {
    final current = state.valueOrNull ?? defaultValue;
    final next = builder(current);
    await update(next);
  }
}

// 3. Provider du StateNotifier
final <module>Provider = StateNotifierProvider((ref) {
  final notifier = <Module>Notifier(ref.read(<module>RepositoryProvider));
  notifier.load();
  return notifier;
});

// 4. Utilisation dans widgets
final state = ref.watch(<module>Provider);
state.when(
  data: (value) => ...use value...,
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget()
)

// 5. Mise à jour
ref.read(<module>Provider.notifier).patch(
  (current) => current.copyWith(field: newValue)
)
```

### Exemples spécifiques

**UserProfileProvider** (profil utilisateur):
```dart
ref.watch(userProfileProvider).when(
  data: (profile) {
    print(profile.averageCycleLengthDays);  // Lecture
    ref.read(userProfileProvider.notifier).patch(
      (current) => current.copyWith(
        periodLengthDays: 6
      )
    );  // Mise à jour + sauvegarde Hive
  },
  ...
)
```

**JournalProvider** (journal):
```dart
ref.watch(journalProvider).when(
  data: (entries) {
    ref.read(journalProvider.notifier).upsert(newEntry);  // Ajoute/met à jour
  },
  ...
)
```

**CycleProvider** (calcul cycle):
```dart
// Dépend de userProfileProvider + appSettingsProvider
// Calcule automatiquement CycleStatus
final cycle = ref.watch(cycleProvider);  // RETour automatique si profil change
```

---

## 🎨 DESIGN PATTERNS UTILISÉS

### 1. **Immuabilité (copyWith)**
```dart
final newProfile = profile.copyWith(displayName: 'Sara');
// Crée nouvelle instance avec champs modifiés
```

### 2. **AsyncValue** (gestion erreurs Riverpod)
```dart
AsyncValue.loading()    // Chargement
AsyncValue.data(value)  // Succès
AsyncValue.error(e, st) // Erreur
```

### 3. **Custom Painters** (Cycle Wheel)
```dart
class CycleWheelPainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    // Dessine cercle animé + phases + jour
  }
  
  bool shouldRepaint(CycleWheelPainter oldDelegate) => ...
}
```

### 4. **Slide Transitions** (Navigation)
```dart
PageRouteBuilder(
  transitionsBuilder: (context, anim, anim2, child) {
    return SlideTransition(
      position: Tween(begin: Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: anim, curve: easeOutCubic)),
      child: child
    );
  }
)
```

---

## 📊 FLUX DE DONNÉES GLOBAL

```
main.dart
  ↓
HiveSetup.init()          # Chiffrement + initialisation Hive
  ↓
PeriaApp (MaterialApp.router)
  ↓
appRouter (GoRouter)      # Navigation centralisée
  ↓
Screens (ConsumerWidget/ConsumerStatefulWidget)
  ↓
Riverpod Providers        # StateNotifiers
  ↓
Repositories              # Hive / SharedPreferences
  ↓
Stockage local chiffré    # Données persistées
```

### Exemple: Mise à jour durée cycle

```
User → Personal Info Screen
  ↓
_pickNumber() → affiche modal
  ↓
User sélectionne "30 jours"
  ↓
ref.read(userProfileProvider.notifier).patch(...)
  ↓
UserProfileNotifier.patch()
  ↓
await _repository.save(newProfile)
  ↓
Hive.box<UserProfile>().put(0, newProfile)  # Chiffré
  ↓
UI refresh automatique (watch)
  ↓
CycleProvider recalcule automatiquement
  ↓
Home dashboard met à jour le cycle visuel
```

---

## 🔐 SÉCURITÉ ET CONFIDENTIALITÉ

### 1. **Journa Chiffré**
- **Stockage**: Hive AES-256
- **Clé**: `flutter_secure_storage` (Keychain/Keystore)
- **Accès**: PIN/Biométrie (futur)

### 2. **Profil utilisateur**
- **Stockage**: Hive chiffré (même clé)
- **Données critiques**: Durée cycle, lastPeriodStart
- **Pas d'email/auth persisté** (anonyme par défaut)

### 3. **Paramètres**
- **Stockage**: SharedPreferences (non sensibles)
- **Contenu**: notifications, durée cycle, app lock flag

### 4. **Mise en mémoire**
- Aucun mot de passe en mémoire
- PIN vérifié localement (jamais transféré)

---

## 📋 PROCHAINES ÉTAPES DE DÉVELOPPEMENT

### Phase 1 ✅ (Fait)
- ✅ Architecture feature-first
- ✅ Hive + chiffrement
- ✅ Profil utilisateur (cycle data)
- ✅ Journal sécurisé
- ✅ Cycle engine

### Phase 2 (En cours)
- 🔄 Biométrie (local_auth)
- 🔄 Validation formulaires
- 🔄 Intégration Firebase (optionnel)

### Phase 3 (Futur)
- ⬜ Backend API cycle predictions
- ⬜ Notifications locales (flutter_local_notifications)
- ⬜ Partage partenaire sécurisé
- ⬜ Analytics (Sentry)

---

## 📞 CONTACT / SUPPORT

Pour toute question sur l'architecture:
- Consulter `PROJECT_DOCUMENTATION.md`
- Consulter `IMPLEMENTATION_PLAN.md`
- Consulter `ARCHITECTURE_REORGANISEE.md`

---

**Dernière mise à jour**: Avril 2026  
**Version app**: 1.0.0+1  
**Status**: MVP – Production-ready UI, logique métier en cours
