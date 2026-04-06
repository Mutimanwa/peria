import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/router/router.dart';

void main() {
  runApp(const ProviderScope(child: PeriaApp()));
}

class PeriaApp extends StatelessWidget {
  const PeriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Peria',
      debugShowCheckedModeBanner: false,
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
