// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Peria';

  @override
  String get welcomeTitle => 'Welcome To Peria';

  @override
  String get welcomeSubtitle =>
      'Peria helps you understand your body\\nwith calm, personalized guidance.';

  @override
  String get turnOnNotifications => 'Turn on notification';

  @override
  String get anotherTime => 'Another time';

  @override
  String get registerTitle => 'Let\'s get you started';

  @override
  String get registerSubtitle => 'Login or create an account to get started.';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get orDivider => 'Or';

  @override
  String get enterYourEmailTitle => 'Enter your email';

  @override
  String get enterYourEmailSubtitle =>
      'We\'ll check if you already have an account';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get emailAddressLabel => 'Email Address';

  @override
  String get yourEmailAddressHint => 'Your email address';

  @override
  String get continueCta => 'Continue';

  @override
  String get skip => 'Skip';

  @override
  String get createAccountTitle => 'Create your account';

  @override
  String get createAccountSubtitle =>
      'Set a password to create your Peria account.';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get enterYourPasswordHint => 'Enter your password';

  @override
  String get forgotYourPassword => 'Forgot your password?';

  @override
  String get setGoalsTitle => 'What\'s your goal?';

  @override
  String get setGoalsSubtitle =>
      'Choose what you\'d like to focus on so we can\\ntailor your experience.';

  @override
  String get askNameTitle => 'What should we call you?';

  @override
  String get askNameSubtitle => 'Let\'s make this experience truly yours.';

  @override
  String get enterYourNameHint => 'Enter your name';

  @override
  String get dateOfBirthTitle => 'Date of birth';

  @override
  String get dateOfBirthSubtitle =>
      'This helps us personalize your experience.';

  @override
  String get whenWasYourLastPeriodTitle => 'When was your last period?';

  @override
  String get whenWasYourLastPeriodSubtitle =>
      'Select the days your last period started.';

  @override
  String get notSure => 'Not sure';

  @override
  String get today => 'Today';

  @override
  String get madeByIm => 'Made by IM';

  @override
  String get nextPeriodUnknown => 'Next period: unknown';

  @override
  String get periodIsDue => 'Period is due';

  @override
  String nextPeriodInDays(int days) {
    return 'Next period in $days days';
  }

  @override
  String get day => 'Day';

  @override
  String get days => 'Days';

  @override
  String get otpTitle => 'Enter verification code';

  @override
  String otpSubtitle(String email) {
    return 'We sent a code to $email';
  }

  @override
  String get didntGetCode => 'Didn\'t get the code?';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get resendNow => 'Resend now';

  @override
  String get otpContinue => 'Continue';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalCloudSync => 'Journal cloud sync';

  @override
  String get journalSyncDescription =>
      'By default, your journal stays encrypted on this device. If you opt in, existing and future entries are stored in your Peria account in Firebase Firestore. The cloud copy is not end-to-end encrypted by Peria.';

  @override
  String get journalSyncEnabledDescription =>
      'New and existing journal entries from this device sync to your Peria cloud account.';

  @override
  String get journalSyncDisabledDescription =>
      'Cloud sync is off on this device. Your journal stays here.';

  @override
  String get journalSyncConsentTitle => 'Before enabling journal sync';

  @override
  String get journalSyncConsentBody =>
      'If you agree, Peria sends your existing and future journal entries—including titles, text, moods, dates, tags, attachment references and other saved details—to your account in Firebase Firestore. This is cloud storage and is not end-to-end encrypted by Peria. Firestore may also keep an offline cache on this device, separate from Hive’s encrypted copy. You can turn sync off at any time; disabling it does not delete copies already uploaded or writes already queued.';

  @override
  String get enableAndSync => 'I agree and enable sync';

  @override
  String get journalSyncDisableTitle => 'Turn off journal sync?';

  @override
  String get journalSyncDisableBody =>
      'Turning this off on this device stops its future automatic uploads. Copies already stored in Firestore, including writes already queued, may remain until you delete them below. Your local journal stays on this device.';

  @override
  String get turnOffSync => 'Turn off sync';

  @override
  String get journalSyncLocalOnly =>
      'Cloud sync is off on this device. Your local journal is available here; an older cloud copy may remain until deleted.';

  @override
  String get journalSyncNotYet => 'No successful cloud sync yet.';

  @override
  String journalSyncLastSynced(String time) {
    return 'Last successful sync: $time';
  }

  @override
  String get journalSyncFailed =>
      'The last cloud sync failed. Try again when you are online.';

  @override
  String get syncNow => 'Sync now';

  @override
  String get journalSyncCompleted => 'Your journal was synchronized.';

  @override
  String get journalSyncError =>
      'Could not synchronize the journal. Your local entries are still available.';

  @override
  String get journalSyncSettingsError =>
      'Could not update the journal sync setting. Please try again.';

  @override
  String get deleteCloudCopy => 'Delete cloud copy';

  @override
  String get journalCloudDeleteTitle => 'Delete the cloud copy?';

  @override
  String get journalCloudDeleteBody =>
      'This turns off sync on this device and deletes journal entries stored in Firestore for this account. An internet connection is required. Another device with sync enabled may upload entries again. Your local entries on this device will not be deleted.';

  @override
  String get journalCloudDeleteSuccess =>
      'The cloud copy was deleted. Your local journal remains on this device.';

  @override
  String get journalCloudDeleteError =>
      'Could not delete the cloud copy. Sync is off; check your connection and try again.';

  @override
  String get journalCloudLegacyCopyNotice =>
      'If you used an earlier version of Peria, journal entries may already exist in the cloud. Turning sync off does not remove them; use “Delete cloud copy” to remove them.';

  @override
  String get journalSubtitle =>
      'Your private space to note feelings, thoughts and body patterns.';

  @override
  String get searchJournalHint => 'Search journal...';

  @override
  String get clearAll => 'Clear all';

  @override
  String get newEntry => 'New entry';

  @override
  String get noMatchingNotes => 'No matching notes';

  @override
  String get journalEmpty => 'Your journal is empty';

  @override
  String get tryAnotherKeyword => 'Try another keyword.';

  @override
  String get startFirstNote =>
      'Start your first private note. It stays on this device.';

  @override
  String get untitledNote => 'Untitled note';

  @override
  String get noDetailsYet => 'No details yet.';

  @override
  String get delete => 'Delete';

  @override
  String get saveEntry => 'Save entry';

  @override
  String get writeFreelyHint => 'Write freely. This note stays on your device.';

  @override
  String get myProfile => 'My Profile';

  @override
  String get myAccount => 'My Account';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get partner => 'Partner';

  @override
  String get accountSecurity => 'Account & Security';

  @override
  String get appSetting => 'App Setting';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get navCycle => 'Cycle';

  @override
  String get navEducation => 'Education';

  @override
  String get navJournal => 'Journal';

  @override
  String get notificationGenericTitle => 'Peria';

  @override
  String get notificationGenericBody => 'A gentle reminder is waiting.';

  @override
  String get notificationChannelName => 'Peria';

  @override
  String get notificationChannelDescription => 'Private reminders from Peria.';

  @override
  String get notificationPrivacyDescription =>
      'Notifications use neutral wording to keep cycle details private on your lock screen.';

  @override
  String get notificationScheduleDescription =>
      'When enabled, cycle reminders are planned for 9:00 and the daily symptoms and journal check-in for 20:00.';

  @override
  String get notificationPermissionDenied =>
      'Notifications could not be enabled. Check notification permission in your device settings, then try again.';

  @override
  String get supportLegal => 'Support & Legal';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get logOut => 'Log out';

  @override
  String get cycleProfile => 'Cycle profile';

  @override
  String get cycleProfileDescription =>
      'These settings are the source of truth for calculating your next period and fertility windows.';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get selectDate => 'Select a date';

  @override
  String get averageCycleLength => 'Average cycle length';

  @override
  String get periodLength => 'Period length';

  @override
  String get lastPeriodStartDate => 'Last period start date';

  @override
  String get regularCycleQuestion => 'Regular cycle?';

  @override
  String get regular => 'Regular';

  @override
  String get irregular => 'Irregular';

  @override
  String get changesSavedAutomatically =>
      'Changes are saved automatically as soon as you update a value.';

  @override
  String get unableToLoadProfile => 'Unable to load profile';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get logSymptoms => 'Log Symptoms';

  @override
  String get symptomJournalReminder => 'Symptoms & journal check-in';

  @override
  String get quickDailySymptomCapture =>
      'Quick daily symptom capture. Tap everything that matches how you feel today.';

  @override
  String get save => 'Save';

  @override
  String get notes => 'Notes';

  @override
  String get writeHowYouFeelToday => 'Write how you feel today...';

  @override
  String get intensity => 'Intensity';

  @override
  String get sexualActivity => 'Sexual activity';

  @override
  String get protectedSex => 'Protected Sex';

  @override
  String get orgasm => 'Orgasm';

  @override
  String get highActivity => 'High activity';

  @override
  String get unprotectedSex => 'Unprotected sex';

  @override
  String get mental => 'Mental';

  @override
  String get breathingExercises => 'Breathing Exercises';

  @override
  String get stress => 'Stress';

  @override
  String get yoga => 'Yoga';

  @override
  String get meditation => 'Meditation';

  @override
  String get discharge => 'Discharge';

  @override
  String get unusual => 'Unusual';

  @override
  String get sticky => 'Sticky';

  @override
  String get bleeding => 'Bleeding';

  @override
  String get heavyBleeding => 'Heavy Bleeding';

  @override
  String get lowBleeding => 'Low Bleeding';

  @override
  String get physicalActivity => 'Physical activity';

  @override
  String get noExercise => 'No Exercise';

  @override
  String get teamSports => 'Team sports';

  @override
  String get cycling => 'Cycling';

  @override
  String get gym => 'Gym';

  @override
  String get dancing => 'Dancing';

  @override
  String get aerobics => 'Aerobics';

  @override
  String get swimming => 'Swimming';

  @override
  String get mood => 'Mood';

  @override
  String get anxious => 'Anxious';

  @override
  String get sad => 'Sad';

  @override
  String get happy => 'Happy';

  @override
  String get calm => 'Calm';

  @override
  String get angry => 'Angry';

  @override
  String get energetic => 'Energetic';

  @override
  String get confused => 'Confused';

  @override
  String get depressed => 'Depressed';

  @override
  String get sharingSettings => 'Sharing Settings';

  @override
  String get chooseWhatToShare => 'Choose What to Share';

  @override
  String get manageSharedCycleData =>
      'You can now manage your shared cycle data and insights below.';

  @override
  String get cyclePredictions => 'Cycle Predictions';

  @override
  String get loggedSymptoms => 'Logged Symptoms';

  @override
  String get periodDates => 'Period Dates';

  @override
  String get moodEntries => 'Mood Entries';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get unableToLoadSharingSettings => 'Unable to load sharing settings';

  @override
  String get allowNotifications => 'Allow Notifications';

  @override
  String get periodStarting => 'Period Starting';

  @override
  String get fertileWindow => 'Fertile Window';

  @override
  String get ovulationDay => 'Ovulation Day';

  @override
  String get reminders => 'Reminders';

  @override
  String get partnerUpdates => 'Partner Updates';

  @override
  String get unableToLoadNotifications => 'Unable to load notifications';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageSaveError =>
      'Could not save your language preference. Please try again.';

  @override
  String get theme => 'Theme';

  @override
  String get cycleSettings => 'Cycle Settings';

  @override
  String get cycleLength => 'Cycle Length';

  @override
  String get integrationsSync => 'Integrations & Sync';

  @override
  String get connectedApps => 'Connected Apps';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get appVersion => 'App Version';

  @override
  String get unableToLoadSettings => 'Unable to load settings';

  @override
  String connectedPartnerTitle(String partnerName) {
    return 'You\'re connected with $partnerName!';
  }

  @override
  String get yourPartnerFallback => 'your partner';

  @override
  String get partnerConnectedDescription =>
      'You can now manage your shared cycle data and insights below.';

  @override
  String get statusConnected => 'Status: Connected';

  @override
  String get manageSharingSettings => 'Manage Sharing Settings';

  @override
  String get disconnectPartner => 'Disconnect Partner';

  @override
  String get unableToLoadPartner => 'Unable to load partner';

  @override
  String disconnectFromPartnerTitle(String partnerName) {
    return 'Disconnect from $partnerName?';
  }

  @override
  String get disconnectWarning =>
      'This will immediately stop all data sharing.';

  @override
  String get cancel => 'Cancel';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get invitePartner => 'Invite Partner';

  @override
  String get inviteYourPartner => 'Invite your partner';

  @override
  String get partnerInviteDescription =>
      'We\'ll send a secure, private invitation link for your partner.';

  @override
  String get partnerEmailAddress => 'Partner\'s Email Address';

  @override
  String get sendInvitation => 'Send Invitation';

  @override
  String get shareLinkManually => 'Share Link Manually';

  @override
  String get invitationSent => 'Invitation Sent!';

  @override
  String get partnerInvitationSentDescription =>
      'Your partner has been sent an invitation to accept.';

  @override
  String get gotIt => 'Got it';

  @override
  String get partnerInvitationPendingTitle => 'You\'ve Invited Your Partner!';

  @override
  String get partnerInvitationPendingDescription =>
      'We\'ll let you know when they accept.';

  @override
  String get statusPendingApproval => 'Status: Pending Approval';

  @override
  String get resendInvitation => 'Resend Invitation';

  @override
  String get cancelInvitation => 'Cancel Invitation';

  @override
  String get unableToLoadInvitation => 'Unable to load invitation';

  @override
  String get yourPartnerIsConnected => 'Your partner is connected';

  @override
  String get invitationPending => 'Invitation pending';

  @override
  String get connectWithYourPartner => 'Connect with your partner';

  @override
  String get partnerConnectedBody =>
      'Manage what your partner can see from your cycle and wellbeing data.';

  @override
  String get partnerPendingBody =>
      'Your invitation has been sent. You can manage or resend it from the next screen.';

  @override
  String get partnerInviteBody =>
      'Securely share key cycle dates, predictions, and ovulation windows.';

  @override
  String get manageSharing => 'Manage Sharing';

  @override
  String get viewInvitation => 'View Invitation';

  @override
  String get learnMore => 'Learn More';

  @override
  String get unableToLoadPartnerSettings => 'Unable to load partner settings';

  @override
  String get security => 'Security';

  @override
  String get setPinLock => 'Set PIN lock';

  @override
  String get changePin => 'Change PIN';

  @override
  String get enterPin => 'Enter PIN:';

  @override
  String get newPin => 'New PIN:';

  @override
  String get confirmPin => 'Confirm PIN:';

  @override
  String get pinsDoNotMatch => 'PINs do not match';

  @override
  String get enter4Digits => 'Enter 4 digits';

  @override
  String get appLock => 'App Lock';

  @override
  String get journalLock => 'Journal Lock';

  @override
  String get unableToLoadJournal => 'Unable to load journal';

  @override
  String get privateByDefault => 'Private by default on this device.';

  @override
  String get faceId => 'Face ID';

  @override
  String get changePinButton => 'Change PIN';

  @override
  String get disablePinLock => 'Disable PIN lock';

  @override
  String get unableToLoadSecuritySettings => 'Unable to load security settings';

  @override
  String get unableToLoadAccountSettings => 'Unable to load account settings';

  @override
  String get appAccess => 'App Access';

  @override
  String get confidentiality => 'Confidentiality';

  @override
  String get management => 'Management';

  @override
  String get globalSecurity => 'Global Security (PIN/FaceID)';

  @override
  String get biometricAuth => 'Biometric Authentication';

  @override
  String get multitaskProtection => 'Hide sensitive content while multitasking';

  @override
  String get clearLocalData => 'Clear local data';

  @override
  String get confirmClearData => 'Clear all data?';

  @override
  String get clearDataWarning =>
      'This action cannot be undone and will delete your entire history.';

  @override
  String get securityRequired => 'Security required';

  @override
  String get globalSecurityRequiredForJournal =>
      'Secure access (PIN/Face ID) must be enabled before the journal can be protected.';

  @override
  String get ok => 'OK';

  @override
  String get myDairy => 'This is my diary...';

  @override
  String get aboutYourDay => 'Tell me about your day...';

  @override
  String get howDoYouFell => 'How are you feeling?';

  @override
  String get educationGreeting => 'Hello Peria';

  @override
  String get educationSpace => 'Your education space';

  @override
  String get educationWhatToLearn => 'What would you like to learn today?';

  @override
  String get educationRecentArticles => 'Recent articles';

  @override
  String get educationSearchResults => 'Search results';

  @override
  String get searchAction => 'Search';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get educationSearchHint => 'Search an article...';

  @override
  String get educationNoArticleFound => 'No article found';

  @override
  String get educationNoArticles => 'No articles';

  @override
  String get educationTryAnotherSearch => 'Try another search';

  @override
  String get educationChooseCategory => 'Choose a category';

  @override
  String get educationHeroTitle => 'Learn gently';

  @override
  String get educationHeroSubtitle =>
      'Explore simple answers to your most common questions.';

  @override
  String get educationHeroFooter => 'Access clear answers, step by step.';

  @override
  String get educationSuggestionsTitle => 'Suggestions for you';

  @override
  String get educationSuggestionsSubtitle =>
      'Based on your cycle and recent entries.';

  @override
  String get educationArticleNotFound => 'Article not found';

  @override
  String get educationArticleSaved => 'Article added to favorites';

  @override
  String get educationExplanation => 'Explanation';

  @override
  String get educationObserve => 'What to observe';

  @override
  String get educationAdvice => 'Advice';

  @override
  String get educationWhenToConsult => 'When to consult';

  @override
  String get educationRelatedTags => 'Related tags';

  @override
  String educationUpdated(String value) {
    return 'Updated: $value';
  }

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyAdvanced => 'Advanced';

  @override
  String get educationAxisCycleBasics => 'Understand the cycle';

  @override
  String get educationAxisOvulationFertility => 'Ovulation and fertility';

  @override
  String get educationAxisMenstruationSymptoms => 'Periods and symptoms';

  @override
  String get educationAxisNormalVsAbnormal => 'Normal vs abnormal';

  @override
  String get educationAxisSolutionsWellbeing => 'Relief and wellbeing';

  @override
  String get educationHealthNoticeTitle =>
      'Health information, not a diagnosis';

  @override
  String get educationHealthNoticeBody =>
      'These articles are for general education and do not replace advice from a qualified health professional. Seek urgent care for sudden severe symptoms, fainting, or heavy bleeding.';

  @override
  String get educationMovementNoticeTitle => 'Movement is optional';

  @override
  String get educationMovementNoticeBody =>
      'This routine is for general wellbeing, not treatment. Stop if pain increases or you feel dizzy or unwell. Seek health advice for severe or unusual symptoms.';

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String weeksAgo(int count) {
    return '$count week(s) ago';
  }

  @override
  String monthsAgo(int count) {
    return '$count month(s) ago';
  }

  @override
  String get articleHealthyDiet => 'Healthy diet';

  @override
  String get articleSkinCare => 'Skin care';

  @override
  String get articleYogaTips => 'Yoga tips';

  @override
  String get logPeriodButton => 'Log Period';

  @override
  String get logPeriodSheetTitle => 'Log period';

  @override
  String get logPeriodSheetSubtitle =>
      'Quick daily capture. Use Edit Calendar for precise date corrections.';

  @override
  String get periodStartedToday => 'Period started today';

  @override
  String get periodStartedTodaySubtitle =>
      'Record today as the first day of your period.';

  @override
  String get addTodayPeriodDay => 'Add today as a period day';

  @override
  String get addTodayPeriodDaySubtitle =>
      'Record today and extend the latest period only when the days are consecutive.';

  @override
  String get periodEndedToday => 'Period ended today';

  @override
  String get periodEndedTodaySubtitle =>
      'Close a period logged today or yesterday.';

  @override
  String get openStructuredPeriodEdit => 'Open calendar edit';

  @override
  String get periodLogLoading => 'Loading period logs…';

  @override
  String get periodLogSaving => 'Saving period log…';

  @override
  String get periodLogLoadError =>
      'Could not load period logs. Try again or use Edit Calendar.';

  @override
  String get periodLogAlreadyLoggedToday =>
      'Today is already recorded as a period day.';

  @override
  String get periodLogNoRecentToEnd =>
      'No period is logged today or yesterday to close. Use Edit Calendar to correct the dates.';

  @override
  String get periodLogSaveError =>
      'Could not save the period log. Check your connection and try again.';

  @override
  String get update => 'Update';

  @override
  String get calendarTitle => 'Cycle Calendar';

  @override
  String get calendarNoCycleData => 'No cycle data';

  @override
  String get calendarNoCyclePredictionAvailable =>
      'No cycle prediction is available for this date.';

  @override
  String get calendarOverdue => 'Overdue';

  @override
  String get calendarExpectedNotLogged =>
      'Your period is expected but has not been logged.';

  @override
  String get calendarLoggedPeriodDay => 'Logged period day';

  @override
  String get calendarLoggedPeriodDescription =>
      'This date is recorded in your period log.';

  @override
  String get calendarPredictedPeriodDay => 'Predicted period day';

  @override
  String get calendarPredictedPeriodDescription =>
      'This date is an estimate based on your cycle data.';

  @override
  String get calendarFertilityWindow => 'Fertility window';

  @override
  String get calendarFertilityWindowDescription =>
      'This date is inside the predicted fertile window.';

  @override
  String get calendarPmsDay => 'PMS day';

  @override
  String get calendarPmsDayDescription =>
      'This date is in the predicted PMS phase.';

  @override
  String get calendarSelectedDay => 'Selected day.';

  @override
  String get calendarRegularDay => 'Regular day';

  @override
  String get calendarNoTrackedCycleEvent =>
      'No tracked cycle event is attached to this date.';

  @override
  String get calendarMonthlyOverview => 'Monthly overview';

  @override
  String get calendarMonthlyOverviewHelp =>
      'Review your cycle over time. Use quick log for daily updates and Edit Calendar for corrections.';

  @override
  String get calendarQuickCapture => 'Quick capture';

  @override
  String get calendarQuickCaptureHelp =>
      'Fast daily actions for periods and symptoms, without opening the structured editor.';

  @override
  String get calendarDateRangeHelp =>
      'Need to define or correct a date range? Use Edit Calendar.';

  @override
  String get calendarEditTitle => 'Edit Calendar';

  @override
  String get calendarStructuredEditTitle => 'Structured period edit';

  @override
  String get calendarStartDateSelected => 'Start date selected';

  @override
  String get calendarPeriodRangeReady => 'Period range ready';

  @override
  String get calendarSelectRangeInstruction =>
      'Use this screen to define or correct an exact period range.';

  @override
  String get calendarChooseLastDay => 'Choose the last day of this period.';

  @override
  String get calendarCorrectionHelp =>
      'This screen is for precise corrections. For quick daily updates, use Log Period from the calendar overview.';

  @override
  String get calendarSavedPeriod => 'Saved period';

  @override
  String get calendarPredictedPeriodLegend => 'Predicted period';

  @override
  String get calendarSaveStartDate => 'Save start date';

  @override
  String get calendarSavePeriodRange => 'Save period range';

  @override
  String get calendarLegendPmsDay => 'PMS day';

  @override
  String get calendarLegendLoggedPeriod => 'Logged period';

  @override
  String get calendarLegendPredictedPeriod => 'Predicted period';

  @override
  String get calendarLegendFertilityWindow => 'Fertile window';

  @override
  String get calendarLegendSymptoms => 'Symptoms';

  @override
  String get calendarLegendJournal => 'Journal';

  @override
  String get calendarLegendToday => 'Today';

  @override
  String get goalTrackPeriod => 'Track my period';

  @override
  String get goalUnderstandBody => 'Understand my body better';

  @override
  String get goalTrackOvulation => 'Track ovulation';

  @override
  String get goalHealthInsights => 'Get health insights';

  @override
  String get goalShareDoctor => 'Share data with my doctor';

  @override
  String get goalAiGuidance => 'AI-powered guidance';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get myGoal => 'My goal';

  @override
  String get noGoalsSelected => 'No goals selected';

  @override
  String get goalsSelected => 'Goals selected';

  @override
  String get helpSearchHint => 'Search anything…';

  @override
  String get helpContactUs => 'Contact us';

  @override
  String get helpFaqLogQuestion => 'How do I log my period and symptoms?';

  @override
  String get helpFaqLogAnswer =>
      'Open Cycle Calendar and use Log Period or Log Symptoms. You can use Edit Calendar to correct a date range.';

  @override
  String get helpFaqDataQuestion => 'Is my health data secure?';

  @override
  String get helpFaqDataAnswer =>
      'Journal entries stay on this device in encrypted storage by default; optional cloud sync requires separate consent. Profile, cycle, symptom, partner and settings data use Firebase. See the Privacy Policy for details and current deletion limits.';

  @override
  String get helpFaqPartnerQuestion => 'How does partner sharing work?';

  @override
  String get helpFaqPartnerAnswer =>
      'This version stores the partner email address and sharing preferences in your Firebase account. It does not yet send an invitation or transfer cycle or symptom records to a partner.';

  @override
  String get helpFaqNotificationsQuestion =>
      'How can I customize notifications?';

  @override
  String get helpFaqNotificationsAnswer =>
      'Open Profile, then Settings and Notifications to choose which local reminders are enabled.';

  @override
  String get helpFaqDeleteQuestion => 'How do I delete my account or data?';

  @override
  String get helpFaqDeleteAnswer =>
      'You can clear local data under Profile > Account Security and delete an optional journal cloud copy under Settings > Journal Sync. This version does not yet provide in-app deletion of the Firebase account and all other cloud records. The publisher must provide a verified privacy contact before public release.';

  @override
  String get helpFaqSupportQuestion => 'How can I contact support?';

  @override
  String get helpFaqSupportAnswer =>
      'Use the contact options at the bottom of this page.';

  @override
  String get securityIncorrectPin => 'Incorrect PIN.';

  @override
  String get securityAuthenticationSuccess => 'Authentication successful';

  @override
  String get securityPinRequired => 'PIN required';

  @override
  String get securityAuthenticationError => 'Authentication failed. Try again.';

  @override
  String get securitySkipDevelopmentOnly => 'Skip (development only)';

  @override
  String get securityRetry => 'Retry';

  @override
  String securityLockedFor(int minutes, int seconds) {
    return 'Locked for ${minutes}m ${seconds}s';
  }

  @override
  String get journalNoEntryForDay => 'No entry for this day';

  @override
  String get journalQuickLogPrompt => 'Use Quick Log to capture this moment.';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodExcited => 'Excited';

  @override
  String get moodAnxious => 'Anxious';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodTired => 'Tired';

  @override
  String get journalDeleteMemoryTitle => 'Delete this memory?';

  @override
  String get journalDeleteMemoryBody =>
      'This action is permanent and cannot be undone.';

  @override
  String get journalTimeline => 'Timeline';

  @override
  String get journalSearchAllMoods => 'All moods';

  @override
  String get journalFavorites => 'Favorites';

  @override
  String get journalDateFilter => 'Date';

  @override
  String get journalSearchNoResults => 'No results found';

  @override
  String get journalFilterByMood => 'Filter by mood';

  @override
  String get journalAllFilter => 'All';

  @override
  String get journalCurrentStreak => 'Current streak';

  @override
  String get journalMoodDistribution => 'Mood distribution';

  @override
  String get journalWeeklyActivity => 'Weekly activity';

  @override
  String get journalTopTags => 'Top tags';

  @override
  String get journalInsightsNotEnoughData =>
      'Not enough data for insights yet 🌿';

  @override
  String get journalQuickThought => 'Quick thought';

  @override
  String get journalWrite => 'Write';

  @override
  String get journalQuickThoughtHint => 'What\'s on your mind?';

  @override
  String get journalCaptureMoment => 'Tap to capture a quick moment...';

  @override
  String get journalQuickThoughtSaved => 'Quick thought saved 😌';

  @override
  String get journalStreak => 'Streak';

  @override
  String get journalInsights => 'Insights';

  @override
  String get journalWeekly => 'Weekly';

  @override
  String get journalRecentEntries => 'Recent entries';

  @override
  String get journalSeeAll => 'See all';

  @override
  String get journalNoEntriesYet => 'No entries yet';

  @override
  String get journalPhotoGallery => 'Choose from gallery';

  @override
  String get journalTakePhoto => 'Take a photo';

  @override
  String get journalImageAdded => 'Image added to your journal.';

  @override
  String get journalAudioComingSoon =>
      'Audio recording will be available soon.';

  @override
  String get journalMoodQuestion => 'How are you feeling?';

  @override
  String journalNoteCount(int count) {
    return '$count notes';
  }

  @override
  String journalStreakCount(int count) {
    return '$count days';
  }

  @override
  String get selectDateRange => 'Select a date range';

  @override
  String get journalEditAction => 'Edit';

  @override
  String get journalQuietMoment => 'A quiet moment';

  @override
  String get journalLockedTitle => 'Journal is locked';

  @override
  String get journalLockedDescription =>
      'Enter your PIN or use biometrics to access your private notes.';

  @override
  String get journalUseBiometrics => 'Use biometrics';

  @override
  String get journalUnlockReason => 'Unlock your private journal';

  @override
  String get securityBiometricFailed =>
      'Biometric authentication failed. Try again or enter your PIN.';

  @override
  String get journalSaveError =>
      'Could not save your journal entry. Please try again.';

  @override
  String get journalDailyQuote => '“Every moment is a fresh beginning.”';

  @override
  String educationReadingTime(int minutes) {
    return 'about $minutes min read';
  }

  @override
  String get selfCarePrompt => 'What do you want to learn today?';

  @override
  String get selfCareFilterAll => 'All';

  @override
  String get selfCareFilterCramps => 'Cramps relief';

  @override
  String get selfCareFilterStrength => 'Strength and flexibility';

  @override
  String get selfCareFilterFacial => 'Facial care';

  @override
  String get selfCareCategoryCramps => 'Gentle movement for cramps';

  @override
  String get selfCareCategoryStrength => 'Strength and flexibility';

  @override
  String get selfCareCategoryFacial => 'Facial care';

  @override
  String get selfCareCategoryStretching => 'Relaxing stretches';

  @override
  String get selfCareCategoryArticles => 'Articles';

  @override
  String get selfCareBadgeGetStarted => 'Get started';

  @override
  String get selfCareCardBalance => 'Balance';

  @override
  String get selfCareCardFocus => 'Focus';

  @override
  String get selfCareCardStrength => 'Strength';

  @override
  String get selfCareCardFlexibility => 'Flexibility';

  @override
  String get selfCareCardGentleFacialMassage => 'Gentle facial massage';

  @override
  String get selfCareCardGlowSkin => 'Glow up your skin';

  @override
  String get selfCareCardNeckPainRelief => 'Neck pain relief';

  @override
  String get selfCareCardLowerBackStretch => 'Lower back stretch';

  @override
  String get selfCareCardPeriodPainRelief => 'Period pain relief';

  @override
  String get selfCareSubtitleGentleYoga => 'Gentle yoga to ease tension';

  @override
  String get selfCareSubtitleBreathingRelease => 'Breathing and slow release';

  @override
  String get selfCareSubtitleMobilityComfort => 'Mobility for everyday comfort';

  @override
  String get selfCareSubtitleLiftSculpt => 'Lift and sculpt softly';

  @override
  String get selfCareSubtitleCleanseHydrate => 'Cleanse and hydrate';

  @override
  String get selfCareSubtitleReleaseUpperBody => 'Release upper-body tension';

  @override
  String get selfCareSubtitleSlowRestorative => 'Slow restorative motion';

  @override
  String selfCareLowImpactExercises(int count) {
    return '$count low-impact exercises';
  }

  @override
  String selfCareMinutesRead(int minutes) {
    return '$minutes min read';
  }

  @override
  String get selfCareDeepSleepMeditation => 'Deep sleep meditation';

  @override
  String get selfCarePlay => 'Play';

  @override
  String get selfCareNeedYogaPillow => 'Yoga pillow';

  @override
  String get selfCareNeedWaterBottle => 'Water bottle';

  @override
  String get selfCareNeedYogaMat => 'Yoga mat';

  @override
  String get selfCareStepChinToChest => 'Chin to chest';

  @override
  String get selfCareStepReclineReset => 'Recline reset';

  @override
  String get selfCareStepSupportedPigeon => 'Supported pigeon';

  @override
  String get selfCareStepButterflyFold => 'Butterfly fold';

  @override
  String get selfCareStepLotusLift => 'Lotus lift';

  @override
  String get selfCareStepLegsUpWall => 'Legs up the wall';

  @override
  String get selfCareStepNeckLift => 'Neck lift';

  @override
  String get selfCareStepGuaShaMassage => 'Gua sha massage';

  @override
  String get selfCareStepFacialCleansing => 'Facial cleansing';

  @override
  String get selfCareStepGlowPress => 'Glow press';

  @override
  String get selfCareStepHydrationLock => 'Hydration lock';

  @override
  String get selfCareSubtitleChinUpward => 'Chin upward';

  @override
  String get selfCareSubtitleSweepOutward => 'Sweep outward gently';

  @override
  String get selfCareSubtitleGentlyCleanse => 'Gently cleanse face';

  @override
  String get selfCareSubtitleLightCircular => 'Light circular motion';

  @override
  String get selfCareSubtitleSealMoisture => 'Seal in moisture';

  @override
  String get selfCareSleepTrackCalmFlow => 'Calm Flow';

  @override
  String get selfCareSleepTrackBreathOfLife => 'Breath of Life';

  @override
  String get selfCareSleepTrackSoulDrift => 'Soul Drift';

  @override
  String get selfCareSleepTrackSoundsSerenity => 'Sounds of Serenity';

  @override
  String get selfCareSleepTrackInnerPeace => 'Inner Peace';

  @override
  String get selfCareSleepTrackMindfulJourney => 'Mindful Journey';

  @override
  String get selfCareSleepTrackWhisperingNature => 'Whispering Nature';

  @override
  String get selfCareSleepTrackNaturesRhythm => 'Nature\'s Rhythm';

  @override
  String get selfCareSleepTrackGoldenDawn => 'Golden Dawn';

  @override
  String get selfCareSleepTrackHarmonyWithin => 'Harmony Within';

  @override
  String get selfCareSleepTrackBreatheInSilence => 'Breathe in Silence';

  @override
  String get selfCareSleepTrackDeepRestSession => 'Deep Rest Session';

  @override
  String get selfCareAlignMindBody => 'Align mind and body';

  @override
  String get selfCareActivityDescription =>
      'Optional, gentle pillow-supported movements. Comfort and response vary from person to person.';

  @override
  String get selfCareYouWillNeed => 'You\'ll need';

  @override
  String get selfCareStart => 'Let\'s start';

  @override
  String get selfCareExerciseJumpingJacks => 'Jumping jacks';

  @override
  String get selfCareFullBodyCardio => 'Full-body cardio';

  @override
  String get selfCareWait => 'Wait!';

  @override
  String get selfCareQuit => 'Quit';

  @override
  String get selfCareKeepGoing => 'Keep going';

  @override
  String get selfCareStartExercises => 'Start exercises';

  @override
  String get selfCareGentleMovementTitle => 'Gentle movement';

  @override
  String get selfCareGentleMovementDescription =>
      'Optional gentle movements may help some people feel more comfortable. Stop if pain increases or you feel dizzy or unwell.';

  @override
  String get selfCareCongratulations => 'Congratulations!';

  @override
  String get selfCareCongratulationsMessage =>
      'You completed your self-care session and took time for your body today.';

  @override
  String get selfCareBackHome => 'Back to home';

  @override
  String selfCareArticleReadTime(int minutes) {
    return '$minutes min read';
  }

  @override
  String get selfCareArticleTitle =>
      'Period pain: gentle options and when to seek help';

  @override
  String get selfCareArticleLead =>
      'Cramping is common, but severe, changing, or disruptive pain deserves attention.';

  @override
  String get selfCareArticleComfortHeading => 'Gentle comfort options:';

  @override
  String get selfCareArticleWarmCompress =>
      'A warm compress or gentle movement may help some people.';

  @override
  String get selfCareArticleRest =>
      'Rest if you need it; stop an activity if pain or dizziness increases.';

  @override
  String get selfCareArticleVaries =>
      'What helps varies from person to person.';

  @override
  String get selfCareArticleMedicineHeading => 'About medicines:';

  @override
  String get selfCareArticleMedicineRisks =>
      'Pain medicines are not suitable for everyone and can have risks or interactions.';

  @override
  String get selfCareArticlePharmacist =>
      'Ask a pharmacist or qualified health professional what is appropriate for you.';

  @override
  String get selfCareArticleFollowLabel =>
      'Follow the product label. This article does not recommend a medicine or dose.';

  @override
  String get selfCareArticleSeekHelpHeading => 'When to get help:';

  @override
  String get selfCareArticleDailyLife =>
      'Arrange a health visit if pain repeatedly disrupts school, work, sleep, or daily activities.';

  @override
  String get selfCareArticleUrgent =>
      'Seek urgent care for sudden severe pain, fainting, fever, or pain with bleeding when pregnancy is possible.';

  @override
  String get selfCareArticleEncouragement =>
      'You deserve care. Pain that disrupts daily life should be taken seriously.';

  @override
  String get selfCareAddComment => 'Add comment';

  @override
  String get selfCareFeedbackThanks => 'Thanks for your feedback!';

  @override
  String get selfCareFeedbackReceived =>
      'Feedback received. We\'ll do our best to bring you a better user experience.';

  @override
  String get selfCareOk => 'OK';

  @override
  String get selfCareSleepMeditationTitle => 'Sleep meditation';

  @override
  String get selfCareRelax => 'Relax';

  @override
  String get selfCarePeaceRelaxation => 'Peace and relaxation';

  @override
  String get selfCareTimes => 'times';

  @override
  String get selfCarePrevious => 'Previous';

  @override
  String get selfCareNext => 'Next';

  @override
  String selfCareMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String selfCareRound(int round) {
    return 'Round $round';
  }

  @override
  String selfCareOnlyMinutesLeft(int minutes) {
    return 'Only $minutes minutes left — keep it up!';
  }

  @override
  String get cyclePhasePeriod => 'Period';

  @override
  String get cyclePhaseLuteal => 'Luteal phase';

  @override
  String get cyclePhaseOvulation => 'Ovulation';

  @override
  String get cyclePhaseFollicular => 'Follicular phase';

  @override
  String get authPasswordResetSuccess => 'Password reset successful';

  @override
  String get authPasswordResetSuccessMessage =>
      'Your password has been updated. You can now log in with your new password.';

  @override
  String get aiChatCheckingIn => 'Hey, just checking in.';

  @override
  String get aiChatPmsQuestion =>
      'How are you feeling around your PMS days lately?';

  @override
  String get aiChatCrampsOrAches => 'Cramps or body aches';

  @override
  String get aiChatPhaseVariation =>
      'Got it. Everyone feels this phase a little differently.';

  @override
  String get aiChatFocusQuestion =>
      'Do you usually have trouble focusing or getting things done these days?';

  @override
  String get aiChatYesALot => 'Yes, a lot';

  @override
  String get aiChatGentleSuggestions =>
      'Here are a few gentle ways to stay balanced';

  @override
  String get aiSuggestionDrinkWater => 'Drink water';

  @override
  String get aiSuggestionMoveGently => 'Move gently';

  @override
  String get aiSuggestionTakePause => 'Take a pause';

  @override
  String get aiChatLearnMore =>
      'Would you like to learn a little more about this?';

  @override
  String get aiChatImCurious => 'Yes, I\'m curious';

  @override
  String get aiChatArticlePrompt => 'Here\'s an article you can read.';

  @override
  String get aiChatIReadIt => 'I read it';

  @override
  String get aiChatSymptomsPrompt =>
      'I\'ve preselected your symptoms. Are these correct, or would you like to add others?';

  @override
  String get aiChatSymptomsConfirmed => 'Yes, that works!';

  @override
  String get aiChatSetSymptomsTitle => 'Your symptoms are all set';

  @override
  String get aiChatOpenSymptoms => 'Open symptoms';

  @override
  String get aiChatArticleTitle => 'Never-ending cramps';

  @override
  String get aiChatArticleSubtitle => 'When period pain isn\'t typical.';

  @override
  String get aiChatArticleDescription =>
      'Learn why cramps can linger and when to seek help. Find gentle options that may ease discomfort.';

  @override
  String get aiChatReadNow => 'Read now';

  @override
  String get aiChatAfterPmsSupport =>
      'We know it\'s not easy to get through days like this. You\'re not alone.';

  @override
  String get aiChatCalendarPmsDoctor =>
      'Your calendar shows PMS days from the 13th to the 17th, and a doctor\'s appointment on the 18th.';

  @override
  String get aiChatSuggestDate =>
      'I suggest the 19th instead. How does that sound?';

  @override
  String get aiChatAssistantLabel => 'Your assistant';

  @override
  String get aiChatPmsConflict => 'PMS day conflict';

  @override
  String get aiChatDoctorVisitConflict => 'Doctor visit conflict';

  @override
  String get aiChatAskAnything => 'Ask anything...';

  @override
  String get appointmentConfirmed => 'Appointment confirmed!';

  @override
  String appointmentBooked(String doctor) {
    return 'Your appointment with Dr. $doctor is booked.';
  }

  @override
  String appointmentReviewCount(int count) {
    return '$count reviews';
  }

  @override
  String get appointmentGynecologist => 'Gynecologist';

  @override
  String get appointmentGynOncologyFocus =>
      'Focus on gynecologic oncology screening';

  @override
  String get appointmentVideoConsultation => 'Video consultation';

  @override
  String get appointmentDoneBackToChat => 'Done, back to chat';

  @override
  String get aiChatSymptomCramps => 'Cramps';

  @override
  String get aiChatSymptomHeadache => 'Headache';

  @override
  String get periodLogSheetTitle => 'Log your period';

  @override
  String get periodLogSheetSubtitle =>
      'Choose the period update that best describes today.';

  @override
  String minimumAgeMessage(int age) {
    return 'Peria is for people aged $age and older.';
  }

  @override
  String get ageRestrictedTitle => 'Age requirement';

  @override
  String ageRestrictedBody(int age) {
    return 'Peria isn\'t available under $age. Update your date of birth to continue.';
  }

  @override
  String get updateDateOfBirth => 'Update date of birth';

  @override
  String get pressBackAgainToExit => 'Press back again to leave';

  @override
  String get symptomLogUnavailable =>
      'Saved symptoms couldn\'t be loaded. You can still log this day.';
}
