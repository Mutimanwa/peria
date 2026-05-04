import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peria_app/core/theme/theme.dart';

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
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnimation;
  bool _isObscured = true;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());

    // Add listeners to focus hubs for backspace detection
    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus &&
            i > 0 &&
            _controllers[i - 1].text.isEmpty) {
          // Prevent skipping empty fields forward manually
        }
      });
    }

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
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isEmpty) return;

    if (value.length > 1) {
      value = value[value.length - 1];
      _controllers[index].text = value;
    }

    _updatePin();

    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (_pin.length == widget.length) {
      widget.onCompleted(_pin);
    }
  }

  void _updatePin() {
    _pin = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_pin);
  }

  void _handleKeyPress(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controllers[index].text.isEmpty && index > 0) {
        _controllers[index - 1].clear();
        _focusNodes[index - 1].requestFocus();
        _updatePin();
      }
    }
  }

  Future<void> _shake() async {
    await _shakeController.forward().then((_) => _shakeController.reset());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      _shake();
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: _shakeAnimation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.length, (index) {
                      return Row(
                        children: [
                          _buildPinCell(index),
                          if (index < widget.length - 1)
                            const SizedBox(width: 14),
                        ],
                      );
                    }),
                  ),
                );
              },
            ),
            if (widget.showVisibilityToggle)
              Positioned(
                right: 0,
                child: IconButton(
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
            style: AppText.caption.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildPinCell(int index) {
    final isFocused = _focusNodes[index].hasFocus;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFocused
              ? AppColors.primary500
              : (widget.error != null ? AppColors.error : Colors.transparent),
          width: 1.5,
        ),
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(), // Dummy to intercept backspace
        onKey: (event) => _handleKeyPress(event, index),
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          obscureText: _isObscured,
          obscuringCharacter: '●',
          style: AppText.h4.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.grey900,
          ),
          maxLength: 1,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _onChanged(index, value),
        ),
      ),
    );
  }
}
