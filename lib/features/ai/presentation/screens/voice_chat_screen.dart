import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';

class VoiceChatScreen extends StatelessWidget {
  const VoiceChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF2EAFE),
              Color(0xFFFFFFFF),
              Color(0xFFFFEEF3),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: -32,
                right: -32,
                bottom: -12,
                child: Container(
                  height: 168,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7DAFB),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 196,
                      height: 196,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7D5FB),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 162,
                      height: 162,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC798F0),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD5B2F4).withOpacity(.45),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.graphic_eq_rounded, color: AppColors.white, size: 62),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 44,
                right: 44,
                bottom: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleAction(
                      icon: Icons.close_rounded,
                      onTap: () => context.pop(),
                    ),
                    _CircleAction(
                      icon: Icons.mic_none_rounded,
                      onTap: () => context.go('/ai'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: const BoxDecoration(
          color: AppColors.grey900,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white),
      ),
    );
  }
}
