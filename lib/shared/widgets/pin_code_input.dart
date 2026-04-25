import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/theme.dart';

class PinCodeInput extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final String? error;
  final bool autoFocus;
  final int length;
  final bool obscureText;

  const PinCodeInput({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.error,
    this.autoFocus = true,
    this.length = 4,
    this.obscureText = true,
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
  String _pin = '';

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<Offset>(
      begin: const Offset(-0.05, 0),
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
    if (value.length > 1) {
      // Paste support: take first char
      value = value[0];
      _controllers[index].text = value;
    }

    _pin = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(_pin);

    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (_pin.length == widget.length) {
      widget.onCompleted(_pin);
    }
  }

  // ignore: unused_element
  void _onBackspace(int index) {
    if (_pin.length == index + 1 && _controllers[index].text.isEmpty) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].clear();
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
        AnimatedBuilder(
            animation: _shakeAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: _shakeAnimation.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.length, (index) {
                  return GestureDetector(
                    onTap: () => _focusNodes[index].requestFocus(),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _focusNodes[index].hasFocus
                              ? AppColors.primary500
                              : AppColors.grey200,
                          width: _focusNodes[index].hasFocus ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                        maxLength: 1,
                        obscureText: widget.obscureText,
                        obscuringCharacter: '•',
                        decoration: const InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) => _onChanged(index, value),
                        onSubmitted: (_) {
                          if (_pin.length == widget.length) {
                            widget.onCompleted(_pin);
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
            );
          },
        ),

        if (widget.error != null) ...[
          const SizedBox(height: 12),
          Text(
            widget.error!,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 14,
            ),
          ),
        ],
      ],
    );
  }
}
