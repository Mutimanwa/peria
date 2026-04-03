import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime _selectedDate = DateTime.now();

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const List<String> _weekDays = ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su'];

  void _prevMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1);
      });

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDate = day;
    });
  }

  // Fonctions factices pour l'UI (Mock data)
  bool _isPeriodDay(DateTime day) {
    // Ex: Period days are 22 to 27
    return day.day >= 22 && day.day <= 27;
  }

  bool _isOvulationDay(DateTime day) {
    // Ex: Ovulation days are 4 to 8
    return day.day >= 4 && day.day <= 8;
  }

  bool _isPmsDay(DateTime day) {
    // Ex: PMS days are 16 to 20
    return day.day >= 16 && day.day <= 20;
  }

  bool _isToday(DateTime day) {
    final now = DateTime.now();
    return day.year == now.year && day.month == now.month && day.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final lastDay = DateTime(_displayMonth.year, _displayMonth.month + 1, 0);
    int startOffset = firstDay.weekday - 1;

    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: 'My Calendar',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 40), // Espace sous l'AppBar
          child: Column(
            children: [
              // ── Calendrier Card ────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Navigation mois
                      Row(
                        children: [
                          _NavArrow(onTap: _prevMonth, icon: Icons.chevron_left_rounded),
                          Expanded(
                            child: Text(
                              '${_monthNames[_displayMonth.month - 1]} ${_displayMonth.year}',
                              style: AppText.h4,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          _NavArrow(onTap: _nextMonth, icon: Icons.chevron_right_rounded),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // En-têtes jours
                      Row(
                        children: _weekDays
                            .map((d) => Expanded(
                                  child: Text(d,
                                      style: AppText.caption.copyWith(color: AppColors.grey400),
                                      textAlign: TextAlign.center),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      // Grille des jours
                      _buildCalendarGrid(firstDay, lastDay, startOffset),
                      const SizedBox(height: 16),

                      // Légende
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem('pms day', AppColors.warning50),
                          const SizedBox(width: 16),
                          _buildLegendItem('period day', AppColors.primary50),
                          const SizedBox(width: 16),
                          _buildLegendItem('ovulation day', AppColors.secondary100),
                        ],
                      ),
                      const SizedBox(height: 16),

                      PrimaryButton(
                        label: 'Edit Period',
                        onPressed: () {
                          context.push("/edit-calendar");
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Résumé des symptômes Card ────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.secondary50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How are you feeling today?', style: AppText.h4),
                      const SizedBox(height: 8),
                      Text(
                        'tell us more about your body to get analyze',
                        style: AppText.body.copyWith(color: AppColors.grey600),
                      ),
                      const SizedBox(height: 16),
                      OutlineButton(
                        label: '+ Add Symptom',
                        onPressed: () {
                          // Navigation à venir vers screen ajouter symptomes
                          context.go("/symptoms");
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Légende
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppText.caption),
      ],
    );
  }

  // Grille
  Widget _buildCalendarGrid(DateTime firstDay, DateTime lastDay, int startOffset) {
    final int totalDays = lastDay.day;
    final int totalCells = ((startOffset + totalDays) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: totalCells,
      itemBuilder: (ctx, i) {
        final dayNum = i - startOffset + 1;
        if (dayNum < 1 || dayNum > totalDays) {
          final nextDayNum = dayNum < 1 ? 0 : dayNum - totalDays;
          return Center(
            child: Text(
              dayNum < 1 ? '' : nextDayNum.toString(),
              style: AppText.caption.copyWith(color: AppColors.grey200),
            ),
          );
        }
        final day = DateTime(_displayMonth.year, _displayMonth.month, dayNum);
        
        bool isSelected = day.year == _selectedDate.year && day.month == _selectedDate.month && day.day == _selectedDate.day;

        return GestureDetector(
          onTap: () => _selectDay(day),
          child: _DayCell(
            day: day,
            isSelected: isSelected,
            isPeriod: _isPeriodDay(day),
            isOvulation: _isOvulationDay(day),
            isPms: _isPmsDay(day),
            isToday: _isToday(day),
          ),
        );
      },
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isPeriod;
  final bool isOvulation;
  final bool isPms;
  final bool isToday;

  const _DayCell({
    required this.day,
    required this.isSelected,
    this.isPeriod = false,
    this.isOvulation = false,
    this.isPms = false,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = AppColors.neutral900;

    if (isPeriod) {
      bgColor = AppColors.primary50;
      textColor = AppColors.primary400;
    } else if (isOvulation) {
      bgColor = AppColors.secondary100;
      textColor = AppColors.secondary500;
    } else if (isPms) {
      bgColor = AppColors.warning50;
      textColor = AppColors.warning700;
    }

    if (isSelected) {
      bgColor = AppColors.grey900;
      textColor = AppColors.white;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: AppText.label.copyWith(
          color: textColor,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const _NavArrow({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.grey700),
      ),
    );
  }
}