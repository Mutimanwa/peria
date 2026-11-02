import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

enum NavItem { cycle, journal, education }

class CustomBottomNav extends StatelessWidget {
  final NavItem currentIndex;
  final ValueChanged<NavItem> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <({NavItem item, String label, IconData? icon, bool cycle})>[
      (item: NavItem.cycle, label: l10n.navCycle, icon: null, cycle: true),
      (
        item: NavItem.education,
        label: l10n.navEducation,
        icon: Icons.school_rounded,
        cycle: false,
      ),
      (
        item: NavItem.journal,
        label: l10n.navJournal,
        icon: Icons.menu_book_rounded,
        cycle: false,
      ),
    ];

    return Material(
      color: AppColors.white,
      elevation: 12,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (final item in items)
                Expanded(
                  child: _NavItemWidget(
                    label: item.label,
                    icon: item.icon,
                    useCycleIcon: item.cycle,
                    isActive: currentIndex == item.item,
                    onTap: () => onTap(item.item),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool useCycleIcon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.label,
    required this.icon,
    required this.useCycleIcon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = isActive ? AppColors.white : AppColors.neutral900;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.neutral900 : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIcon(foreground),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    if (useCycleIcon) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CustomPaint(painter: _CycleIconPainter(color: color)),
      );
    }
    return Icon(icon, color: color, size: 22);
  }
}

class _CycleIconPainter extends CustomPainter {
  final Color color;

  _CycleIconPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 1.5;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -math.pi * 0.9,
      math.pi * 1.7,
      false,
      paint,
    );
    final arrowX = cx + r * math.cos(-math.pi * 0.9);
    final arrowY = cy + r * math.sin(-math.pi * 0.9);
    canvas.drawLine(Offset(arrowX - 3, arrowY + 5), Offset(arrowX, arrowY), paint);
    canvas.drawLine(Offset(arrowX + 4, arrowY + 3), Offset(arrowX, arrowY), paint);
  }

  @override
  bool shouldRepaint(covariant _CycleIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
