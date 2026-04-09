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
}
