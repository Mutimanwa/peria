import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/auth/domain/auth_validators.dart';
import 'package:peria_app/features/auth/presentation/auth_error_text.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Lets the user request a real password-reset e-mail.
///
/// Returns true when the request was accepted by the backend.
Future<bool> showForgotPasswordSheet(
  BuildContext context, {
  String? initialEmail,
}) async {
  final sent = await showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.46),
    builder: (_) => _ForgotPasswordSheet(initialEmail: initialEmail),
  );
  return sent == true;
}

class _ForgotPasswordSheet extends ConsumerStatefulWidget {
  final String? initialEmail;

  const _ForgotPasswordSheet({this.initialEmail});

  @override
  ConsumerState<_ForgotPasswordSheet> createState() =>
      _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends ConsumerState<_ForgotPasswordSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialEmail ?? '');

  bool _sending = false;
  bool _sent = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final email = _controller.text.trim();
    if (!AuthValidators.isEmailValid(email)) {
      setState(() => _error = l10n.authErrorInvalidEmail);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      if (!mounted) return;
      setState(() {
        _sending = false;
        _sent = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = authErrorText(l10n, authErrorCodeFrom(error));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(l10n.forgotPasswordTitle, style: AppText.h4),
                const SizedBox(height: 8),
                Text(
                  _sent
                      ? l10n.forgotPasswordSentMessage(_controller.text.trim())
                      : l10n.forgotPasswordSubtitle,
                  style: AppText.body.copyWith(color: AppColors.grey600),
                ),
                if (!_sent) ...[
                  const SizedBox(height: 20),
                  Text(l10n.emailAddressLabel, style: AppText.label),
                  const SizedBox(height: 8),
                  PillTextField(
                    hint: l10n.yourEmailAddressHint,
                    controller: _controller,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: AppText.caption.copyWith(color: AppColors.error),
                    ),
                  ],
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: l10n.forgotPasswordSend,
                    onPressed: _sending ? null : _send,
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey900,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(l10n.ok, style: AppText.btnPrimary),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
