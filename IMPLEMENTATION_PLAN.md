# Peria Implementation Plan

## 1. Objective

This document translates the product requirements from [cahier.md](/g:/flutter/flutter/NewApp/peria/cahier.md) into a concrete implementation roadmap for the current Flutter codebase.

It is designed to answer 4 questions:

1. what already exists in code
2. what is still missing
3. what must be built first
4. how to implement it cleanly in the current architecture

---

## 2. Product Baseline From Cahier des Charges

Peria must be:

- soft
- discreet
- educational
- non-judgmental
- privacy-first
- useful offline
- understandable for teenagers and adults

Non-negotiable product rules:

- no intrusive ads
- no selling personal data
- no medical diagnosis
- no moral judgment
- no overpromising prediction accuracy
- always preserve user control

That means the implementation must prioritize:

- local-first storage
- privacy controls
- disclaimer-safe AI
- transparent prediction logic
- partner sharing under strict consent
- safe educational UX

---

## 3. Current Project Status

## 3.1 Already Present

The codebase already contains substantial UI coverage for:

- onboarding
- authentication UI
- cycle home
- calendar and symptoms UI
- self-care UI
- AI assistant UI
- partner UI
- profile/settings UI

Existing feature folders:

- `auth`
- `onboarding`
- `home`
- `calendar`
- `self_care`
- `ai`
- `profile`
- `journal`
- `cycle` (data + prediction foundation)

## 3.2 Still Missing at Product Level

The following high-value product layers are not yet implemented or are only partially represented:

- encrypted local storage (journal and sensitive health logs are currently stored in `shared_preferences`)
- local persistence for symptoms (cycle periods + basic profile persistence now exist; symptoms still UI-only)
- privacy and security engine
- discreet mode behavior
- biometrics / app lock
- cycle prediction rules engine (MVP prediction logic now exists; still needs irregular-cycle mode and UX disclaimers)
- irregular cycle mode
- multilingual structure
- partner-sharing permissions model
- AI rules engine
- content management structure for educational materials

---

## 4. Gap Analysis: Cahier vs Current Code

## 4.1 Onboarding

### Cahier expects

- welcome
- values slides
- account creation
- name
- date of birth
- goals
- last period
- confirmation screen
- under-18 logic

### Current code

Implemented:

- welcome
- email/password path
- name
- DOB
- goals
- last period

Missing:

- dedicated values slides
- confirmation screen
- under-18 branch / parental consent branch
- adaptive content gating at onboarding level

### Priority

- medium

Reason:

The onboarding works visually, but legal and product branching is still incomplete.

---

## 4.2 Authentication

### Cahier expects

- email/password account
- optional Google/Apple

### Current code

Implemented:

- UI for register
- UI for email/password
- OTP screen UI

Missing:

- actual auth service
- form validation rules
- forgot password flow
- social sign-in
- token/session storage

### Priority

- high for Phase 2

---

## 4.3 Cycle Core

### Cahier expects

- animated cycle home
- weekly calendar
- monthly calendar
- log period
- log symptoms
- predictions based on past cycles
- irregular cycle mode
- cycle settings

### Current code

Implemented:

- strong cycle home UI
- monthly calendar UI
- edit period UI
- symptoms UI

Missing:

- real cycle data model
- saved history
- rolling prediction logic from last cycles
- irregular cycle mode behavior
- fertile window activation setting
- pill reminder logic
- distinction between estimated and reliable data

### Priority

- very high

Reason:

This is the core of the app and the main retention driver.

---

## 4.4 Symptoms Tracking

### Cahier expects

- physical symptoms
- emotional symptoms
- optional cervical mucus
- optional temperature
- weight
- hydration
- free notes

### Current code

Implemented:

- large symptom UI
- note, water, weight bottom sheets
- multiple category chips

Missing:

- structured symptom data model
- intensity model
- symptom history persistence
- analytics per cycle phase
- calendar overlay from logged symptoms

### Priority

- very high

---

## 4.5 AI Assistant

### Cahier expects

- simple educational chatbot
- non-diagnostic responses
- question suggestions
- educational routing
- medical disclaimer
- no overreach
- optional future lab interpretation
- optional appointment flow

### Current code

Implemented:

- chat UI
- voice UI
- article suggestion UI
- appointment confirmation UI

Missing:

- actual AI response engine
- safe prompt/rules layer
- disclaimer injection
- controlled topic matching
- structured quick-question chips
- local-only / consent-controlled conversation retention

### Priority

- high

Reason:

This is a differentiating feature, but also the highest risk feature if implemented incorrectly.

---

## 4.6 Journal

### Cahier expects

- private diary
- local-only storage
- mood tagging
- search
- export
- delete one/all
- code or biometric lock

### Current code

Implemented:

- bottom nav references `Journal`

Missing:

- full journal module
- journal routes
- secure local storage
- app lock for journal
- note CRUD
- search and export

### Priority

- critical

Reason:

The journal is explicitly part of the product identity and privacy promise.

---

## 4.7 Self-care / Education

### Cahier expects

- educational categories
- articles
- meditation
- yoga
- skincare
- pain relief
- pleasure content with age gating
- short, readable educational content

### Current code

Implemented:

- self-care landing
- article details
- activity flows
- meditation
- skincare
- strength

Missing:

- content structure by category
- age-gated pleasure mode
- educational taxonomy
- article repository
- trusted content validation workflow

### Priority

- medium-high

Reason:

The UI is already advanced; the next need is content architecture and rules.

---

## 4.8 Partner

### Cahier expects

- invite partner
- pending request
- connected state
- sharing controls
- revoke access
- partner cannot modify data
- controlled access by category

### Current code

Implemented:

- disconnected state
- invite partner
- invitation modal
- pending state
- connected state
- sharing settings
- disconnect modal

Missing:

- actual invite token / code logic
- permission model
- partner mode
- shareable dataset boundaries
- suspend without delete
- read-only partner layer

### Priority

- high

---

## 4.9 Settings / Privacy / Security

### Cahier expects

- profile editing
- notifications
- biometrics
- discreet mode
- journal lock
- language
- data export
- delete all data
- legal pages

### Current code

Implemented:

- profile
- personal information
- notifications UI
- account security UI
- general settings UI

Missing:

- discreet mode engine
- biometric implementation
- language system
- export feature
- delete all data flow
- legal content pages
- secure preference store

### Priority

- critical

Reason:

This directly supports the app’s promise of discretion and autonomy.

---

## 5. Recommended Implementation Architecture

The current project is feature-first in UI, but Phase 2 requires a clearer separation of concerns.

Recommended structure per feature:

```text
lib/features/<feature>/
  data/
    models/
    datasources/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    screens/
    widgets/
    controllers/
```

This does not need a massive refactor immediately.
It can be introduced incrementally starting with the highest-value modules.

---

## 6. Priority Build Order

## Phase A: Security and Local Persistence Foundation

Build first:

1. app-level local storage architecture
2. secure preferences wrapper
3. SQLite or encrypted local database setup
4. app settings persistence
5. biometric/lock abstraction

Reason:

Everything else depends on trusted local data and privacy guarantees.

### Deliverables

- `core/storage/`
- `core/security/`
- encrypted local repository pattern
- local settings repository

---

## Phase B: Journal Module

Build second because it is completely missing and strongly required by the cahier.

### Scope

- journal list screen
- journal editor screen
- mood selector
- search
- delete single/all
- optional export to text
- lock before access

### Suggested routes

- `/journal`
- `/journal/new`
- `/journal/:id`
- `/journal/settings`

### Suggested data model

```text
JournalEntry
- id
- createdAt
- updatedAt
- mood
- title
- content
- isLocked
```

### Suggested local repo responsibilities

- create entry
- update entry
- delete entry
- list entries
- search entries
- export entries

---

## Phase C: Real Cycle Engine

This is the core data system of the app.

### Scope

- save cycle history
- save period dates
- compute average cycle length
- compute period length
- estimate next cycle
- detect irregularity
- control fertile window display

### Suggested models

```text
CycleRecord
- id
- periodStart
- periodEnd
- cycleLength
- periodLength

CyclePrediction
- nextPeriodStart
- nextPeriodWindowStart
- nextPeriodWindowEnd
- ovulationDate
- fertileWindowStart
- fertileWindowEnd
- confidenceLevel
```

### Important product rule

Predictions must never be displayed as certainty.

Must include messaging like:

- estimated
- difficult to predict
- not a reliable contraceptive method

---

## Phase D: Symptoms Persistence and Intelligence

### Scope

- persist symptoms by date
- persist note/water/weight
- support intensity where relevant
- overlay symptoms onto calendar
- enable pattern review later

### Suggested model

```text
SymptomLog
- id
- date
- category
- itemKey
- intensity
- note
- weight
- waterMl
- temperature
```

### Why this phase matters

It is a major source of user retention and AI context.

---

## Phase E: Privacy and Discreet Mode

### Scope

- discreet notifications
- generic notification text
- app icon disguise strategy placeholder
- journal lock
- optional app lock
- hide sensitive labels in notifications

### Suggested settings model

```text
PrivacySettings
- discreetModeEnabled
- appLockEnabled
- biometricEnabled
- journalLockEnabled
- notificationPreviewMode
```

### Priority

- critical

This is one of the strongest brand promises in the cahier.

---

## Phase F: AI Rules Engine

### Scope

- safe-topic routing
- canned educational responses
- keywords and quick prompts
- disclaimers for sensitive or medical prompts
- article linking

### Important product rule

AI must not diagnose.

Every medical-risk area must route through a rule like:

- “I’m not a doctor”
- “If you’re worried, talk to a health professional”

### Suggested architecture

Instead of a full LLM dependency first, start with:

- intent detection by keyword/rules
- templated responses
- content links
- escalation rules

Later:

- controlled LLM integration behind safety middleware

---

## Phase G: Partner Data Model

### Scope

- invitation token generation
- pending request record
- accepted connection
- sharing permissions
- revoke or suspend
- read-only partner access

### Suggested models

```text
PartnerConnection
- id
- partnerEmail
- status
- invitedAt
- acceptedAt
- suspended

PartnerSharingSettings
- shareCyclePredictions
- shareSymptoms
- sharePeriodDates
- shareMoodEntries
- shareJournal
```

### Product rule

Partner must never be able to edit the user’s data.

---

## 7. Recommended New Feature Modules

The current codebase should add these folders next:

### `journal/`

Reason:

Completely missing but required.

### `privacy/`

Reason:

Needed to avoid scattering discreet-mode and biometric logic across unrelated modules.

### `cycle_engine/` or integrate into `calendar/`

Reason:

Prediction logic should not live only inside widgets.

### `content/`

Reason:

Educational articles and self-care content need structured management.

### `partner_mode/` later

Reason:

Partner user experience should eventually be separated from the main user experience.

---

## 8. Data Storage Strategy

The cahier explicitly asks for local-first behavior and journal confidentiality.

Recommended implementation:

### Use local encrypted database for

- journal entries
- cycle records
- symptom logs
- partner-sharing settings
- profile settings

### Use shared preferences only for

- theme mode
- language preference
- onboarding completion flag
- app lock toggle
- quick UI preferences

### Do not store journal in plain cloud by default

This is a strong product rule.

---

## 9. Legal and UX Safety Requirements

Must be reflected in code and copy:

- fertile window disclaimer
- AI medical disclaimer
- age-gated pleasure content
- parental or restricted path for minors
- explicit consent before sharing with partner
- clear export/delete controls

These are not just content concerns.
They are feature requirements.

---

## 10. Concrete Next Sprint Recommendation

If we start “for real” now, the best next sprint is:

### Sprint 1

1. create storage foundation
2. create `journal` feature
3. persist profile/settings
4. persist cycle and symptom logs

### Sprint 2

1. implement prediction engine
2. implement discreet mode
3. implement biometric lock
4. implement partner-sharing data model

### Sprint 3

1. replace AI static screens with safe rules engine
2. structure self-care content
3. add educational article repository
4. add age gating and legal flows

---

## 11. Immediate Coding Priority

If the goal is to move from UI showcase to real product foundation, the most important next implementation is:

### 1. Journal module

because it is missing and central to the product promise

### 2. Local cycle/symptoms persistence

because the app’s core value depends on saved history

### 3. Privacy/discreet mode

because this is a non-negotiable identity promise

---

## 12. Final Conclusion

The current codebase is already a strong UI foundation.

But the “serious” work, based on the cahier des charges, is now clearly this:

- turn the app from static UI into trusted local-first product logic
- protect user privacy at architecture level, not only at screen level
- implement journal, cycle history, symptoms persistence, and privacy features before advanced polish
- keep the AI educational and safe, never diagnostic

This document should now be treated as the implementation reference for the next development phase.
