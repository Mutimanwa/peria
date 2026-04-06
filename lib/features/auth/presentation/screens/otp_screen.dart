import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

/// ═══════════════════════════════════════════════════════════════════
///  ÉCRAN 5 — OTP Verification
///  Maquettes : OTP_2x.png (vide) + OTP_Filled.png (avec dialog succès)
///
///  Structure :
///   • Bouton retour
///   • Illustration bouclier 3D rose/violet  ← ÉLÉMENT 3D À REMPLIR
///   • Titre "Enter verification code"
///   • Sous-titre avec email masqué
///   • 4 cases OTP (carrés arrondis)
///   • Lien "Didn't get the code? Resend in 45s"
///   • Bouton "Continue" (désactivé tant que 4 chiffres non saisis)
///   • Dialog succès (affiché quand code validé)
/// ═══════════════════════════════════════════════════════════════════
class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, this.email = 'sogandasari77@gmail.com'});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  int _resendSeconds = 45;
  Timer? _timer;
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(_checkComplete);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds <= 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  void _checkComplete() {
    final all = _controllers.every((c) => c.text.length == 1);
    setState(() => _canContinue = all);
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onBoxInput(String val, int index) {
    if (val.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (val.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode() {
    // TODO: appel API vérification OTP
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _SuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      showBack: true,
      showSkip: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          children: [
            // ── Illustration bouclier 3D ────────────────────────
            // ⚠️  ÉLÉMENT 3D À REMPLIR
            // Remplacer par : Image.asset('assets/images/shield_3d.png', height: 130)
            // L'image montre un bouclier rose/violet avec une coche en 3D
            Container(
              width: 150,
              height: 150,
              alignment: Alignment.center,
              child: Image.asset("assets/images/icons/security.png")
            ),
            const SizedBox(height: 32),

            // ── Titre ───────────────────────────────────────────
            const Text('Enter verification code',
                style: AppText.h1, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: AppText.body,
                children: [
                  const TextSpan(text: "We've sent a 4-digit code to :\n"),
                  TextSpan(
                      text: widget.email,
                      style: AppText.body.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.black)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ── 4 cases OTP ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  4,
                  (i) => _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        onChanged: (v) => _onBoxInput(v, i),
                      )),
            ),
            const SizedBox(height: 24),

            // ── Lien Resend ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't get the code? ", style: AppText.body),
                GestureDetector(
                  onTap: _resendSeconds == 0
                      ? () {
                          setState(() => _resendSeconds = 45);
                          _startTimer();
                          // TODO: renvoyer OTP
                        }
                      : null,
                  child: Text(
                    _resendSeconds > 0
                        ? 'Resend in ${_resendSeconds}s'
                        : 'Resend now',
                    style: AppText.body.copyWith(
                      color: _resendSeconds == 0
                          ? AppColors.primary
                          : AppColors.grey400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ── Bouton Continue ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: _canContinue ? _verifyCode : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Case OTP individuelle ────────────────────────────
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppText.h2,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
// ── Dialog Succès ────────────────────────────────────
class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône coche verte dans cercle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success, width: 2.5),
              ),
              child: const Icon(Icons.check_rounded,
                  color: AppColors.success, size: 36),
            ),
            const SizedBox(height: 20),

            const Text('Password Reset Successful',
                style: AppText.h3, textAlign: TextAlign.center),
            const SizedBox(height: 12),

            const Text(
              'Your password has been updated. You can now log in with your new password.',
              style: AppText.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Bouton Continue (noir, pill)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ferme dialog
                  context.go("/ask-name");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.grey900,
                  shape: const StadiumBorder(),
                ),
                child: const Text('Continue', style: AppText.btnPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
