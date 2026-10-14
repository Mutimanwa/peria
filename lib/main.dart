import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/router/router.dart';
import 'package:peria_app/core/services/local_notification_provider.dart';
import 'package:peria_app/core/services/local_notification_service.dart';
import 'package:peria_app/core/services/multitask_protection_service.dart';
import 'package:peria_app/core/services/security_service.dart';
import 'package:peria_app/core/storage/hive_setup.dart';
import 'package:peria_app/firebase_options.dart';
import 'package:peria_app/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await HiveSetup.init();
  await SecurityService.initialize();
  await MultitaskProtectionService.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService.instance.initialize();

  runApp(const ProviderScope(child: PeriaApp()));
}

class PeriaApp extends ConsumerWidget {
  const PeriaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(localNotificationScheduleProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFD587A),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      routerConfig: appRouter,
    );
  }
}
