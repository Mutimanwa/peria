class AppError {
  const AppError({
    required this.message,
    this.debugContext,
    this.code,
  });

  final String message;
  final String? debugContext;
  final String? code;

  @override
  String toString() {
    final buffer = StringBuffer('AppError(message: $message');
    if (code != null) {
      buffer.write(', code: $code');
    }
    if (debugContext != null) {
      buffer.write(', debugContext: $debugContext');
    }
    buffer.write(')');
    return buffer.toString();
  }
}
