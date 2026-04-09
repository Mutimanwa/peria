import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum NavItem { cycle, ai, journal }

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
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(80, 0, 80, 20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(179),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white.withAlpha(128), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavItemWidget(
                  item: NavItem.cycle,
                  label: 'Cycle',
                  iconPainter: _CycleIconPainter(),
                  isActive: currentIndex == NavItem.cycle,
                  onTap: () => onTap(NavItem.cycle),
                ),
                _NavItemWidget(
                  item: NavItem.ai,
                  label: 'AI Chat',
                  iconPainter: _AiIconPainter(),
                  isActive: currentIndex == NavItem.ai,
                  onTap: () => onTap(NavItem.ai),
                ),
                _NavItemWidget(
                  item: NavItem.journal,
                  label: 'Journal',
                  icon: Icons.menu_book_outlined,
                  isActive: currentIndex == NavItem.journal,
                  onTap: () => onTap(NavItem.journal),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatelessWidget {
  final NavItem item;
  final String label;
  final CustomPainter? iconPainter;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemWidget({
    required this.item,
    required this.label,
    this.iconPainter,
    this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.neutral900,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIcon(Colors.white),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: _buildIcon(AppColors.neutral900),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    if (iconPainter != null) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CustomPaint(
          painter: _proxyPainter(iconPainter!, color),
        ),
      );
    }
    return Icon(icon, color: color, size: 24);
  }

  CustomPainter _proxyPainter(CustomPainter original, Color color) {
    if (original is _CycleIconPainter) return _CycleIconPainter(color: color);
    if (original is _AiIconPainter) return _AiIconPainter(color: color);
    return original;
  }
}

// ── Icons Painters (Internal to this widget) ───────────────────────────

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
    canvas.drawLine(
        Offset(arrowX - 3, arrowY + 5), Offset(arrowX, arrowY), paint);
    canvas.drawLine(
        Offset(arrowX + 4, arrowY + 3), Offset(arrowX, arrowY), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _AiIconPainter extends CustomPainter {
  final Color color;
  _AiIconPainter({this.color = Colors.black});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    final cx = size.width / 2 - 1.5;
    final cy = size.height / 2;
    final r = size.width * 0.36;
    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2),
      const Radius.circular(6),
    );
    canvas.drawRRect(rect, paint);
    canvas.drawCircle(
        Offset(cx - 3, cy - 1), 1.5, paint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(cx + 3, cy - 1), 1.5, paint);
    paint.style = PaintingStyle.stroke;
    canvas.drawArc(
        Rect.fromCenter(center: Offset(cx, cy + 1), width: 8, height: 4),
        0,
        math.pi,
        false,
        paint);
    final sx = cx + r + 1.5;
    final sy = cy - r - 1.5;
    canvas.drawLine(Offset(sx, sy - 3), Offset(sx, sy + 3), paint);
    canvas.drawLine(Offset(sx - 3, sy), Offset(sx + 3, sy), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
