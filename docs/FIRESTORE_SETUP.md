# Firestore Setup

## Goal

The app stores each user's data in a fully isolated Firestore space:

`users/{uid}/...`

This applies to:
- profile
- app settings
- period logs
- journal entries

Current module mapping in code:
- profile fields: `users/{uid}`
- app settings: `users/{uid}/settings/app`
- security flags: `users/{uid}/settings/security`
- period logs: `users/{uid}/period_logs/{logId}`
- symptoms: `users/{uid}/symptoms/{yyyy-mm-dd}`
- journal: `users/{uid}/journal/{entryId}`
- partner sharing: `users/{uid}/partner/settings`

## Firestore Rules

The project already includes [`firestore.rules`](/g:/flutter/flutter/NewApp/peria/firestore.rules).

Expected logic:

```txt
Only the authenticated user can read/write:
users/{uid}
users/{uid}/**
when request.auth.uid == uid
```

Deploy rules with:

```bash
firebase deploy --only firestore:rules
```

## Firebase Authentication

The data model assumes every session has a Firebase user, even anonymous.

In Firebase Console:
1. Open Authentication
2. Go to Sign-in method
3. Enable Anonymous
4. Enable Email/Password if you want account linking later

Why this matters:
- anonymous auth gives a real `uid`
- all Firestore reads/writes depend on that `uid`
- account linking can later preserve the same user data

## Firestore Database

In Firebase Console:
1. Create a Cloud Firestore database
2. Use Native mode
3. Choose the correct region for the project

Recommended:
- pick the same region as the rest of your Firebase backend
- do not recreate the database later, region changes are painful

## Indexes

Current code queries requiring indexes:
- `users/{uid}/journal` ordered by `updatedAt desc`
- `users/{uid}/period_logs` ordered by `startDate desc`

Single-field indexes are normally automatic in Firestore.
If Firebase asks for a composite index later, create it from the generated console link.

## Offline Persistence

Offline persistence is already enabled in [`firebase_service.dart`](/g:/flutter/flutter/NewApp/peria/lib/core/services/firebase_service.dart).

Current behavior:
- Firestore cache is enabled
- writes are queued offline
- data syncs when connectivity returns

## User Document Initialization

The app now ensures `users/{uid}` exists before module reads/writes.

Base document fields currently initialized:
- `uid`
- `isAnonymous`
- `email`
- `createdAt`
- `lastLogin`

## Recommended Firestore Structure

```txt
users/{uid}
  displayName
  dateOfBirth
  averageCycleLengthDays
  periodLengthDays
  lastPeriodStart
  isCycleRegular
  uid
  email
  isAnonymous
  createdAt
  lastLogin

users/{uid}/settings/app
  allowNotifications
  notifyPeriodStarting
  notifyFertileWindow
  notifyOvulationDay
  remindLogSymptoms
  notifyPartnerUpdates
  twoFactorEnabled
  faceIdEnabled
  discreetModeEnabled
  periodLengthDays
  cycleLengthDays

users/{uid}/settings/security
  appLockEnabled
  journalLockEnabled

users/{uid}/partner/settings
  status
  partnerEmail
  shareCyclePredictions
  shareLoggedSymptoms
  sharePeriodDates
  shareMoodEntries

users/{uid}/period_logs/{logId}
  id
  startDate
  endDate
  isEstimated

users/{uid}/symptoms/{yyyy-mm-dd}
  id
  date
  selections
  updatedAt

users/{uid}/journal/{entryId}
  id
  createdAt
  updatedAt
  title
  content
  mood
```

## Important Limitation

Anonymous accounts do not protect against uninstall/data loss by themselves.

If the app is deleted before the anonymous account is linked:
- the local app session is lost
- the user may not recover the same `uid`
- Firestore data may become unreachable to that person

To avoid that:
- link the anonymous account to email/password or another provider
- do it before the user changes device or reinstalls the app

## Local-Only Secrets

Not every security value should be synced to Firestore.

Current rule:
- the PIN stays local on the device in secure storage
- security toggles can be synced in Firestore

Why:
- a raw PIN should never be copied around as normal cloud data
- local secure storage is the correct place for device-bound secrets

## Suggested Next Steps

1. Deploy the Firestore rules
2. Verify Anonymous Auth is enabled
3. Test one anonymous sign-in
4. Confirm documents appear under `users/{uid}`
5. Add account linking flow in the app
6. Move symptoms and partner-sharing data into `users/{uid}/...` with dedicated subcollections
