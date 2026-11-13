import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/auth/data/account_cleanup.dart';
import 'package:peria_app/features/auth/presentation/auth_error_text.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Asks for a final confirmation, then deletes the account for good.
///
/// Returns true only when the account really was deleted.
Future<bool> showDeleteAccountDialog(BuildContext context) async {
  final deleted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _DeleteAccountDialog(),
  );
  return deleted == true;
}

class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog();

  @override
  ConsumerState<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  final _passwordController = TextEditingController();

  bool _deleting = false;
  String? _error;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final needsPassword =
        user != null && !user.isAnonymous && (user.email?.isNotEmpty ?? false);

    if (needsPassword && _passwordController.text.isEmpty) {
      setState(() => _error = l10n.deleteAccountPasswordLabel);
      return;
    }

    setState(() {
      _deleting = true;
      _error = null;
    });

    try {
      await ref.read(authRepositoryProvider).deleteAccount(
            password: needsPassword ? _passwordController.text : null,
          );
      await clearLocalAccountData();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _deleting = false;
        _error = authErrorText(l10n, authErrorCodeFrom(error));
        if (_error == l10n.authErrorUnknown) {
          _error = l10n.deleteAccountFailed;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = FirebaseAuth.instance.currentUser;
    final needsPassword =
        user != null && !user.isAnonymous && (user.email?.isNotEmpty ?? false);

    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(
        l10n.deleteAccountTitle,
        style: AppText.h5.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.deleteAccountMessage,
            style: AppText.body.copyWith(color: AppColors.textSecondary, height: 1.45),
          ),
          if (needsPassword) ...[
            const SizedBox(height: 16),
            Text(l10n.deleteAccountPasswordLabel, style: AppText.label),
            const SizedBox(height: 8),
            PillTextField(
              hint: l10n.enterYourPasswordHint,
              obscure: true,
              controller: _passwordController,
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: AppText.caption.copyWith(color: AppColors.textError),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.of(context).pop(false),
          child: Text(
            l10n.cancel,
            style: AppText.label.copyWith(color: AppColors.grey700),
          ),
        ),
        TextButton(
          onPressed: _deleting ? null : _delete,
          child: Text(
            l10n.deleteAccountConfirm,
            style: AppText.label.copyWith(
              color: AppColors.textError,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
