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
