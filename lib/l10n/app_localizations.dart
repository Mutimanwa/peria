import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Peria'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome To Peria'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Peria helps you understand your body\\nwith calm, personalized guidance.'**
  String get welcomeSubtitle;

  /// No description provided for @turnOnNotifications.
  ///
  /// In en, this message translates to:
  /// **'Turn on notification'**
  String get turnOnNotifications;

  /// No description provided for @anotherTime.
  ///
  /// In en, this message translates to:
  /// **'Another time'**
  String get anotherTime;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login or create an account to get started.'**
  String get registerSubtitle;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orDivider;

  /// No description provided for @enterYourEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmailTitle;

  /// No description provided for @enterYourEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll check if you already have an account'**
  String get enterYourEmailSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @yourEmailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get yourEmailAddressHint;

  /// No description provided for @continueCta.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueCta;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password to create your Peria account.'**
  String get createAccountSubtitle;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @enterYourPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPasswordHint;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotYourPassword;

  /// No description provided for @setGoalsTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get setGoalsTitle;

  /// No description provided for @setGoalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you\'d like to focus on so we can\\ntailor your experience.'**
  String get setGoalsSubtitle;

  /// No description provided for @askNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get askNameTitle;

  /// No description provided for @askNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make this experience truly yours.'**
  String get askNameSubtitle;

  /// No description provided for @enterYourNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourNameHint;

  /// No description provided for @dateOfBirthTitle.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthTitle;

  /// No description provided for @dateOfBirthSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize your experience.'**
  String get dateOfBirthSubtitle;

  /// No description provided for @whenWasYourLastPeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'When was your last period?'**
  String get whenWasYourLastPeriodTitle;

  /// No description provided for @whenWasYourLastPeriodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select the days your last period started.'**
  String get whenWasYourLastPeriodSubtitle;

  /// No description provided for @notSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get notSure;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @madeByIm.
  ///
  /// In en, this message translates to:
  /// **'Made by IM'**
  String get madeByIm;

  /// No description provided for @nextPeriodUnknown.
  ///
  /// In en, this message translates to:
  /// **'Next period: unknown'**
  String get nextPeriodUnknown;

  /// No description provided for @periodIsDue.
  ///
  /// In en, this message translates to:
  /// **'Period is due'**
  String get periodIsDue;

  /// No description provided for @nextPeriodInDays.
  ///
  /// In en, this message translates to:
  /// **'Next period in {days} days'**
  String nextPeriodInDays(int days);

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {email}'**
  String otpSubtitle(String email);

  /// No description provided for @didntGetCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get didntGetCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend now'**
  String get resendNow;

  /// No description provided for @otpContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get otpContinue;

  /// No description provided for @journalTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journalTitle;

  /// No description provided for @journalCloudSync.
  ///
  /// In en, this message translates to:
  /// **'Journal cloud sync'**
  String get journalCloudSync;

  /// No description provided for @journalSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'By default, your journal stays encrypted on this device. If you opt in, existing and future entries are stored in your Peria account in Firebase Firestore. The cloud copy is not end-to-end encrypted by Peria.'**
  String get journalSyncDescription;

  /// No description provided for @journalSyncEnabledDescription.
  ///
  /// In en, this message translates to:
  /// **'New and existing journal entries from this device sync to your Peria cloud account.'**
  String get journalSyncEnabledDescription;

  /// No description provided for @journalSyncDisabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is off on this device. Your journal stays here.'**
  String get journalSyncDisabledDescription;

  /// No description provided for @journalSyncConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Before enabling journal sync'**
  String get journalSyncConsentTitle;

  /// No description provided for @journalSyncConsentBody.
  ///
  /// In en, this message translates to:
  /// **'If you agree, Peria sends your existing and future journal entries—including titles, text, moods, dates, tags, attachment references and other saved details—to your account in Firebase Firestore. This is cloud storage and is not end-to-end encrypted by Peria. Firestore may also keep an offline cache on this device, separate from Hive’s encrypted copy. You can turn sync off at any time; disabling it does not delete copies already uploaded or writes already queued.'**
  String get journalSyncConsentBody;

  /// No description provided for @enableAndSync.
  ///
  /// In en, this message translates to:
  /// **'I agree and enable sync'**
  String get enableAndSync;

  /// No description provided for @journalSyncDisableTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off journal sync?'**
  String get journalSyncDisableTitle;

  /// No description provided for @journalSyncDisableBody.
  ///
  /// In en, this message translates to:
  /// **'Turning this off on this device stops its future automatic uploads. Copies already stored in Firestore, including writes already queued, may remain until you delete them below. Your local journal stays on this device.'**
  String get journalSyncDisableBody;

  /// No description provided for @turnOffSync.
  ///
  /// In en, this message translates to:
  /// **'Turn off sync'**
  String get turnOffSync;

  /// No description provided for @journalSyncLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is off on this device. Your local journal is available here; an older cloud copy may remain until deleted.'**
  String get journalSyncLocalOnly;

  /// No description provided for @journalSyncNotYet.
  ///
  /// In en, this message translates to:
  /// **'No successful cloud sync yet.'**
  String get journalSyncNotYet;

  /// No description provided for @journalSyncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last successful sync: {time}'**
  String journalSyncLastSynced(String time);

  /// No description provided for @journalSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'The last cloud sync failed. Try again when you are online.'**
  String get journalSyncFailed;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @journalSyncCompleted.
  ///
  /// In en, this message translates to:
  /// **'Your journal was synchronized.'**
  String get journalSyncCompleted;

  /// No description provided for @journalSyncError.
  ///
  /// In en, this message translates to:
  /// **'Could not synchronize the journal. Your local entries are still available.'**
  String get journalSyncError;

  /// No description provided for @journalSyncSettingsError.
  ///
  /// In en, this message translates to:
  /// **'Could not update the journal sync setting. Please try again.'**
  String get journalSyncSettingsError;

  /// No description provided for @deleteCloudCopy.
  ///
  /// In en, this message translates to:
  /// **'Delete cloud copy'**
  String get deleteCloudCopy;

  /// No description provided for @journalCloudDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete the cloud copy?'**
  String get journalCloudDeleteTitle;

  /// No description provided for @journalCloudDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This turns off sync on this device and deletes journal entries stored in Firestore for this account. An internet connection is required. Another device with sync enabled may upload entries again. Your local entries on this device will not be deleted.'**
  String get journalCloudDeleteBody;

  /// No description provided for @journalCloudDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'The cloud copy was deleted. Your local journal remains on this device.'**
  String get journalCloudDeleteSuccess;

  /// No description provided for @journalCloudDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the cloud copy. Sync is off; check your connection and try again.'**
  String get journalCloudDeleteError;

  /// No description provided for @journalCloudLegacyCopyNotice.
  ///
  /// In en, this message translates to:
  /// **'If you used an earlier version of Peria, journal entries may already exist in the cloud. Turning sync off does not remove them; use “Delete cloud copy” to remove them.'**
  String get journalCloudLegacyCopyNotice;

  /// No description provided for @journalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your private space to note feelings, thoughts and body patterns.'**
  String get journalSubtitle;

  /// No description provided for @searchJournalHint.
  ///
  /// In en, this message translates to:
  /// **'Search journal...'**
  String get searchJournalHint;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @newEntry.
  ///
  /// In en, this message translates to:
  /// **'New entry'**
  String get newEntry;

  /// No description provided for @noMatchingNotes.
  ///
  /// In en, this message translates to:
  /// **'No matching notes'**
  String get noMatchingNotes;

  /// No description provided for @journalEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your journal is empty'**
  String get journalEmpty;

  /// No description provided for @tryAnotherKeyword.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword.'**
  String get tryAnotherKeyword;

  /// No description provided for @startFirstNote.
  ///
  /// In en, this message translates to:
  /// **'Start your first private note. It stays on this device.'**
  String get startFirstNote;

  /// No description provided for @untitledNote.
  ///
  /// In en, this message translates to:
  /// **'Untitled note'**
  String get untitledNote;

  /// No description provided for @noDetailsYet.
  ///
  /// In en, this message translates to:
  /// **'No details yet.'**
  String get noDetailsYet;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @saveEntry.
  ///
  /// In en, this message translates to:
  /// **'Save entry'**
  String get saveEntry;

  /// No description provided for @writeFreelyHint.
  ///
  /// In en, this message translates to:
  /// **'Write freely. This note stays on your device.'**
  String get writeFreelyHint;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @partner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get partner;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get accountSecurity;

  /// No description provided for @appSetting.
  ///
  /// In en, this message translates to:
  /// **'App Setting'**
  String get appSetting;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @navCycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get navCycle;

  /// No description provided for @navEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get navEducation;

  /// No description provided for @navJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get navJournal;

  /// No description provided for @notificationGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Peria'**
  String get notificationGenericTitle;

  /// No description provided for @notificationGenericBody.
  ///
  /// In en, this message translates to:
  /// **'A gentle reminder is waiting.'**
  String get notificationGenericBody;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Peria'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Private reminders from Peria.'**
  String get notificationChannelDescription;

  /// No description provided for @notificationPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications use neutral wording to keep cycle details private on your lock screen.'**
  String get notificationPrivacyDescription;

  /// No description provided for @notificationScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'When enabled, cycle reminders are planned for 9:00 and the daily symptoms and journal check-in for 20:00.'**
  String get notificationScheduleDescription;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications could not be enabled. Check notification permission in your device settings, then try again.'**
  String get notificationPermissionDenied;

  /// No description provided for @supportLegal.
  ///
  /// In en, this message translates to:
  /// **'Support & Legal'**
  String get supportLegal;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @cycleProfile.
  ///
  /// In en, this message translates to:
  /// **'Cycle profile'**
  String get cycleProfile;

  /// No description provided for @cycleProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'These settings are the source of truth for calculating your next period and fertility windows.'**
  String get cycleProfileDescription;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @averageCycleLength.
  ///
  /// In en, this message translates to:
  /// **'Average cycle length'**
  String get averageCycleLength;

  /// No description provided for @periodLength.
  ///
  /// In en, this message translates to:
  /// **'Period length'**
  String get periodLength;

  /// No description provided for @lastPeriodStartDate.
  ///
  /// In en, this message translates to:
  /// **'Last period start date'**
  String get lastPeriodStartDate;

  /// No description provided for @regularCycleQuestion.
  ///
  /// In en, this message translates to:
  /// **'Regular cycle?'**
  String get regularCycleQuestion;

  /// No description provided for @regular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regular;

  /// No description provided for @irregular.
  ///
  /// In en, this message translates to:
  /// **'Irregular'**
  String get irregular;

  /// No description provided for @changesSavedAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Changes are saved automatically as soon as you update a value.'**
  String get changesSavedAutomatically;

  /// No description provided for @unableToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// No description provided for @daysCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// No description provided for @logSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Log Symptoms'**
  String get logSymptoms;

  /// No description provided for @symptomJournalReminder.
  ///
  /// In en, this message translates to:
  /// **'Symptoms & journal check-in'**
  String get symptomJournalReminder;

  /// No description provided for @quickDailySymptomCapture.
  ///
  /// In en, this message translates to:
  /// **'Quick daily symptom capture. Tap everything that matches how you feel today.'**
  String get quickDailySymptomCapture;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @writeHowYouFeelToday.
  ///
  /// In en, this message translates to:
  /// **'Write how you feel today...'**
  String get writeHowYouFeelToday;

  /// No description provided for @intensity.
  ///
  /// In en, this message translates to:
  /// **'Intensity'**
  String get intensity;

  /// No description provided for @sexualActivity.
  ///
  /// In en, this message translates to:
  /// **'Sexual activity'**
  String get sexualActivity;

  /// No description provided for @protectedSex.
  ///
  /// In en, this message translates to:
  /// **'Protected Sex'**
  String get protectedSex;

  /// No description provided for @orgasm.
  ///
  /// In en, this message translates to:
  /// **'Orgasm'**
  String get orgasm;

  /// No description provided for @highActivity.
  ///
  /// In en, this message translates to:
  /// **'High activity'**
  String get highActivity;

  /// No description provided for @unprotectedSex.
  ///
  /// In en, this message translates to:
  /// **'Unprotected sex'**
  String get unprotectedSex;

  /// No description provided for @mental.
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get mental;

  /// No description provided for @breathingExercises.
  ///
  /// In en, this message translates to:
  /// **'Breathing Exercises'**
  String get breathingExercises;

  /// No description provided for @stress.
  ///
  /// In en, this message translates to:
  /// **'Stress'**
  String get stress;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// No description provided for @discharge.
  ///
  /// In en, this message translates to:
  /// **'Discharge'**
  String get discharge;

  /// No description provided for @unusual.
  ///
  /// In en, this message translates to:
  /// **'Unusual'**
  String get unusual;

  /// No description provided for @sticky.
  ///
  /// In en, this message translates to:
  /// **'Sticky'**
  String get sticky;

  /// No description provided for @bleeding.
  ///
  /// In en, this message translates to:
  /// **'Bleeding'**
  String get bleeding;

  /// No description provided for @heavyBleeding.
  ///
  /// In en, this message translates to:
  /// **'Heavy Bleeding'**
  String get heavyBleeding;

  /// No description provided for @lowBleeding.
  ///
  /// In en, this message translates to:
  /// **'Low Bleeding'**
  String get lowBleeding;

  /// No description provided for @physicalActivity.
  ///
  /// In en, this message translates to:
  /// **'Physical activity'**
  String get physicalActivity;

  /// No description provided for @noExercise.
  ///
  /// In en, this message translates to:
  /// **'No Exercise'**
  String get noExercise;

  /// No description provided for @teamSports.
  ///
  /// In en, this message translates to:
  /// **'Team sports'**
  String get teamSports;

  /// No description provided for @cycling.
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cycling;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @dancing.
  ///
  /// In en, this message translates to:
  /// **'Dancing'**
  String get dancing;

  /// No description provided for @aerobics.
  ///
  /// In en, this message translates to:
  /// **'Aerobics'**
  String get aerobics;

  /// No description provided for @swimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get swimming;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @anxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get anxious;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @energetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get energetic;

  /// No description provided for @confused.
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get confused;

  /// No description provided for @depressed.
  ///
  /// In en, this message translates to:
  /// **'Depressed'**
  String get depressed;

  /// No description provided for @sharingSettings.
  ///
  /// In en, this message translates to:
  /// **'Sharing Settings'**
  String get sharingSettings;

  /// No description provided for @chooseWhatToShare.
  ///
  /// In en, this message translates to:
  /// **'Choose What to Share'**
  String get chooseWhatToShare;

  /// No description provided for @manageSharedCycleData.
  ///
  /// In en, this message translates to:
  /// **'You can now manage your shared cycle data and insights below.'**
  String get manageSharedCycleData;

  /// No description provided for @cyclePredictions.
  ///
  /// In en, this message translates to:
  /// **'Cycle Predictions'**
  String get cyclePredictions;

  /// No description provided for @loggedSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Logged Symptoms'**
  String get loggedSymptoms;

  /// No description provided for @periodDates.
  ///
  /// In en, this message translates to:
  /// **'Period Dates'**
  String get periodDates;

  /// No description provided for @moodEntries.
  ///
  /// In en, this message translates to:
  /// **'Mood Entries'**
  String get moodEntries;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @unableToLoadSharingSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load sharing settings'**
  String get unableToLoadSharingSettings;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow Notifications'**
  String get allowNotifications;

  /// No description provided for @periodStarting.
  ///
  /// In en, this message translates to:
  /// **'Period Starting'**
  String get periodStarting;

  /// No description provided for @fertileWindow.
  ///
  /// In en, this message translates to:
  /// **'Fertile Window'**
  String get fertileWindow;

  /// No description provided for @ovulationDay.
  ///
  /// In en, this message translates to:
  /// **'Ovulation Day'**
  String get ovulationDay;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @partnerUpdates.
  ///
  /// In en, this message translates to:
  /// **'Partner Updates'**
  String get partnerUpdates;

  /// No description provided for @unableToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications'**
  String get unableToLoadNotifications;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your language preference. Please try again.'**
  String get languageSaveError;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @cycleSettings.
  ///
  /// In en, this message translates to:
  /// **'Cycle Settings'**
  String get cycleSettings;

  /// No description provided for @cycleLength.
  ///
  /// In en, this message translates to:
  /// **'Cycle Length'**
  String get cycleLength;

  /// No description provided for @integrationsSync.
  ///
  /// In en, this message translates to:
  /// **'Integrations & Sync'**
  String get integrationsSync;

  /// No description provided for @connectedApps.
  ///
  /// In en, this message translates to:
  /// **'Connected Apps'**
  String get connectedApps;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @unableToLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load settings'**
  String get unableToLoadSettings;

  /// No description provided for @connectedPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re connected with {partnerName}!'**
  String connectedPartnerTitle(String partnerName);

  /// No description provided for @yourPartnerFallback.
  ///
  /// In en, this message translates to:
  /// **'your partner'**
  String get yourPartnerFallback;

  /// No description provided for @partnerConnectedDescription.
  ///
  /// In en, this message translates to:
  /// **'You can now manage your shared cycle data and insights below.'**
  String get partnerConnectedDescription;

  /// No description provided for @statusConnected.
  ///
  /// In en, this message translates to:
  /// **'Status: Connected'**
  String get statusConnected;

  /// No description provided for @manageSharingSettings.
  ///
  /// In en, this message translates to:
  /// **'Manage Sharing Settings'**
  String get manageSharingSettings;

  /// No description provided for @disconnectPartner.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Partner'**
  String get disconnectPartner;

  /// No description provided for @unableToLoadPartner.
  ///
  /// In en, this message translates to:
  /// **'Unable to load partner'**
  String get unableToLoadPartner;

  /// No description provided for @disconnectFromPartnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from {partnerName}?'**
  String disconnectFromPartnerTitle(String partnerName);

  /// No description provided for @disconnectWarning.
  ///
  /// In en, this message translates to:
  /// **'This will immediately stop all data sharing.'**
  String get disconnectWarning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @invitePartner.
  ///
  /// In en, this message translates to:
  /// **'Invite Partner'**
  String get invitePartner;

  /// No description provided for @inviteYourPartner.
  ///
  /// In en, this message translates to:
  /// **'Invite your partner'**
  String get inviteYourPartner;

  /// No description provided for @partnerInviteDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send a secure, private invitation link for your partner.'**
  String get partnerInviteDescription;

  /// No description provided for @partnerEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Partner\'s Email Address'**
  String get partnerEmailAddress;

  /// No description provided for @sendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send Invitation'**
  String get sendInvitation;

  /// No description provided for @shareLinkManually.
  ///
  /// In en, this message translates to:
  /// **'Share Link Manually'**
  String get shareLinkManually;

  /// No description provided for @invitationSent.
  ///
  /// In en, this message translates to:
  /// **'Invitation Sent!'**
  String get invitationSent;

  /// No description provided for @partnerInvitationSentDescription.
  ///
  /// In en, this message translates to:
  /// **'Your partner has been sent an invitation to accept.'**
  String get partnerInvitationSentDescription;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @partnerInvitationPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve Invited Your Partner!'**
  String get partnerInvitationPendingTitle;

  /// No description provided for @partnerInvitationPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'We\'ll let you know when they accept.'**
  String get partnerInvitationPendingDescription;

  /// No description provided for @statusPendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Status: Pending Approval'**
  String get statusPendingApproval;

  /// No description provided for @resendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Resend Invitation'**
  String get resendInvitation;

  /// No description provided for @cancelInvitation.
  ///
  /// In en, this message translates to:
  /// **'Cancel Invitation'**
  String get cancelInvitation;

  /// No description provided for @unableToLoadInvitation.
  ///
  /// In en, this message translates to:
  /// **'Unable to load invitation'**
  String get unableToLoadInvitation;

  /// No description provided for @yourPartnerIsConnected.
  ///
  /// In en, this message translates to:
  /// **'Your partner is connected'**
  String get yourPartnerIsConnected;

  /// No description provided for @invitationPending.
  ///
  /// In en, this message translates to:
  /// **'Invitation pending'**
  String get invitationPending;

  /// No description provided for @connectWithYourPartner.
  ///
  /// In en, this message translates to:
  /// **'Connect with your partner'**
  String get connectWithYourPartner;

  /// No description provided for @partnerConnectedBody.
  ///
  /// In en, this message translates to:
  /// **'Manage what your partner can see from your cycle and wellbeing data.'**
  String get partnerConnectedBody;

  /// No description provided for @partnerPendingBody.
  ///
  /// In en, this message translates to:
  /// **'Your invitation has been sent. You can manage or resend it from the next screen.'**
  String get partnerPendingBody;

  /// No description provided for @partnerInviteBody.
  ///
  /// In en, this message translates to:
  /// **'Securely share key cycle dates, predictions, and ovulation windows.'**
  String get partnerInviteBody;

  /// No description provided for @manageSharing.
  ///
  /// In en, this message translates to:
  /// **'Manage Sharing'**
  String get manageSharing;

  /// No description provided for @viewInvitation.
  ///
  /// In en, this message translates to:
  /// **'View Invitation'**
  String get viewInvitation;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @unableToLoadPartnerSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load partner settings'**
  String get unableToLoadPartnerSettings;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @setPinLock.
  ///
  /// In en, this message translates to:
  /// **'Set PIN lock'**
  String get setPinLock;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN:'**
  String get enterPin;

  /// No description provided for @newPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN:'**
  String get newPin;

  /// No description provided for @confirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN:'**
  String get confirmPin;

  /// No description provided for @pinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinsDoNotMatch;

  /// No description provided for @enter4Digits.
  ///
  /// In en, this message translates to:
  /// **'Enter 4 digits'**
  String get enter4Digits;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// No description provided for @journalLock.
  ///
  /// In en, this message translates to:
  /// **'Journal Lock'**
  String get journalLock;

  /// No description provided for @unableToLoadJournal.
  ///
  /// In en, this message translates to:
  /// **'Unable to load journal'**
  String get unableToLoadJournal;

  /// No description provided for @privateByDefault.
  ///
  /// In en, this message translates to:
  /// **'Private by default on this device.'**
  String get privateByDefault;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// No description provided for @changePinButton.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinButton;

  /// No description provided for @disablePinLock.
  ///
  /// In en, this message translates to:
  /// **'Disable PIN lock'**
  String get disablePinLock;

  /// No description provided for @unableToLoadSecuritySettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load security settings'**
  String get unableToLoadSecuritySettings;

  /// No description provided for @unableToLoadAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load account settings'**
  String get unableToLoadAccountSettings;

  /// No description provided for @appAccess.
  ///
  /// In en, this message translates to:
  /// **'App Access'**
  String get appAccess;

  /// No description provided for @confidentiality.
  ///
  /// In en, this message translates to:
  /// **'Confidentiality'**
  String get confidentiality;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @globalSecurity.
  ///
  /// In en, this message translates to:
  /// **'Global Security (PIN/FaceID)'**
  String get globalSecurity;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric Authentication'**
  String get biometricAuth;

  /// No description provided for @multitaskProtection.
  ///
  /// In en, this message translates to:
  /// **'Hide sensitive content while multitasking'**
  String get multitaskProtection;

  /// No description provided for @clearLocalData.
  ///
  /// In en, this message translates to:
  /// **'Clear local data'**
  String get clearLocalData;

  /// No description provided for @confirmClearData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get confirmClearData;

  /// No description provided for @clearDataWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone and will delete your entire history.'**
  String get clearDataWarning;

  /// No description provided for @securityRequired.
  ///
  /// In en, this message translates to:
  /// **'Security required'**
  String get securityRequired;

  /// No description provided for @globalSecurityRequiredForJournal.
  ///
  /// In en, this message translates to:
  /// **'Secure access (PIN/Face ID) must be enabled before the journal can be protected.'**
  String get globalSecurityRequiredForJournal;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @myDairy.
  ///
  /// In en, this message translates to:
  /// **'This is my diary...'**
  String get myDairy;

  /// No description provided for @aboutYourDay.
  ///
  /// In en, this message translates to:
  /// **'Tell me about your day...'**
  String get aboutYourDay;

  /// No description provided for @howDoYouFell.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howDoYouFell;

  /// No description provided for @educationGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello Peria'**
  String get educationGreeting;

  /// No description provided for @educationSpace.
  ///
  /// In en, this message translates to:
  /// **'Your education space'**
  String get educationSpace;

  /// No description provided for @educationWhatToLearn.
  ///
  /// In en, this message translates to:
  /// **'What would you like to learn today?'**
  String get educationWhatToLearn;

  /// No description provided for @educationRecentArticles.
  ///
  /// In en, this message translates to:
  /// **'Recent articles'**
  String get educationRecentArticles;

  /// No description provided for @educationSearchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get educationSearchResults;

  /// No description provided for @searchAction.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchAction;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @educationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search an article...'**
  String get educationSearchHint;

  /// No description provided for @educationNoArticleFound.
  ///
  /// In en, this message translates to:
  /// **'No article found'**
  String get educationNoArticleFound;

  /// No description provided for @educationNoArticles.
  ///
  /// In en, this message translates to:
  /// **'No articles'**
  String get educationNoArticles;

  /// No description provided for @educationTryAnotherSearch.
  ///
  /// In en, this message translates to:
  /// **'Try another search'**
  String get educationTryAnotherSearch;

  /// No description provided for @educationChooseCategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get educationChooseCategory;

  /// No description provided for @educationHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn gently'**
  String get educationHeroTitle;

  /// No description provided for @educationHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore simple answers to your most common questions.'**
  String get educationHeroSubtitle;

  /// No description provided for @educationHeroFooter.
  ///
  /// In en, this message translates to:
  /// **'Access clear answers, step by step.'**
  String get educationHeroFooter;

  /// No description provided for @educationSuggestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggestions for you'**
  String get educationSuggestionsTitle;

  /// No description provided for @educationSuggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Based on your cycle and recent entries.'**
  String get educationSuggestionsSubtitle;

  /// No description provided for @educationArticleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Article not found'**
  String get educationArticleNotFound;

  /// No description provided for @educationArticleSaved.
  ///
  /// In en, this message translates to:
  /// **'Article added to favorites'**
  String get educationArticleSaved;

  /// No description provided for @educationExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get educationExplanation;

  /// No description provided for @educationObserve.
  ///
  /// In en, this message translates to:
  /// **'What to observe'**
  String get educationObserve;

  /// No description provided for @educationAdvice.
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get educationAdvice;

  /// No description provided for @educationWhenToConsult.
  ///
  /// In en, this message translates to:
  /// **'When to consult'**
  String get educationWhenToConsult;

  /// No description provided for @educationRelatedTags.
  ///
  /// In en, this message translates to:
  /// **'Related tags'**
  String get educationRelatedTags;

  /// No description provided for @educationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated: {value}'**
  String educationUpdated(String value);

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get difficultyAdvanced;

  /// No description provided for @educationAxisCycleBasics.
  ///
  /// In en, this message translates to:
  /// **'Understand the cycle'**
  String get educationAxisCycleBasics;

  /// No description provided for @educationAxisOvulationFertility.
  ///
  /// In en, this message translates to:
  /// **'Ovulation and fertility'**
  String get educationAxisOvulationFertility;

  /// No description provided for @educationAxisMenstruationSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Periods and symptoms'**
  String get educationAxisMenstruationSymptoms;

  /// No description provided for @educationAxisNormalVsAbnormal.
  ///
  /// In en, this message translates to:
  /// **'Normal vs abnormal'**
  String get educationAxisNormalVsAbnormal;

  /// No description provided for @educationAxisSolutionsWellbeing.
  ///
  /// In en, this message translates to:
  /// **'Relief and wellbeing'**
  String get educationAxisSolutionsWellbeing;

  /// No description provided for @educationHealthNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Health information, not a diagnosis'**
  String get educationHealthNoticeTitle;

  /// No description provided for @educationHealthNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'These articles are for general education and do not replace advice from a qualified health professional. Seek urgent care for sudden severe symptoms, fainting, or heavy bleeding.'**
  String get educationHealthNoticeBody;

  /// No description provided for @educationMovementNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Movement is optional'**
  String get educationMovementNoticeTitle;

  /// No description provided for @educationMovementNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'This routine is for general wellbeing, not treatment. Stop if pain increases or you feel dizzy or unwell. Seek health advice for severe or unusual symptoms.'**
  String get educationMovementNoticeBody;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayLabel;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} week(s) ago'**
  String weeksAgo(int count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} month(s) ago'**
  String monthsAgo(int count);

  /// No description provided for @articleHealthyDiet.
  ///
  /// In en, this message translates to:
  /// **'Healthy diet'**
  String get articleHealthyDiet;

  /// No description provided for @articleSkinCare.
  ///
  /// In en, this message translates to:
  /// **'Skin care'**
  String get articleSkinCare;

  /// No description provided for @articleYogaTips.
  ///
  /// In en, this message translates to:
  /// **'Yoga tips'**
  String get articleYogaTips;

  /// No description provided for @logPeriodButton.
  ///
  /// In en, this message translates to:
  /// **'Log Period'**
  String get logPeriodButton;

  /// No description provided for @logPeriodSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Log period'**
  String get logPeriodSheetTitle;

  /// No description provided for @logPeriodSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick daily capture. Use Edit Calendar for precise date corrections.'**
  String get logPeriodSheetSubtitle;

  /// No description provided for @periodStartedToday.
  ///
  /// In en, this message translates to:
  /// **'Period started today'**
  String get periodStartedToday;

  /// No description provided for @periodStartedTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record today as the first day of your period.'**
  String get periodStartedTodaySubtitle;

  /// No description provided for @addTodayPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Add today as a period day'**
  String get addTodayPeriodDay;

  /// No description provided for @addTodayPeriodDaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record today and extend the latest period only when the days are consecutive.'**
  String get addTodayPeriodDaySubtitle;

  /// No description provided for @periodEndedToday.
  ///
  /// In en, this message translates to:
  /// **'Period ended today'**
  String get periodEndedToday;

  /// No description provided for @periodEndedTodaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Close a period logged today or yesterday.'**
  String get periodEndedTodaySubtitle;

  /// No description provided for @openStructuredPeriodEdit.
  ///
  /// In en, this message translates to:
  /// **'Open calendar edit'**
  String get openStructuredPeriodEdit;

  /// No description provided for @periodLogLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading period logs…'**
  String get periodLogLoading;

  /// No description provided for @periodLogSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving period log…'**
  String get periodLogSaving;

  /// No description provided for @periodLogLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load period logs. Try again or use Edit Calendar.'**
  String get periodLogLoadError;

  /// No description provided for @periodLogAlreadyLoggedToday.
  ///
  /// In en, this message translates to:
  /// **'Today is already recorded as a period day.'**
  String get periodLogAlreadyLoggedToday;

  /// No description provided for @periodLogNoRecentToEnd.
  ///
  /// In en, this message translates to:
  /// **'No period is logged today or yesterday to close. Use Edit Calendar to correct the dates.'**
  String get periodLogNoRecentToEnd;

  /// No description provided for @periodLogSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the period log. Check your connection and try again.'**
  String get periodLogSaveError;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Cycle Calendar'**
  String get calendarTitle;

  /// No description provided for @calendarNoCycleData.
  ///
  /// In en, this message translates to:
  /// **'No cycle data'**
  String get calendarNoCycleData;

  /// No description provided for @calendarNoCyclePredictionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No cycle prediction is available for this date.'**
  String get calendarNoCyclePredictionAvailable;

  /// No description provided for @calendarOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get calendarOverdue;

  /// No description provided for @calendarExpectedNotLogged.
  ///
  /// In en, this message translates to:
  /// **'Your period is expected but has not been logged.'**
  String get calendarExpectedNotLogged;

  /// No description provided for @calendarLoggedPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Logged period day'**
  String get calendarLoggedPeriodDay;

  /// No description provided for @calendarLoggedPeriodDescription.
  ///
  /// In en, this message translates to:
  /// **'This date is recorded in your period log.'**
  String get calendarLoggedPeriodDescription;

  /// No description provided for @calendarPredictedPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Predicted period day'**
  String get calendarPredictedPeriodDay;

  /// No description provided for @calendarPredictedPeriodDescription.
  ///
  /// In en, this message translates to:
  /// **'This date is an estimate based on your cycle data.'**
  String get calendarPredictedPeriodDescription;

  /// No description provided for @calendarFertilityWindow.
  ///
  /// In en, this message translates to:
  /// **'Fertility window'**
  String get calendarFertilityWindow;

  /// No description provided for @calendarFertilityWindowDescription.
  ///
  /// In en, this message translates to:
  /// **'This date is inside the predicted fertile window.'**
  String get calendarFertilityWindowDescription;

  /// No description provided for @calendarPmsDay.
  ///
  /// In en, this message translates to:
  /// **'PMS day'**
  String get calendarPmsDay;

  /// No description provided for @calendarPmsDayDescription.
  ///
  /// In en, this message translates to:
  /// **'This date is in the predicted PMS phase.'**
  String get calendarPmsDayDescription;

  /// No description provided for @calendarSelectedDay.
  ///
  /// In en, this message translates to:
  /// **'Selected day.'**
  String get calendarSelectedDay;

  /// No description provided for @calendarRegularDay.
  ///
  /// In en, this message translates to:
  /// **'Regular day'**
  String get calendarRegularDay;

  /// No description provided for @calendarNoTrackedCycleEvent.
  ///
  /// In en, this message translates to:
  /// **'No tracked cycle event is attached to this date.'**
  String get calendarNoTrackedCycleEvent;

  /// No description provided for @calendarMonthlyOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly overview'**
  String get calendarMonthlyOverview;

  /// No description provided for @calendarMonthlyOverviewHelp.
  ///
  /// In en, this message translates to:
  /// **'Review your cycle over time. Use quick log for daily updates and Edit Calendar for corrections.'**
  String get calendarMonthlyOverviewHelp;

  /// No description provided for @calendarQuickCapture.
  ///
  /// In en, this message translates to:
  /// **'Quick capture'**
  String get calendarQuickCapture;

  /// No description provided for @calendarQuickCaptureHelp.
  ///
  /// In en, this message translates to:
  /// **'Fast daily actions for periods and symptoms, without opening the structured editor.'**
  String get calendarQuickCaptureHelp;

  /// No description provided for @calendarDateRangeHelp.
  ///
  /// In en, this message translates to:
  /// **'Need to define or correct a date range? Use Edit Calendar.'**
  String get calendarDateRangeHelp;

  /// No description provided for @calendarEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Calendar'**
  String get calendarEditTitle;

  /// No description provided for @calendarStructuredEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Structured period edit'**
  String get calendarStructuredEditTitle;

  /// No description provided for @calendarStartDateSelected.
  ///
  /// In en, this message translates to:
  /// **'Start date selected'**
  String get calendarStartDateSelected;

  /// No description provided for @calendarPeriodRangeReady.
  ///
  /// In en, this message translates to:
  /// **'Period range ready'**
  String get calendarPeriodRangeReady;

  /// No description provided for @calendarSelectRangeInstruction.
  ///
  /// In en, this message translates to:
  /// **'Use this screen to define or correct an exact period range.'**
  String get calendarSelectRangeInstruction;

  /// No description provided for @calendarChooseLastDay.
  ///
  /// In en, this message translates to:
  /// **'Choose the last day of this period.'**
  String get calendarChooseLastDay;

  /// No description provided for @calendarCorrectionHelp.
  ///
  /// In en, this message translates to:
  /// **'This screen is for precise corrections. For quick daily updates, use Log Period from the calendar overview.'**
  String get calendarCorrectionHelp;

  /// No description provided for @calendarSavedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Saved period'**
  String get calendarSavedPeriod;

  /// No description provided for @calendarPredictedPeriodLegend.
  ///
  /// In en, this message translates to:
  /// **'Predicted period'**
  String get calendarPredictedPeriodLegend;

  /// No description provided for @calendarSaveStartDate.
  ///
  /// In en, this message translates to:
  /// **'Save start date'**
  String get calendarSaveStartDate;

  /// No description provided for @calendarSavePeriodRange.
  ///
  /// In en, this message translates to:
  /// **'Save period range'**
  String get calendarSavePeriodRange;

  /// No description provided for @calendarLegendPmsDay.
  ///
  /// In en, this message translates to:
  /// **'PMS day'**
  String get calendarLegendPmsDay;

  /// No description provided for @calendarLegendLoggedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Logged period'**
  String get calendarLegendLoggedPeriod;

  /// No description provided for @calendarLegendPredictedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Predicted period'**
  String get calendarLegendPredictedPeriod;

  /// No description provided for @calendarLegendFertilityWindow.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get calendarLegendFertilityWindow;

  /// No description provided for @calendarLegendSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get calendarLegendSymptoms;

  /// No description provided for @calendarLegendJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get calendarLegendJournal;

  /// No description provided for @calendarLegendToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get calendarLegendToday;

  /// No description provided for @goalTrackPeriod.
  ///
  /// In en, this message translates to:
  /// **'Track my period'**
  String get goalTrackPeriod;

  /// No description provided for @goalUnderstandBody.
  ///
  /// In en, this message translates to:
  /// **'Understand my body better'**
  String get goalUnderstandBody;

  /// No description provided for @goalTrackOvulation.
  ///
  /// In en, this message translates to:
  /// **'Track ovulation'**
  String get goalTrackOvulation;

  /// No description provided for @goalHealthInsights.
  ///
  /// In en, this message translates to:
  /// **'Get health insights'**
  String get goalHealthInsights;

  /// No description provided for @goalShareDoctor.
  ///
  /// In en, this message translates to:
  /// **'Share data with my doctor'**
  String get goalShareDoctor;

  /// No description provided for @goalAiGuidance.
  ///
  /// In en, this message translates to:
  /// **'AI-powered guidance'**
  String get goalAiGuidance;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @myGoal.
  ///
  /// In en, this message translates to:
  /// **'My goal'**
  String get myGoal;

  /// No description provided for @noGoalsSelected.
  ///
  /// In en, this message translates to:
  /// **'No goals selected'**
  String get noGoalsSelected;

  /// No description provided for @goalsSelected.
  ///
  /// In en, this message translates to:
  /// **'Goals selected'**
  String get goalsSelected;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search anything…'**
  String get helpSearchHint;

  /// No description provided for @helpContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get helpContactUs;

  /// No description provided for @helpFaqLogQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I log my period and symptoms?'**
  String get helpFaqLogQuestion;

  /// No description provided for @helpFaqLogAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open Cycle Calendar and use Log Period or Log Symptoms. You can use Edit Calendar to correct a date range.'**
  String get helpFaqLogAnswer;

  /// No description provided for @helpFaqDataQuestion.
  ///
  /// In en, this message translates to:
  /// **'Is my health data secure?'**
  String get helpFaqDataQuestion;

  /// No description provided for @helpFaqDataAnswer.
  ///
  /// In en, this message translates to:
  /// **'Journal entries stay on this device in encrypted storage by default; optional cloud sync requires separate consent. Profile, cycle, symptom, partner and settings data use Firebase. See the Privacy Policy for details and current deletion limits.'**
  String get helpFaqDataAnswer;

  /// No description provided for @helpFaqPartnerQuestion.
  ///
  /// In en, this message translates to:
  /// **'How does partner sharing work?'**
  String get helpFaqPartnerQuestion;

  /// No description provided for @helpFaqPartnerAnswer.
  ///
  /// In en, this message translates to:
  /// **'This version stores the partner email address and sharing preferences in your Firebase account. It does not yet send an invitation or transfer cycle or symptom records to a partner.'**
  String get helpFaqPartnerAnswer;

  /// No description provided for @helpFaqNotificationsQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can I customize notifications?'**
  String get helpFaqNotificationsQuestion;

  /// No description provided for @helpFaqNotificationsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open Profile, then Settings and Notifications to choose which local reminders are enabled.'**
  String get helpFaqNotificationsAnswer;

  /// No description provided for @helpFaqDeleteQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account or data?'**
  String get helpFaqDeleteQuestion;

  /// No description provided for @helpFaqDeleteAnswer.
  ///
  /// In en, this message translates to:
  /// **'You can clear local data under Profile > Account Security and delete an optional journal cloud copy under Settings > Journal Sync. This version does not yet provide in-app deletion of the Firebase account and all other cloud records. The publisher must provide a verified privacy contact before public release.'**
  String get helpFaqDeleteAnswer;

  /// No description provided for @helpFaqSupportQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can I contact support?'**
  String get helpFaqSupportQuestion;

  /// No description provided for @helpFaqSupportAnswer.
  ///
  /// In en, this message translates to:
  /// **'Use the contact options at the bottom of this page.'**
  String get helpFaqSupportAnswer;

  /// No description provided for @securityIncorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN.'**
  String get securityIncorrectPin;

  /// No description provided for @securityAuthenticationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Authentication successful'**
  String get securityAuthenticationSuccess;

  /// No description provided for @securityPinRequired.
  ///
  /// In en, this message translates to:
  /// **'PIN required'**
  String get securityPinRequired;

  /// No description provided for @securityAuthenticationError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Try again.'**
  String get securityAuthenticationError;

  /// No description provided for @securitySkipDevelopmentOnly.
  ///
  /// In en, this message translates to:
  /// **'Skip (development only)'**
  String get securitySkipDevelopmentOnly;

  /// No description provided for @securityRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get securityRetry;

  /// No description provided for @securityLockedFor.
  ///
  /// In en, this message translates to:
  /// **'Locked for {minutes}m {seconds}s'**
  String securityLockedFor(int minutes, int seconds);

  /// No description provided for @journalNoEntryForDay.
  ///
  /// In en, this message translates to:
  /// **'No entry for this day'**
  String get journalNoEntryForDay;

  /// No description provided for @journalQuickLogPrompt.
  ///
  /// In en, this message translates to:
  /// **'Use Quick Log to capture this moment.'**
  String get journalQuickLogPrompt;

  /// No description provided for @moodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodExcited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get moodExcited;

  /// No description provided for @moodAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get moodAnxious;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodTired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get moodTired;

  /// No description provided for @journalDeleteMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this memory?'**
  String get journalDeleteMemoryTitle;

  /// No description provided for @journalDeleteMemoryBody.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone.'**
  String get journalDeleteMemoryBody;

  /// No description provided for @journalTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get journalTimeline;

  /// No description provided for @journalSearchAllMoods.
  ///
  /// In en, this message translates to:
  /// **'All moods'**
  String get journalSearchAllMoods;

  /// No description provided for @journalFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get journalFavorites;

  /// No description provided for @journalDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get journalDateFilter;

  /// No description provided for @journalSearchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get journalSearchNoResults;

  /// No description provided for @journalFilterByMood.
  ///
  /// In en, this message translates to:
  /// **'Filter by mood'**
  String get journalFilterByMood;

  /// No description provided for @journalAllFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get journalAllFilter;

  /// No description provided for @journalCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current streak'**
  String get journalCurrentStreak;

  /// No description provided for @journalMoodDistribution.
  ///
  /// In en, this message translates to:
  /// **'Mood distribution'**
  String get journalMoodDistribution;

  /// No description provided for @journalWeeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly activity'**
  String get journalWeeklyActivity;

  /// No description provided for @journalTopTags.
  ///
  /// In en, this message translates to:
  /// **'Top tags'**
  String get journalTopTags;

  /// No description provided for @journalInsightsNotEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data for insights yet 🌿'**
  String get journalInsightsNotEnoughData;

  /// No description provided for @journalQuickThought.
  ///
  /// In en, this message translates to:
  /// **'Quick thought'**
  String get journalQuickThought;

  /// No description provided for @journalWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get journalWrite;

  /// No description provided for @journalQuickThoughtHint.
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get journalQuickThoughtHint;

  /// No description provided for @journalCaptureMoment.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture a quick moment...'**
  String get journalCaptureMoment;

  /// No description provided for @journalQuickThoughtSaved.
  ///
  /// In en, this message translates to:
  /// **'Quick thought saved 😌'**
  String get journalQuickThoughtSaved;

  /// No description provided for @journalStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get journalStreak;

  /// No description provided for @journalInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get journalInsights;

  /// No description provided for @journalWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get journalWeekly;

  /// No description provided for @journalRecentEntries.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get journalRecentEntries;

  /// No description provided for @journalSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get journalSeeAll;

  /// No description provided for @journalNoEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get journalNoEntriesYet;

  /// No description provided for @journalPhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get journalPhotoGallery;

  /// No description provided for @journalTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get journalTakePhoto;

  /// No description provided for @journalImageAdded.
  ///
  /// In en, this message translates to:
  /// **'Image added to your journal.'**
  String get journalImageAdded;

  /// No description provided for @journalAudioComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Audio recording will be available soon.'**
  String get journalAudioComingSoon;

  /// No description provided for @journalMoodQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get journalMoodQuestion;

  /// No description provided for @journalNoteCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String journalNoteCount(int count);

  /// No description provided for @journalStreakCount.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String journalStreakCount(int count);

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select a date range'**
  String get selectDateRange;

  /// No description provided for @journalEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get journalEditAction;

  /// No description provided for @journalQuietMoment.
  ///
  /// In en, this message translates to:
  /// **'A quiet moment'**
  String get journalQuietMoment;

  /// No description provided for @journalLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Journal is locked'**
  String get journalLockedTitle;

  /// No description provided for @journalLockedDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN or use biometrics to access your private notes.'**
  String get journalLockedDescription;

  /// No description provided for @journalUseBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Use biometrics'**
  String get journalUseBiometrics;

  /// No description provided for @journalUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock your private journal'**
  String get journalUnlockReason;

  /// No description provided for @securityBiometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication failed. Try again or enter your PIN.'**
  String get securityBiometricFailed;

  /// No description provided for @journalSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save your journal entry. Please try again.'**
  String get journalSaveError;

  /// No description provided for @journalDailyQuote.
  ///
  /// In en, this message translates to:
  /// **'“Every moment is a fresh beginning.”'**
  String get journalDailyQuote;

  /// No description provided for @educationReadingTime.
  ///
  /// In en, this message translates to:
  /// **'about {minutes} min read'**
  String educationReadingTime(int minutes);

  /// No description provided for @selfCarePrompt.
  ///
  /// In en, this message translates to:
  /// **'What do you want to learn today?'**
  String get selfCarePrompt;

  /// No description provided for @selfCareFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get selfCareFilterAll;

  /// No description provided for @selfCareFilterCramps.
  ///
  /// In en, this message translates to:
  /// **'Cramps relief'**
  String get selfCareFilterCramps;

  /// No description provided for @selfCareFilterStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength and flexibility'**
  String get selfCareFilterStrength;

  /// No description provided for @selfCareFilterFacial.
  ///
  /// In en, this message translates to:
  /// **'Facial care'**
  String get selfCareFilterFacial;

  /// No description provided for @selfCareCategoryCramps.
  ///
  /// In en, this message translates to:
  /// **'Gentle movement for cramps'**
  String get selfCareCategoryCramps;

  /// No description provided for @selfCareCategoryStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength and flexibility'**
  String get selfCareCategoryStrength;

  /// No description provided for @selfCareCategoryFacial.
  ///
  /// In en, this message translates to:
  /// **'Facial care'**
  String get selfCareCategoryFacial;

  /// No description provided for @selfCareCategoryStretching.
  ///
  /// In en, this message translates to:
  /// **'Relaxing stretches'**
  String get selfCareCategoryStretching;

  /// No description provided for @selfCareCategoryArticles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get selfCareCategoryArticles;

  /// No description provided for @selfCareBadgeGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get selfCareBadgeGetStarted;

  /// No description provided for @selfCareCardBalance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get selfCareCardBalance;

  /// No description provided for @selfCareCardFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get selfCareCardFocus;

  /// No description provided for @selfCareCardStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get selfCareCardStrength;

  /// No description provided for @selfCareCardFlexibility.
  ///
  /// In en, this message translates to:
  /// **'Flexibility'**
  String get selfCareCardFlexibility;

  /// No description provided for @selfCareCardGentleFacialMassage.
  ///
  /// In en, this message translates to:
  /// **'Gentle facial massage'**
  String get selfCareCardGentleFacialMassage;

  /// No description provided for @selfCareCardGlowSkin.
  ///
  /// In en, this message translates to:
  /// **'Glow up your skin'**
  String get selfCareCardGlowSkin;

  /// No description provided for @selfCareCardNeckPainRelief.
  ///
  /// In en, this message translates to:
  /// **'Neck pain relief'**
  String get selfCareCardNeckPainRelief;

  /// No description provided for @selfCareCardLowerBackStretch.
  ///
  /// In en, this message translates to:
  /// **'Lower back stretch'**
  String get selfCareCardLowerBackStretch;

  /// No description provided for @selfCareCardPeriodPainRelief.
  ///
  /// In en, this message translates to:
  /// **'Period pain relief'**
  String get selfCareCardPeriodPainRelief;

  /// No description provided for @selfCareSubtitleGentleYoga.
  ///
  /// In en, this message translates to:
  /// **'Gentle yoga to ease tension'**
  String get selfCareSubtitleGentleYoga;

  /// No description provided for @selfCareSubtitleBreathingRelease.
  ///
  /// In en, this message translates to:
  /// **'Breathing and slow release'**
  String get selfCareSubtitleBreathingRelease;

  /// No description provided for @selfCareSubtitleMobilityComfort.
  ///
  /// In en, this message translates to:
  /// **'Mobility for everyday comfort'**
  String get selfCareSubtitleMobilityComfort;

  /// No description provided for @selfCareSubtitleLiftSculpt.
  ///
  /// In en, this message translates to:
  /// **'Lift and sculpt softly'**
  String get selfCareSubtitleLiftSculpt;

  /// No description provided for @selfCareSubtitleCleanseHydrate.
  ///
  /// In en, this message translates to:
  /// **'Cleanse and hydrate'**
  String get selfCareSubtitleCleanseHydrate;

  /// No description provided for @selfCareSubtitleReleaseUpperBody.
  ///
  /// In en, this message translates to:
  /// **'Release upper-body tension'**
  String get selfCareSubtitleReleaseUpperBody;

  /// No description provided for @selfCareSubtitleSlowRestorative.
  ///
  /// In en, this message translates to:
  /// **'Slow restorative motion'**
  String get selfCareSubtitleSlowRestorative;

  /// No description provided for @selfCareLowImpactExercises.
  ///
  /// In en, this message translates to:
  /// **'{count} low-impact exercises'**
  String selfCareLowImpactExercises(int count);

  /// No description provided for @selfCareMinutesRead.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String selfCareMinutesRead(int minutes);

  /// No description provided for @selfCareDeepSleepMeditation.
  ///
  /// In en, this message translates to:
  /// **'Deep sleep meditation'**
  String get selfCareDeepSleepMeditation;

  /// No description provided for @selfCarePlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get selfCarePlay;

  /// No description provided for @selfCareNeedYogaPillow.
  ///
  /// In en, this message translates to:
  /// **'Yoga pillow'**
  String get selfCareNeedYogaPillow;

  /// No description provided for @selfCareNeedWaterBottle.
  ///
  /// In en, this message translates to:
  /// **'Water bottle'**
  String get selfCareNeedWaterBottle;

  /// No description provided for @selfCareNeedYogaMat.
  ///
  /// In en, this message translates to:
  /// **'Yoga mat'**
  String get selfCareNeedYogaMat;

  /// No description provided for @selfCareStepChinToChest.
  ///
  /// In en, this message translates to:
  /// **'Chin to chest'**
  String get selfCareStepChinToChest;

  /// No description provided for @selfCareStepReclineReset.
  ///
  /// In en, this message translates to:
  /// **'Recline reset'**
  String get selfCareStepReclineReset;

  /// No description provided for @selfCareStepSupportedPigeon.
  ///
  /// In en, this message translates to:
  /// **'Supported pigeon'**
  String get selfCareStepSupportedPigeon;

  /// No description provided for @selfCareStepButterflyFold.
  ///
  /// In en, this message translates to:
  /// **'Butterfly fold'**
  String get selfCareStepButterflyFold;

  /// No description provided for @selfCareStepLotusLift.
  ///
  /// In en, this message translates to:
  /// **'Lotus lift'**
  String get selfCareStepLotusLift;

  /// No description provided for @selfCareStepLegsUpWall.
  ///
  /// In en, this message translates to:
  /// **'Legs up the wall'**
  String get selfCareStepLegsUpWall;

  /// No description provided for @selfCareStepNeckLift.
  ///
  /// In en, this message translates to:
  /// **'Neck lift'**
  String get selfCareStepNeckLift;

  /// No description provided for @selfCareStepGuaShaMassage.
  ///
  /// In en, this message translates to:
  /// **'Gua sha massage'**
  String get selfCareStepGuaShaMassage;

  /// No description provided for @selfCareStepFacialCleansing.
  ///
  /// In en, this message translates to:
  /// **'Facial cleansing'**
  String get selfCareStepFacialCleansing;

  /// No description provided for @selfCareStepGlowPress.
  ///
  /// In en, this message translates to:
  /// **'Glow press'**
  String get selfCareStepGlowPress;

  /// No description provided for @selfCareStepHydrationLock.
  ///
  /// In en, this message translates to:
  /// **'Hydration lock'**
  String get selfCareStepHydrationLock;

  /// No description provided for @selfCareSubtitleChinUpward.
  ///
  /// In en, this message translates to:
  /// **'Chin upward'**
  String get selfCareSubtitleChinUpward;

  /// No description provided for @selfCareSubtitleSweepOutward.
  ///
  /// In en, this message translates to:
  /// **'Sweep outward gently'**
  String get selfCareSubtitleSweepOutward;

  /// No description provided for @selfCareSubtitleGentlyCleanse.
  ///
  /// In en, this message translates to:
  /// **'Gently cleanse face'**
  String get selfCareSubtitleGentlyCleanse;

  /// No description provided for @selfCareSubtitleLightCircular.
  ///
  /// In en, this message translates to:
  /// **'Light circular motion'**
  String get selfCareSubtitleLightCircular;

  /// No description provided for @selfCareSubtitleSealMoisture.
  ///
  /// In en, this message translates to:
  /// **'Seal in moisture'**
  String get selfCareSubtitleSealMoisture;

  /// No description provided for @selfCareSleepTrackCalmFlow.
  ///
  /// In en, this message translates to:
  /// **'Calm Flow'**
  String get selfCareSleepTrackCalmFlow;

  /// No description provided for @selfCareSleepTrackBreathOfLife.
  ///
  /// In en, this message translates to:
  /// **'Breath of Life'**
  String get selfCareSleepTrackBreathOfLife;

  /// No description provided for @selfCareSleepTrackSoulDrift.
  ///
  /// In en, this message translates to:
  /// **'Soul Drift'**
  String get selfCareSleepTrackSoulDrift;

  /// No description provided for @selfCareSleepTrackSoundsSerenity.
  ///
  /// In en, this message translates to:
  /// **'Sounds of Serenity'**
  String get selfCareSleepTrackSoundsSerenity;

  /// No description provided for @selfCareSleepTrackInnerPeace.
  ///
  /// In en, this message translates to:
  /// **'Inner Peace'**
  String get selfCareSleepTrackInnerPeace;

  /// No description provided for @selfCareSleepTrackMindfulJourney.
  ///
  /// In en, this message translates to:
  /// **'Mindful Journey'**
  String get selfCareSleepTrackMindfulJourney;

  /// No description provided for @selfCareSleepTrackWhisperingNature.
  ///
  /// In en, this message translates to:
  /// **'Whispering Nature'**
  String get selfCareSleepTrackWhisperingNature;

  /// No description provided for @selfCareSleepTrackNaturesRhythm.
  ///
  /// In en, this message translates to:
  /// **'Nature\'s Rhythm'**
  String get selfCareSleepTrackNaturesRhythm;

  /// No description provided for @selfCareSleepTrackGoldenDawn.
  ///
  /// In en, this message translates to:
  /// **'Golden Dawn'**
  String get selfCareSleepTrackGoldenDawn;

  /// No description provided for @selfCareSleepTrackHarmonyWithin.
  ///
  /// In en, this message translates to:
  /// **'Harmony Within'**
  String get selfCareSleepTrackHarmonyWithin;

  /// No description provided for @selfCareSleepTrackBreatheInSilence.
  ///
  /// In en, this message translates to:
  /// **'Breathe in Silence'**
  String get selfCareSleepTrackBreatheInSilence;

  /// No description provided for @selfCareSleepTrackDeepRestSession.
  ///
  /// In en, this message translates to:
  /// **'Deep Rest Session'**
  String get selfCareSleepTrackDeepRestSession;

  /// No description provided for @selfCareAlignMindBody.
  ///
  /// In en, this message translates to:
  /// **'Align mind and body'**
  String get selfCareAlignMindBody;

  /// No description provided for @selfCareActivityDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional, gentle pillow-supported movements. Comfort and response vary from person to person.'**
  String get selfCareActivityDescription;

  /// No description provided for @selfCareYouWillNeed.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need'**
  String get selfCareYouWillNeed;

  /// No description provided for @selfCareStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start'**
  String get selfCareStart;

  /// No description provided for @selfCareExerciseJumpingJacks.
  ///
  /// In en, this message translates to:
  /// **'Jumping jacks'**
  String get selfCareExerciseJumpingJacks;

  /// No description provided for @selfCareFullBodyCardio.
  ///
  /// In en, this message translates to:
  /// **'Full-body cardio'**
  String get selfCareFullBodyCardio;

  /// No description provided for @selfCareWait.
  ///
  /// In en, this message translates to:
  /// **'Wait!'**
  String get selfCareWait;

  /// No description provided for @selfCareQuit.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get selfCareQuit;

  /// No description provided for @selfCareKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get selfCareKeepGoing;

  /// No description provided for @selfCareStartExercises.
  ///
  /// In en, this message translates to:
  /// **'Start exercises'**
  String get selfCareStartExercises;

  /// No description provided for @selfCareGentleMovementTitle.
  ///
  /// In en, this message translates to:
  /// **'Gentle movement'**
  String get selfCareGentleMovementTitle;

  /// No description provided for @selfCareGentleMovementDescription.
  ///
  /// In en, this message translates to:
  /// **'Optional gentle movements may help some people feel more comfortable. Stop if pain increases or you feel dizzy or unwell.'**
  String get selfCareGentleMovementDescription;

  /// No description provided for @selfCareCongratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get selfCareCongratulations;

  /// No description provided for @selfCareCongratulationsMessage.
  ///
  /// In en, this message translates to:
  /// **'You completed your self-care session and took time for your body today.'**
  String get selfCareCongratulationsMessage;

  /// No description provided for @selfCareBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get selfCareBackHome;

  /// No description provided for @selfCareArticleReadTime.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String selfCareArticleReadTime(int minutes);

  /// No description provided for @selfCareArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Period pain: gentle options and when to seek help'**
  String get selfCareArticleTitle;

  /// No description provided for @selfCareArticleLead.
  ///
  /// In en, this message translates to:
  /// **'Cramping is common, but severe, changing, or disruptive pain deserves attention.'**
  String get selfCareArticleLead;

  /// No description provided for @selfCareArticleComfortHeading.
  ///
  /// In en, this message translates to:
  /// **'Gentle comfort options:'**
  String get selfCareArticleComfortHeading;

  /// No description provided for @selfCareArticleWarmCompress.
  ///
  /// In en, this message translates to:
  /// **'A warm compress or gentle movement may help some people.'**
  String get selfCareArticleWarmCompress;

  /// No description provided for @selfCareArticleRest.
  ///
  /// In en, this message translates to:
  /// **'Rest if you need it; stop an activity if pain or dizziness increases.'**
  String get selfCareArticleRest;

  /// No description provided for @selfCareArticleVaries.
  ///
  /// In en, this message translates to:
  /// **'What helps varies from person to person.'**
  String get selfCareArticleVaries;

  /// No description provided for @selfCareArticleMedicineHeading.
  ///
  /// In en, this message translates to:
  /// **'About medicines:'**
  String get selfCareArticleMedicineHeading;

  /// No description provided for @selfCareArticleMedicineRisks.
  ///
  /// In en, this message translates to:
  /// **'Pain medicines are not suitable for everyone and can have risks or interactions.'**
  String get selfCareArticleMedicineRisks;

  /// No description provided for @selfCareArticlePharmacist.
  ///
  /// In en, this message translates to:
  /// **'Ask a pharmacist or qualified health professional what is appropriate for you.'**
  String get selfCareArticlePharmacist;

  /// No description provided for @selfCareArticleFollowLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow the product label. This article does not recommend a medicine or dose.'**
  String get selfCareArticleFollowLabel;

  /// No description provided for @selfCareArticleSeekHelpHeading.
  ///
  /// In en, this message translates to:
  /// **'When to get help:'**
  String get selfCareArticleSeekHelpHeading;

  /// No description provided for @selfCareArticleDailyLife.
  ///
  /// In en, this message translates to:
  /// **'Arrange a health visit if pain repeatedly disrupts school, work, sleep, or daily activities.'**
  String get selfCareArticleDailyLife;

  /// No description provided for @selfCareArticleUrgent.
  ///
  /// In en, this message translates to:
  /// **'Seek urgent care for sudden severe pain, fainting, fever, or pain with bleeding when pregnancy is possible.'**
  String get selfCareArticleUrgent;

  /// No description provided for @selfCareArticleEncouragement.
  ///
  /// In en, this message translates to:
  /// **'You deserve care. Pain that disrupts daily life should be taken seriously.'**
  String get selfCareArticleEncouragement;

  /// No description provided for @selfCareAddComment.
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get selfCareAddComment;

  /// No description provided for @selfCareFeedbackThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback!'**
  String get selfCareFeedbackThanks;

  /// No description provided for @selfCareFeedbackReceived.
  ///
  /// In en, this message translates to:
  /// **'Feedback received. We\'ll do our best to bring you a better user experience.'**
  String get selfCareFeedbackReceived;

  /// No description provided for @selfCareOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get selfCareOk;

  /// No description provided for @selfCareSleepMeditationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep meditation'**
  String get selfCareSleepMeditationTitle;

  /// No description provided for @selfCareRelax.
  ///
  /// In en, this message translates to:
  /// **'Relax'**
  String get selfCareRelax;

  /// No description provided for @selfCarePeaceRelaxation.
  ///
  /// In en, this message translates to:
  /// **'Peace and relaxation'**
  String get selfCarePeaceRelaxation;

  /// No description provided for @selfCareTimes.
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get selfCareTimes;

  /// No description provided for @selfCarePrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get selfCarePrevious;

  /// No description provided for @selfCareNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get selfCareNext;

  /// No description provided for @selfCareMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String selfCareMinutes(int minutes);

  /// No description provided for @selfCareRound.
  ///
  /// In en, this message translates to:
  /// **'Round {round}'**
  String selfCareRound(int round);

  /// No description provided for @selfCareOnlyMinutesLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {minutes} minutes left — keep it up!'**
  String selfCareOnlyMinutesLeft(int minutes);

  /// No description provided for @cyclePhasePeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get cyclePhasePeriod;

  /// No description provided for @cyclePhaseLuteal.
  ///
  /// In en, this message translates to:
  /// **'Luteal phase'**
  String get cyclePhaseLuteal;

  /// No description provided for @cyclePhaseOvulation.
  ///
  /// In en, this message translates to:
  /// **'Ovulation'**
  String get cyclePhaseOvulation;

  /// No description provided for @cyclePhaseFollicular.
  ///
  /// In en, this message translates to:
  /// **'Follicular phase'**
  String get cyclePhaseFollicular;

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful'**
  String get authPasswordResetSuccess;

  /// No description provided for @authPasswordResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated. You can now log in with your new password.'**
  String get authPasswordResetSuccessMessage;

  /// No description provided for @aiChatCheckingIn.
  ///
  /// In en, this message translates to:
  /// **'Hey, just checking in.'**
  String get aiChatCheckingIn;

  /// No description provided for @aiChatPmsQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling around your PMS days lately?'**
  String get aiChatPmsQuestion;

  /// No description provided for @aiChatCrampsOrAches.
  ///
  /// In en, this message translates to:
  /// **'Cramps or body aches'**
  String get aiChatCrampsOrAches;

  /// No description provided for @aiChatPhaseVariation.
  ///
  /// In en, this message translates to:
  /// **'Got it. Everyone feels this phase a little differently.'**
  String get aiChatPhaseVariation;

  /// No description provided for @aiChatFocusQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you usually have trouble focusing or getting things done these days?'**
  String get aiChatFocusQuestion;

  /// No description provided for @aiChatYesALot.
  ///
  /// In en, this message translates to:
  /// **'Yes, a lot'**
  String get aiChatYesALot;

  /// No description provided for @aiChatGentleSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Here are a few gentle ways to stay balanced'**
  String get aiChatGentleSuggestions;

  /// No description provided for @aiSuggestionDrinkWater.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get aiSuggestionDrinkWater;

  /// No description provided for @aiSuggestionMoveGently.
  ///
  /// In en, this message translates to:
  /// **'Move gently'**
  String get aiSuggestionMoveGently;

  /// No description provided for @aiSuggestionTakePause.
  ///
  /// In en, this message translates to:
  /// **'Take a pause'**
  String get aiSuggestionTakePause;

  /// No description provided for @aiChatLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Would you like to learn a little more about this?'**
  String get aiChatLearnMore;

  /// No description provided for @aiChatImCurious.
  ///
  /// In en, this message translates to:
  /// **'Yes, I\'m curious'**
  String get aiChatImCurious;

  /// No description provided for @aiChatArticlePrompt.
  ///
  /// In en, this message translates to:
  /// **'Here\'s an article you can read.'**
  String get aiChatArticlePrompt;

  /// No description provided for @aiChatIReadIt.
  ///
  /// In en, this message translates to:
  /// **'I read it'**
  String get aiChatIReadIt;

  /// No description provided for @aiChatSymptomsPrompt.
  ///
  /// In en, this message translates to:
  /// **'I\'ve preselected your symptoms. Are these correct, or would you like to add others?'**
  String get aiChatSymptomsPrompt;

  /// No description provided for @aiChatSymptomsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Yes, that works!'**
  String get aiChatSymptomsConfirmed;

  /// No description provided for @aiChatSetSymptomsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your symptoms are all set'**
  String get aiChatSetSymptomsTitle;

  /// No description provided for @aiChatOpenSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Open symptoms'**
  String get aiChatOpenSymptoms;

  /// No description provided for @aiChatArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Never-ending cramps'**
  String get aiChatArticleTitle;

  /// No description provided for @aiChatArticleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'When period pain isn\'t typical.'**
  String get aiChatArticleSubtitle;

  /// No description provided for @aiChatArticleDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn why cramps can linger and when to seek help. Find gentle options that may ease discomfort.'**
  String get aiChatArticleDescription;

  /// No description provided for @aiChatReadNow.
  ///
  /// In en, this message translates to:
  /// **'Read now'**
  String get aiChatReadNow;

  /// No description provided for @aiChatAfterPmsSupport.
  ///
  /// In en, this message translates to:
  /// **'We know it\'s not easy to get through days like this. You\'re not alone.'**
  String get aiChatAfterPmsSupport;

  /// No description provided for @aiChatCalendarPmsDoctor.
  ///
  /// In en, this message translates to:
  /// **'Your calendar shows PMS days from the 13th to the 17th, and a doctor\'s appointment on the 18th.'**
  String get aiChatCalendarPmsDoctor;

  /// No description provided for @aiChatSuggestDate.
  ///
  /// In en, this message translates to:
  /// **'I suggest the 19th instead. How does that sound?'**
  String get aiChatSuggestDate;

  /// No description provided for @aiChatAssistantLabel.
  ///
  /// In en, this message translates to:
  /// **'Your assistant'**
  String get aiChatAssistantLabel;

  /// No description provided for @aiChatPmsConflict.
  ///
  /// In en, this message translates to:
  /// **'PMS day conflict'**
  String get aiChatPmsConflict;

  /// No description provided for @aiChatDoctorVisitConflict.
  ///
  /// In en, this message translates to:
  /// **'Doctor visit conflict'**
  String get aiChatDoctorVisitConflict;

  /// No description provided for @aiChatAskAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask anything...'**
  String get aiChatAskAnything;

  /// No description provided for @appointmentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Appointment confirmed!'**
  String get appointmentConfirmed;

  /// No description provided for @appointmentBooked.
  ///
  /// In en, this message translates to:
  /// **'Your appointment with Dr. {doctor} is booked.'**
  String appointmentBooked(String doctor);

  /// No description provided for @appointmentReviewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String appointmentReviewCount(int count);

  /// No description provided for @appointmentGynecologist.
  ///
  /// In en, this message translates to:
  /// **'Gynecologist'**
  String get appointmentGynecologist;

  /// No description provided for @appointmentGynOncologyFocus.
  ///
  /// In en, this message translates to:
  /// **'Focus on gynecologic oncology screening'**
  String get appointmentGynOncologyFocus;

  /// No description provided for @appointmentVideoConsultation.
  ///
  /// In en, this message translates to:
  /// **'Video consultation'**
  String get appointmentVideoConsultation;

  /// No description provided for @appointmentDoneBackToChat.
  ///
  /// In en, this message translates to:
  /// **'Done, back to chat'**
  String get appointmentDoneBackToChat;

  /// No description provided for @aiChatSymptomCramps.
  ///
  /// In en, this message translates to:
  /// **'Cramps'**
  String get aiChatSymptomCramps;

  /// No description provided for @aiChatSymptomHeadache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get aiChatSymptomHeadache;

  /// No description provided for @periodLogSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Log your period'**
  String get periodLogSheetTitle;

  /// No description provided for @periodLogSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the period update that best describes today.'**
  String get periodLogSheetSubtitle;

  /// No description provided for @minimumAgeMessage.
  ///
  /// In en, this message translates to:
  /// **'Peria is for people aged {age} and older.'**
  String minimumAgeMessage(int age);

  /// No description provided for @ageRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Age requirement'**
  String get ageRestrictedTitle;

  /// No description provided for @ageRestrictedBody.
  ///
  /// In en, this message translates to:
  /// **'Peria isn\'t available under {age}. Update your date of birth to continue.'**
  String ageRestrictedBody(int age);

  /// No description provided for @updateDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Update date of birth'**
  String get updateDateOfBirth;

  /// No description provided for @pressBackAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press back again to leave'**
  String get pressBackAgainToExit;

  /// No description provided for @symptomLogUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Saved symptoms couldn\'t be loaded. You can still log this day.'**
  String get symptomLogUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
