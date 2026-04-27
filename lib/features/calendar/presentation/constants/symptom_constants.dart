import 'package:flutter/material.dart';

class SymptomOption {
  const SymptomOption(this.label, this.icon);

  final String label;
  final IconData icon;
}

const Map<String, List<SymptomOption>> symptomCategories = {
  'Sexual activity': [
    SymptomOption('Protected Sex', Icons.female),
    SymptomOption('Orgasm', Icons.favorite_border),
    SymptomOption('High activity', Icons.local_fire_department_outlined),
    SymptomOption('Unprotected sex', Icons.male),
  ],
  'Mental': [
    SymptomOption('Breathing Exercises', Icons.air),
    SymptomOption('Stress', Icons.self_improvement),
    SymptomOption('Yoga', Icons.accessibility_new),
    SymptomOption('Meditation', Icons.spa_outlined),
  ],
  'Discharge': [
    SymptomOption('Unusual', Icons.water_drop_outlined),
    SymptomOption('Sticky', Icons.water_drop),
    SymptomOption('Bleeding', Icons.opacity),
    SymptomOption('Heavy Bleeding', Icons.bloodtype_outlined),
    SymptomOption('Low Bleeding', Icons.invert_colors_off_outlined),
  ],
  'Physical activity': [
    SymptomOption('No Exercise', Icons.remove),
    SymptomOption('Team sports', Icons.sports_basketball),
    SymptomOption('Cycling', Icons.directions_bike),
    SymptomOption('Gym', Icons.fitness_center),
    SymptomOption('Dancing', Icons.music_note_outlined),
    SymptomOption('Aerobics', Icons.directions_walk),
    SymptomOption('Swimming', Icons.pool),
  ],
  'Mood': [
    SymptomOption('Anxious', Icons.sentiment_dissatisfied),
    SymptomOption('Sad', Icons.sentiment_dissatisfied_outlined),
    SymptomOption('Happy', Icons.sentiment_very_satisfied),
    SymptomOption('Calm', Icons.sentiment_satisfied),
    SymptomOption('Angry', Icons.sentiment_very_dissatisfied),
    SymptomOption('Energetic', Icons.bolt_outlined),
    SymptomOption('Confused', Icons.sentiment_neutral),
    SymptomOption('Depressed', Icons.cloud_outlined),
  ],
};
