class AuthValidators {
  AuthValidators._();

  static bool isEmailValid(String value) {
    final v = value.trim();
    if (v.isEmpty) return false;
    // Simple MVP validation; backend will enforce full rules later.
    return v.contains('@') && v.contains('.') && !v.contains(' ');
  }

  static bool isPasswordValid(String value) {
    // MVP: just non-empty (UI can be improved later).
    return value.trim().isNotEmpty;
  }
}
