import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';

/// Saisie d'un code PIN.
///
/// Un seul [TextField] invisible porte la saisie, et les cases ne sont que
/// décoratives. Avec un vrai champ par chiffre, les frappes rapides se
/// perdaient pendant le transfert de focus : le code restait incomplet,
/// [onCompleted] n'était jamais appelé et le verrou semblait ne rien valider.
class PinCodeInput extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final String? error;
  final bool autoFocus;
  final int length;
  final bool obscureText;
  final bool showVisibilityToggle;

  const PinCodeInput({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.error,
    this.autoFocus = true,
    this.length = 4,
    this.obscureText = true,
    this.showVisibilityToggle = true,
  });

  @override
  State<PinCodeInput> createState() => _PinCodeInputState();
}

class _PinCodeInputState extends State<PinCodeInput>
    with SingleTickerProviderStateMixin {
  static const double _cellSize = 52;
  static const double _cellGap = 14;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late final AnimationController _shakeController;
  late final Animation<Offset> _shakeAnimation;
  late bool _isObscured;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<Offset>(
      begin: const Offset(-15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticOut,
    ));

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }

    // Le parent reconstruit la saisie apres un echec : on rejoue la secousse
    // pour que le refus soit visible.
    if (widget.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _shake();
      });
    }
  }

  @override
  void didUpdateWidget(covariant PinCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Un code refusé doit vider les cases, sinon la personne ne peut plus rien
    // retaper sans les effacer une par une.
    if (widget.error != null && widget.error != oldWidget.error) {
      _clear();
      _shake();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    if (_pin.isEmpty) return;
    setState(() => _pin = '');
    // Le vidage part d'un didUpdateWidget, donc pendant la construction :
    // notifier le parent ici lui ferait appeler setState en pleine phase de
    // build (assertion « setState() called during build »). On le notifie
    // apres la frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChanged?.call('');
    });
    if (mounted) _focusNode.requestFocus();
  }

  void _onChanged(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final value = digits.length > widget.length
        ? digits.substring(0, widget.length)
        : digits;

    if (value != raw) {
      _controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }

    setState(() => _pin = value);
    widget.onChanged?.call(value);

    if (value.length == widget.length) {
      widget.onCompleted(value);
    }
  }

  Future<void> _shake() async {
    if (!mounted) return;
    await _shakeController.forward();
    if (mounted) _shakeController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cellsWidth =
        widget.length * _cellSize + (widget.length - 1) * _cellGap;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: widget.showVisibilityToggle ? 44 : 0,
              ),
              child: SizedBox(
                width: cellsWidth,
                height: _cellSize,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Le seul champ qui reçoit les frappes ; il est invisible.
                    Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        showCursor: false,
                        enableInteractiveSelection: false,
                        autocorrect: false,
                        enableSuggestions: false,
                        maxLength: widget.length,
                        style: const TextStyle(color: Colors.transparent),
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: _onChanged,
                      ),
                    ),
                    IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _shakeAnimation,
                        builder: (context, child) => Transform.translate(
                          offset: _shakeAnimation.value,
                          child: child,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var index = 0;
                                index < widget.length;
                                index++) ...[
                              if (index > 0)
                                const SizedBox(width: _cellGap),
                              _buildPinCell(index),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showVisibilityToggle)
              Positioned(
                right: 0,
                child: IconButton(
                  tooltip:
                      _isObscured ? l10n.hidePassword : l10n.showPassword,
                  icon: Icon(
                    _isObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.grey400,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                ),
              ),
          ],
        ),
        if (widget.error != null && widget.error!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            widget.error!,
            textAlign: TextAlign.center,
            style: AppText.caption.copyWith(color: AppColors.textError),
          ),
        ],
      ],
    );
  }

  Widget _buildPinCell(int index) {
    final isFilled = index < _pin.length;
    final isCurrent = index == _pin.length;

    final Color borderColor;
    if (widget.error != null) {
      borderColor = AppColors.error;
    } else if (isCurrent) {
      borderColor = AppColors.primary500;
    } else {
      borderColor = Colors.transparent;
    }

    return Container(
      width: _cellSize,
      height: _cellSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        isFilled ? (_isObscured ? '●' : _pin[index]) : '',
        style: AppText.h4.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
      ),
    );
  }
}
