import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';

class VoiceChatScreen extends StatelessWidget {
  const VoiceChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD5B2F4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD5B2F4).withOpacity(.45),
                        blurRadius: 0,
                        spreadRadius: 18,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.graphic_eq_rounded, color: AppColors.white, size: 62),
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
