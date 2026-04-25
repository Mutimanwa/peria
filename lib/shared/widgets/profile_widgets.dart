import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';

class SectionLabel extends StatelessWidget {
  final String text;
  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text,
            style: AppText.caption
                .copyWith(color: AppColors.grey500, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel(this.text , {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child:
          Text(text, style: AppText.body.copyWith(fontWeight: FontWeight.w500)),
    );
  }
}

class InfoField extends StatelessWidget {
  final String text;
  final IconData? trailing;
  const InfoField({super.key, required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: AppText.body)),
          if (trailing != null)
            Icon(trailing, color: AppColors.grey500, size: 20),
        ],
      ),
    );
  }
}

class MenuItemData {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingText;
  final bool danger;

  MenuItemData(this.title, this.icon, this.onTap,
      {this.trailingText, this.danger = false}
    );
}

class MenuGroup extends StatelessWidget {
  final List<MenuItemData> items;
  const MenuGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: item.onTap,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          size: 16,
                          color: item.danger
                              ? const Color(0xFFFF6E6E)
                              : AppColors.grey700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppText.body.copyWith(
                            color: item.danger
                                ? const Color(0xFFFF6E6E)
                                : AppColors.grey800,
                          ),
                        ),
                      ),
                      if (item.trailingText != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            item.trailingText!,
                            style:
                                AppText.body.copyWith(color: AppColors.grey400),
                          ),
                        ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.grey400),
                    ],
                  ),
                ),
              ),
              if (index != items.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16 , color: AppColors.grey200,),
            ],
          );
        }),
      ),
    );
  }
}

class ToggleItemData {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  ToggleItemData(this.title, this.value, this.onChanged);
}

class ToggleGroup extends StatelessWidget {
  final List<ToggleItemData> items;
  const ToggleGroup({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.75),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_toggleIcon(item.title),
                          size: 14, color: AppColors.grey500),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item.title, style: AppText.body)),
                    Switch(
                      value: item.value,
                      onChanged: item.onChanged,
                      activeColor: AppColors.white,
                      activeTrackColor: const Color(0xFF4BE28C),
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.grey300,
                    ),
                  ],
                ),
              ),
              if (index != items.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  IconData _toggleIcon(String title) {
    if (title.contains('Cycle') || title.contains('Period')) return Icons.autorenew_rounded;
    if (title.contains('Logged') || title.contains('Log')) return Icons.add_circle_outline_rounded;
    if (title.contains('Mood')) return Icons.sentiment_satisfied_alt_outlined;
    if (title.contains('Face ID')) return Icons.fingerprint_rounded;
    if (title.contains('Two Factor')) return Icons.shield_outlined;
    if (title.contains('Partner')) return Icons.people_alt_outlined;
    if (title.contains('Ovulation')) return Icons.event_available_outlined;
    return Icons.radio_button_checked;
  }
}
