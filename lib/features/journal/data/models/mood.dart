import 'package:flutter/material.dart';

class Mood {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final Color accent;

  const Mood({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.accent,
  });

  static const List<Mood> all = [
    Mood(
      id: 'calm',
      label: 'Calm',
      icon: Icons.sentiment_satisfied_alt_rounded,
      color: Color(0xFFE0F2FE),
      accent: Color(0xFF0EA5E9),
    ),
    Mood(
      id: 'happy',
      label: 'Happy',
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFFFFF1F2),
      accent: Color(0xFFF43F5E),
    ),
    Mood(
      id: 'excited',
      label: 'Excited',
      icon: Icons.celebration_rounded,
      color: Color(0xFFF0FDF4),
      accent: Color(0xFF22C55E),
    ),
    Mood(
      id: 'anxious',
      label: 'Anxious',
      icon: Icons.spa_rounded,
      color: Color(0xFFF5F3FF),
      accent: Color(0xFF8B5CF6),
    ),
    Mood(
      id: 'sad',
      label: 'Sad',
      icon: Icons.sentiment_dissatisfied_rounded,
      color: Color(0xFFF1F5F9),
      accent: Color(0xFF64748B),
    ),
    Mood(
      id: 'tired',
      label: 'Tired',
      icon: Icons.nights_stay_rounded,
      color: Color(0xFFFEFCE8),
      accent: Color(0xFFEAB308),
    ),
  ];

  factory Mood.fromId(String id) {
    return all.firstWhere((m) => m.id == id, orElse: () => all[0]);
  }

  static List<Mood> get values => all;
}
