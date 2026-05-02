# Peria Project Documentation

## 1. Overview

`Peria` is a Flutter mobile application focused on menstrual cycle tracking, self-care guidance, AI-assisted coaching, symptom logging, and partner-sharing features.

The project has been structured around a feature-first architecture and a UI implementation driven by the design mockups available in the [`moc/`](/g:/flutter/flutter/NewApp/peria/moc) folder.

The current application includes the following major product areas:

- onboarding
- authentication
- cycle home dashboard
- calendar and symptom tracking
- self-care content and exercise flows
- AI assistant and voice interaction
- profile, settings, notifications, and account security
- partner invitation and sharing management

---

## 2. Technical Stack

### Framework

- Flutter
- Dart SDK `>=3.0.0 <4.0.0`

### Main packages

- `go_router`
  Used for route-based navigation and screen transitions.

- `flutter_riverpod`
  Present in dependencies for state management evolution.
  The current codebase is still mostly UI-driven and local-state based.

- `shared_preferences`
  Available for lightweight local persistence.

- `dio`
  Available for future API integration.

- `flutter_svg`
  Available for vector asset support.

---

## 3. Entry Point

Main application entry:

- [main.dart](/g:/flutter/flutter/NewApp/peria/lib/main.dart)

The app boots through:

```dart
void main() {
  runApp(const PeriaApp());
}
```

The root widget uses `MaterialApp.router` with:

- app title: `Peria`
- `debugShowCheckedModeBanner: false`
- `useMaterial3: true`
- `routerConfig: appRouter`

---

## 4. Project Structure

### Root-level folders

- `lib/`
  Main source code.

- `assets/images/`
  Core application images and icons.

- `moc/`
  Visual source-of-truth mockups used to implement and refine screens.

- `android/`, `ios/`, `web/`, `windows/`, `linux/`, `macos/`
  Flutter platform folders.

### `lib/` structure

- `lib/core/`
  Cross-cutting technical foundation.

- `lib/shared/`
  Reusable widgets.

- `lib/features/`
  Business and UI features organized by module.

---

## 5. Core Layer

### 5.1 Routing

Router file:

- [router.dart](/g:/flutter/flutter/NewApp/peria/lib/core/router/router.dart)

Navigation is centralized with `GoRouter`.

All routes currently available:

### Onboarding and Auth

- `/welcome`
- `/register`
- `/email`
- `/create-account`
- `/otp`
- `/ask-name`
- `/date-of-birth`
- `/set-goals`
- `/last-period`

### Main App

- `/home`
- `/calendar`
- `/edit-calendar`
- `/symptoms`

### AI

- `/ai`
- `/ai/voice`
- `/ai/appointment`

### Self-care

- `/self-care`
- `/self-care/article`
- `/self-care/activity-detail`
- `/self-care/activity-step`
- `/self-care/timer`
- `/self-care/meditation`
- `/self-care/skincare`
- `/self-care/strength`
- `/self-care/congratulations`

### Profile and Settings

- `/notification`
- `/profile`
- `/profile/personal-info`
- `/profile/settings`
- `/profile/notifications`
- `/profile/account-security`
- `/profile/partner`
- `/profile/partner/invite`
- `/profile/partner/pending`
- `/profile/partner/connected`
- `/profile/partner/sharing`

### Route transitions

Every route uses a slide-in transition through `_buildSlideTransitionPage`.

Transition characteristics:

- begin: `Offset(1.0, 0)`
- end: `Offset.zero`
- curve: `easeOutCubic`
- duration: `300ms`

---

## 6. Theme and Design System

### Theme files

- [theme.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/theme.dart)
- [app_colors.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_colors.dart)
- [app_text.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_text.dart)
- [app_typography.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_typography.dart)
- [app_spacing.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_spacing.dart)
- [app_theme.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_theme.dart)

### Visual identity

The app uses a soft wellness visual language:

- white backgrounds
- pink and lavender gradients
- rounded cards
- soft shadows
- dark CTA buttons
- light neutral containers

### Main color families

- primary pink
- secondary lavender
- neutral greys
- success green
- warning yellow
- error red
- info blue

### Main gradient used across screens

`AppColors.bgGradient`

Typical gradient progression:

- white
- very light pink
- very light lavender

### Typography

Typography is exposed through `AppText` and based on `AppTypography`.

Most used levels:

- `AppText.h1`
- `AppText.h2`
- `AppText.h3`
- `AppText.h4`
- `AppText.body`
- `AppText.label`
- `AppText.caption`

### Important note about fonts

The code references a custom family called `PerlApp` in typography, while `main.dart` currently sets `fontFamily: 'Poppins'`.

This means:

- visual consistency is currently acceptable if Poppins is available
- long-term integration should align font registration and actual theme usage

---

## 7. Shared Widgets

Shared widget file:

- [common_widgets.dart](/g:/flutter/flutter/NewApp/peria/lib/shared/widgets/common_widgets.dart)

Main reusable widgets:

- `PrimaryButton`
  Black pill CTA with white text.

- `OutlineButton`
  White button with dark border.

- `SocialButton`
  Social auth style button.

- `BackIconButton`
  Reusable rounded back button.

- `PillTextField`
  Rounded light input field.

- `OnboardingScaffold`
  Scaffold helper for onboarding screens with optional back and skip.

- `PageScaffold`
  Generic screen scaffold with background gradient, back button, and optional title.

Bottom navigation:

- [custom_bottom_nav.dart](/g:/flutter/flutter/NewApp/peria/lib/shared/widgets/custom_bottom_nav.dart)

Bottom nav items:

- `cycle`
- `ai`
- `journal`

---

## 8. Features Overview

## 8.1 Onboarding

Folder:

- `lib/features/onboarding/presentation/screens/`

Main screens:

- `WelcomeScreen`
- `AskNameScreen`
- `DateOfBirthScreen`
- `SetGoalsScreen`
- `SetLastPeriodScreen`

Purpose:

- introduce the product
- collect basic identity
- collect date of birth
- collect user goals
- collect last period information

Design notes:

- strong use of center compositions
- illustration-led layout
- large top spacing
- dark CTA at the bottom

---

## 8.2 Authentication

Folder:

- `lib/features/auth/presentation/screens/`

Main screens:

- `RegisterScreen`
- `ContinueWithEmailScreen`
- `CreateAccountScreen`
- `OtpScreen`

Purpose:

- email-based account entry
- password creation
- OTP confirmation

Integration state:

- UI is implemented
- auth actions are still placeholders
- Google and Apple auth remain non-connected
- forgot password flow remains non-connected

---

## 8.3 Home / Cycle Dashboard

Main file:

- [cycle_home_screen.dart](/g:/flutter/flutter/NewApp/peria/lib/features/home/presentation/screens/cycle_home_screen.dart)

This is the main cycle dashboard.

Responsibilities:

- display the current cycle phase
- show animated circular cycle visualization
- display weekly calendar strip
- allow symptom and period logging
- provide shortcuts to notifications, calendar, profile, AI, and journal

Special note:

This screen contains a large amount of custom UI and painter-based logic.
It is one of the most design-sensitive files in the project.

Subsystems inside the file:

- app bar
- animated cycle wheel
- weekly calendar
- log buttons
- article row
- floating bottom nav

---

## 8.4 Calendar and Symptoms

Folder:

- `lib/features/calendar/presentation/screens/`

Main screens:

- `CalendarScreen`
- `EditCalendarScreen`
- `SymptomsScreen`

### CalendarScreen

Responsibilities:

- monthly calendar display
- visual state for period, PMS, and ovulation days
- entry point to editing period data
- entry point to symptom logging

### EditCalendarScreen

Responsibilities:

- pick a start and optional end date range
- save period range

### SymptomsScreen

Responsibilities:

- symptom categories
- date scroller
- symptom chips
- tracking cards for water, weight, and notes
- bottom sheets for editing support entries

---

## 8.5 Self-care

Folder:

- `lib/features/self_care/presentation/screens/`

Main screens:

- `SelfCareHomeScreen`
- `ActivityDetailScreen`
- `ActivityStepScreen`
- `ActivityTimerScreen`
- `MeditationScreen`
- `SkincareScreen`
- `StrengthDetailScreen`
- `ArticleDetailScreen`
- `CongratulationsScreen`

Support data file:

- [self_care_data.dart](/g:/flutter/flutter/NewApp/peria/lib/features/self_care/presentation/screens/self_care_data.dart)

### SelfCareHomeScreen

Responsibilities:

- display learning categories and sections
- expose self-care cards
- expose meditation hero card
- route to activity, article, skincare, meditation, and strength flows

### Activity screens

The self-care module includes:

- overview screen
- step-by-step exercise screen
- timer screen
- strength variant
- skincare guided flow
- meditation list
- completion state

Most content is mock-driven and currently static by design, ready for future API or CMS replacement.

---

## 8.6 AI Assistant

Folder:

- `lib/features/ai/presentation/screens/`

Main screens:

- `AiChatScreen`
- `VoiceChatScreen`
- `AppointmentConfirmationScreen`

### AiChatScreen

Responsibilities:

- display the assistant persona
- show conversational health coaching
- present suggestion cards
- present article recommendation
- present symptom summary card
- present schedule conflict card
- route to article, symptoms, voice chat, and appointment confirmation

### VoiceChatScreen

Responsibilities:

- provide the voice interaction visual state
- expose close and microphone actions

### AppointmentConfirmationScreen

Responsibilities:

- show appointment confirmation
- display doctor card
- display meeting time and modality
- return user to AI chat

---

## 8.7 Profile, Settings, Partner

Folder:

- `lib/features/profile/presentation/screens/`

Main screens:

- `ProfileScreen`
- `PersonalInformationScreen`
- `SettingsScreen`
- `NotificationsScreen`
- `AccountSecurityScreen`
- `PartnerScreen`
- `InvitePartnerScreen`
- `PartnerInvitationPendingScreen`
- `ConnectedPartnerScreen`
- `SharingSettingsScreen`

### ProfileScreen

Responsibilities:

- account hub
- access to personal info
- access to partner management
- access to account and security
- access to app settings and notifications

### PersonalInformationScreen

Responsibilities:

- display or edit basic personal information
- expose profile edit mode

### SettingsScreen

Responsibilities:

- appearance
- cycle settings
- integrations and sync
- privacy and app version

### NotificationsScreen

Responsibilities:

- app notification master toggle
- cycle alerts
- reminder settings

### AccountSecurityScreen

Responsibilities:

- email and password account actions
- 2FA and Face ID toggles
- delete account action

### Partner flow

The partner feature currently supports a complete mock flow:

- disconnected partner state
- invite partner
- invitation sent modal
- pending approval state
- connected state
- sharing settings
- disconnect confirmation modal

This module is visually important because it mirrors several dedicated mockups in `moc/`.

---

## 9. Assets

### Registered asset roots

From `pubspec.yaml`:

- `assets/images/onboarding/`
- `assets/images/logo/`
- `assets/images/icons/`
- `assets/images/`
- `moc/`

### Asset categories

#### App production assets

- logos
- onboarding images
- icons
- some generic illustrations

#### Mockup assets

The `moc/` folder serves as:

- screen-by-screen visual reference
- source for some reused in-app images
- product design archive

Because of this, some screens directly use images from `moc/` to stay visually close to the approved mockups.

---

## 10. Navigation Flows

### Primary onboarding flow

```text
/welcome
  -> /register
  -> /email
  -> /create-account
  -> /otp
  -> /ask-name
  -> /date-of-birth
  -> /set-goals
  -> /last-period
  -> /home
```

### Main application navigation

```text
/home
  -> /calendar
  -> /symptoms
  -> /self-care
  -> /ai
  -> /profile
```

### Self-care flow

```text
/self-care
  -> /self-care/activity-detail
  -> /self-care/activity-step
  -> /self-care/timer
  -> /self-care/congratulations

/self-care
  -> /self-care/article

/self-care
  -> /self-care/meditation

/self-care
  -> /self-care/skincare

/self-care
  -> /self-care/strength
```

### AI flow

```text
/ai
  -> /ai/voice
  -> /ai/appointment
  -> /symptoms
  -> /self-care/article
```

### Profile flow

```text
/profile
  -> /profile/personal-info
  -> /profile/settings
  -> /profile/notifications
  -> /profile/account-security
  -> /profile/partner
      -> /profile/partner/invite
      -> /profile/partner/pending
      -> /profile/partner/connected
      -> /profile/partner/sharing
```

---

## 11. Current State of Data and Logic

At this stage, the codebase is largely UI-first and mock-driven.

This means:

- many screens use static content
- route structure is ready
- visual flow is mostly in place
- network calls are not yet wired
- persistence is not yet fully wired
- Riverpod is installed but not deeply used yet

### What is production-ready from a UI perspective

- multi-module screen architecture
- route map
- reusable core UI primitives
- design language consistency
- partner and AI showcase flows
- self-care showcase flows

### What still needs backend integration

- authentication
- OTP verification
- saving profile changes
- settings persistence
- calendar persistence
- symptoms persistence
- partner invitation backend
- AI chat backend
- appointment booking backend

---

## 12. Known Technical Considerations

### 12.1 Mixed maturity across modules

Some files are highly refined and mock-aligned.
Others still contain placeholder behavior or static data behind a polished UI.

### 12.2 Asset path consistency

Several paths were normalized to `assets/images/...` and `moc/...`.
Any future asset move should be reflected carefully in:

- onboarding
- auth
- home
- AI
- profile

### 12.3 Font consistency

Typography files reference `PerlApp`, while app theme uses `Poppins`.
For final integration, this should be standardized.

### 12.4 Large screen-specific files

Some files are intentionally large because they encode complex mockups directly.
Most notable:

- `cycle_home_screen.dart`
- `profile_screens.dart`
- `ai_chat_screen.dart`

If the app evolves functionally, these should gradually be split into:

- widgets
- sections
- data models
- state controllers

---

## 13. Recommended Next Integration Steps

### Short-term

1. Run `flutter analyze` and resolve all warnings that affect maintainability.
2. Standardize font setup between `Poppins` and `PerlApp`.
3. Replace remaining static actions with real handlers.
4. Introduce feature-level state using Riverpod where interactions become dynamic.

### Medium-term

1. Add repositories and service layers for auth, profile, cycle, symptoms, and AI.
2. Move static mock data into dedicated data providers.
3. Split oversized UI files into reusable sections.
4. Add widget tests for navigation-critical flows.

### Long-term

1. Connect backend APIs with `dio`.
2. Persist user state locally with `shared_preferences` or a stronger storage solution if needed.
3. Add analytics for onboarding completion, self-care engagement, and AI usage.

---

## 14. Important Files Index

### App bootstrap

- [main.dart](/g:/flutter/flutter/NewApp/peria/lib/main.dart)

### Routing

- [router.dart](/g:/flutter/flutter/NewApp/peria/lib/core/router/router.dart)

### Theme

- [theme.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/theme.dart)
- [app_colors.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_colors.dart)
- [app_text.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_text.dart)
- [app_typography.dart](/g:/flutter/flutter/NewApp/peria/lib/core/theme/app_typography.dart)

### Shared widgets

- [common_widgets.dart](/g:/flutter/flutter/NewApp/peria/lib/shared/widgets/common_widgets.dart)
- [custom_bottom_nav.dart](/g:/flutter/flutter/NewApp/peria/lib/shared/widgets/custom_bottom_nav.dart)

### Core product screens

- [cycle_home_screen.dart](/g:/flutter/flutter/NewApp/peria/lib/features/home/presentation/screens/cycle_home_screen.dart)
- [calendar_screen.dart](/g:/flutter/flutter/NewApp/peria/lib/features/calendar/presentation/screens/calendar_screen.dart)
- [symptoms_screen.dart](/g:/flutter/flutter/NewApp/peria/lib/features/calendar/presentation/screens/symptoms_screen.dart)
- [self_care_home_screen.dart](/g:/flutter/flutter/NewApp/peria/lib/features/self_care/presentation/screens/self_care_home_screen.dart)
- [ai_chat_screen.dart](/g:/flutter/flutter/NewApp/peria/lib/features/ai/presentation/screens/ai_chat_screen.dart)
- [profile_screens.dart](/g:/flutter/flutter/NewApp/peria/lib/features/profile/presentation/screens/profile_screens.dart)

---

## 15. Final Summary

`Peria` is currently a strongly visual, mock-driven Flutter application with a broad feature surface already mapped in code.

The project is in a strong UI integration state because:

- the major user journeys exist
- the route map is broad and coherent
- the mockups have been translated into real screens
- the codebase already contains reusable design primitives

The project is not yet fully product-complete from a backend perspective, but it is well-positioned for integration, modular growth, and UI refinement.

This documentation should be treated as the reference baseline for:

- developer onboarding
- QA navigation understanding
- integration planning
- future refactoring
- backend connection work
