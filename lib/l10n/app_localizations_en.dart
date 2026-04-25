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
}
