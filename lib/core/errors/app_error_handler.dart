import 'package:flutter/material.dart';
import 'package:perla_app/core/errors/app_error.dart';

class AppErrorHandler {
  const AppErrorHandler._();

  static void showError(BuildContext context, AppError error) {
    debugPrint('[AppErrorHandler] showError $error');
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint('[AppErrorHandler] no ScaffoldMessenger available');
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(error.message),
        ),
      );
  }

  static void showSuccess(BuildContext context, String message) {
    debugPrint('[AppErrorHandler] showSuccess message=$message');
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint('[AppErrorHandler] no ScaffoldMessenger available');
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  static void showRetry(
    BuildContext context,
    AppError error, {
    required VoidCallback retry,
    String retryLabel = 'Retry',
  }) {
    debugPrint('[AppErrorHandler] showRetry $error');
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint('[AppErrorHandler] no ScaffoldMessenger available');
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(error.message),
          action: SnackBarAction(
            label: retryLabel,
            onPressed: retry,
          ),
        ),
      );
  }
}
