import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/theme.dart';

/// Bouton pilule utilisé par les actions du cycle (plein ou contour).
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: filled ? AppColors.grey900 : AppColors.white,
          borderRadius: BorderRadius.circular(50),
          border:
              filled ? null : Border.all(color: AppColors.grey900, width: 1.5),
          boxShadow: filled
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: filled ? AppColors.white : AppColors.black,
          ),
        ),
      ),
    );
  }
}
