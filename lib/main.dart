import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/router/router.dart';
import 'package:peria_app/core/services/app_locale_provider.dart';
import 'package:peria_app/core/services/local_notification_provider.dart';
import 'package:peria_app/core/services/local_notification_service.dart';
import 'package:peria_app/core/services/multitask_protection_service.dart';
import 'package:peria_app/core/services/onboarding_service.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/core/services/push_notification_service.dart';
import 'package:peria_app/core/services/push_registration_provider.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/core/storage/hive_setup.dart';
import 'package:peria_app/firebase_options.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/app_lock_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the local policy acknowledgement before the router or data providers run.
  await PrivacyPolicyConsentService().loadCurrentAcceptance();

  // Initialize core services
  await HiveSetup.init();
  await SecurityService.initialize();
  await MultitaskProtectionService.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Restore onboarding before the first redirect, otherwise every cold start
  // sends an already onboarded user back to the name screen.
  final onboardingCompleted = await OnboardingService.isOnboardingCompleted(
    uid: FirebaseAuth.instance.currentUser?.uid,
  );
  updateOnboardingState(onboardingCompleted);
  await LocalNotificationService.instance.initialize();

  // Push groundwork: the device is ready to receive server-sent reminders, but
  // nothing is registered until the user turns the switch on and signs in.
  PushNotificationService.instance.registerBackgroundHandler();
  await PushNotificationService.instance.initialize();

  // Tapping an OS reminder opens the screen it is about, whether Peria was
  // running or had to be launched from the notification.
  LocalNotificationService.instance.onNotificationTap = _openNotificationRoute;
  final launchRoute = await LocalNotificationService.instance.launchRoute();

  runApp(const ProviderScope(child: PeriaApp()));

  if (launchRoute != null) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _openNotificationRoute(launchRoute),
    );
  }
}

/// Pushes the destination of a tapped reminder once the router is ready.
void _openNotificationRoute(String route) {
  try {
    final current = appRouter.routerDelegate.currentConfiguration.uri.path;
    if (current == route) return;
    appRouter.push(route);
  } catch (error) {
    debugPrint('[main] could not open $route: $error');
  }
}

class PeriaApp extends ConsumerWidget {
  const PeriaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localNotificationScheduleProvider);
    ref.watch(pushRegistrationProvider);
    final locale = ref.watch(appLocaleProvider);
    return MaterialApp.router(
      locale: locale,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFD587A),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      routeInformationProvider: appRouter.routeInformationProvider,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      backButtonDispatcher: periaBackButtonDispatcher,
      builder: (context, child) =>
          AppLockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
