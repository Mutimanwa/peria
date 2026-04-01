class AppConfig{

  AppConfig._();

  // =========================================
  //  URLs de base par environnement
  // =========================================
  static const String baseUrlDev = 'https://api.dev.example.com';
  static const String baseUrlProd = 'https://api.example.com';

  // Environnement actuel (dev ou prod)
  static const _Env _currentEnv = _Env.dev;

}