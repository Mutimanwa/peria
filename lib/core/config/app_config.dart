enum AppEnvironment { dev, prod }

class AppConfig {
  AppConfig._();

  /// Current environment of the application.
  /// Toggle this to switch between dev and production APIs.
  static const AppEnvironment currentEnv = AppEnvironment.dev;

  // ─── URLs de base ──────────────────────────────────────────────────────────
  static const String baseUrlDev = 'https://api.dev.example.com';
  static const String baseUrlProd = 'https://api.example.com';

  /// Returns the base URL based on the current environment.
  static String get baseUrl =>
      currentEnv == AppEnvironment.dev ? baseUrlDev : baseUrlProd;
}
