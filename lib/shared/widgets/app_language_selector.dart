import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/theme.dart';

/// Two-language switch styled for both onboarding and Settings.
class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({
    super.key,
    required this.currentLanguageCode,
    required this.englishLabel,
    required this.frenchLabel,
    required this.onSelected,
    this.compact = false,
  });

  final String currentLanguageCode;
  final String englishLabel;
  final String frenchLabel;
  final ValueChanged<String> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 4 : 6),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(compact ? 16 : 22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LanguageChoice(
            languageCode: 'en',
            label: compact ? 'EN' : englishLabel,
            semanticLabel: englishLabel,
            selected: currentLanguageCode == 'en',
            compact: compact,
            onTap: onSelected,
          ),
          SizedBox(width: compact ? 2 : 6),
          _LanguageChoice(
            languageCode: 'fr',
            label: compact ? 'FR' : frenchLabel,
            semanticLabel: frenchLabel,
            selected: currentLanguageCode == 'fr',
            compact: compact,
            onTap: onSelected,
          ),
        ],
      ),
    );
  }
}

class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice({
    required this.languageCode,
    required this.label,
    required this.semanticLabel,
    required this.selected,
    required this.compact,
    required this.onTap,
  });

  final String languageCode;
  final String label;
  final String semanticLabel;
  final bool selected;
  final bool compact;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(compact ? 12 : 18),
        child: InkWell(
          borderRadius: BorderRadius.circular(compact ? 12 : 18),
          onTap: () => onTap(languageCode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            constraints: BoxConstraints(
              minWidth: compact ? 44 : 76,
              minHeight: 44,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 12,
              vertical: compact ? 8 : 14,
            ),
            decoration: BoxDecoration(
              color: selected ? AppColors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(compact ? 12 : 18),
              border: Border.all(
                color: selected ? AppColors.primary300 : Colors.transparent,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: AppText.label.copyWith(
                color: selected ? AppColors.primary700 : AppColors.grey700,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: compact ? 12 : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
