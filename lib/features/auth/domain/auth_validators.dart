class AuthValidators {
  AuthValidators._();

  static bool isEmailValid(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    // Simple MVP validation; backend will enforce full rules later.
    return v.contains('@') && v.contains('.') && !v.contains(' ');
  }

  /// Firebase accepts six characters; Peria asks for eight so a stolen
  /// password is not trivially brute-forced.
  static const int minimumPasswordLength = 8;

  static bool isPasswordValid(String value) {
    return value.trim().length >= minimumPasswordLength;
  }
}
