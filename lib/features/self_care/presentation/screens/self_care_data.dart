import 'package:flutter/material.dart';

class SelfCareSection {
  final String title;
  final List<SelfCareCardData> cards;

  const SelfCareSection({
    required this.title,
    required this.cards,
  });
}

class SelfCareCardData {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color accent;
  final String route;
  final bool large;
  final String? badge;

  const SelfCareCardData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.accent,
    required this.route,
    this.large = false,
    this.badge,
  });
}

class SelfCareStep {
  final String title;
  final String subtitle;
  final String imagePath;

  const SelfCareStep({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

const List<String> kCrampsNeeds = [
  'Yoga Pillow',
  'Water Bottle',
  'Yoga Mat',
];

const List<SelfCareStep> kCrampsSteps = [
  SelfCareStep(
    title: 'Chin to Chest',
    subtitle: '5 min',
    imagePath: 'moc/cramps details-1.png',
  ),
  SelfCareStep(
    title: 'Recline Reset',
    subtitle: '4 min',
    imagePath: 'moc/cramps details-2.png',
  ),
  SelfCareStep(
    title: 'Supported Pigeon',
    subtitle: '3 min',
    imagePath: 'moc/cramps details-3.png',
  ),
  SelfCareStep(
    title: 'Butterfly Fold',
    subtitle: '5 min',
    imagePath: 'moc/cramps details-4.png',
  ),
  SelfCareStep(
    title: 'Lotus Lift',
    subtitle: '4 min',
    imagePath: 'moc/cramps details-5.png',
  ),
  SelfCareStep(
    title: 'Legs Wall',
    subtitle: '3 min',
    imagePath: 'moc/cramps details-6.png',
  ),
];

const List<SelfCareStep> kSkinCareSteps = [
  SelfCareStep(
    title: 'Neck Lift',
    subtitle: 'Chin upward',
    imagePath: 'moc/SkinCare-1.png',
  ),
  SelfCareStep(
    title: 'Gua Sha Massage',
    subtitle: 'Sweep outward gently',
    imagePath: 'moc/SkinCare.png',
  ),
  SelfCareStep(
    title: 'Facial Cleaning',
    subtitle: 'Gently cleanse face',
    imagePath: 'moc/SkinCare-2.png',
  ),
  SelfCareStep(
    title: 'Glow Press',
    subtitle: 'Light circular motion',
    imagePath: 'moc/SkinCare-3.png',
  ),
  SelfCareStep(
    title: 'Hydration Lock',
    subtitle: 'Seal in moisture',
    imagePath: 'moc/SkinCare-4.png',
  ),
];

const List<Map<String, String>> kSleepTracks = [
  {'title': 'Calm Flow', 'subtitle': 'Brath of Life', 'image': 'moc/relaxing details-1.png'},
  {'title': 'Soul Drift', 'subtitle': 'Sounds Of Serenity', 'image': 'moc/relaxing details-2.png'},
  {'title': 'Inner Peace', 'subtitle': 'Mindful Journey', 'image': 'moc/relaxing details-3.png'},
  {'title': 'Whispering Nature', 'subtitle': "Nature's Rhythm", 'image': 'moc/relaxing details-4.png'},
  {'title': 'Golden Dawn', 'subtitle': 'Harmony Within', 'image': 'moc/Sleep Meditation-1.png'},
  {'title': 'Breathe In Silence', 'subtitle': 'Deep Rest Session', 'image': 'moc/Meditation details-1.png'},
];

const List<SelfCareSection> kSelfCareSections = [
  SelfCareSection(
    title: 'Menstrual cramps relief',
    cards: [
      SelfCareCardData(
        title: 'Balance',
        subtitle: 'Gentle yoga to ease tension',
        imagePath: 'moc/cramps details.png',
        accent: Color(0xFFF9C9D5),
        route: '/self-care/activity-detail',
        large: true,
        badge: 'Get started',
      ),
      SelfCareCardData(
        title: 'Focus',
        subtitle: 'Breathing and slow release',
        imagePath: 'moc/cramps details-7.png',
        accent: Color(0xFFFDE4EA),
        route: '/self-care/activity-detail',
        badge: 'Get started',
      ),
    ],
  ),
  SelfCareSection(
    title: 'Hormonal Balance',
    cards: [
      SelfCareCardData(
        title: 'Strength',
        subtitle: '7 low-impact exercises',
        imagePath: 'moc/Strength details.png',
        accent: Color(0xFFEADCFB),
        route: '/self-care/strength',
        badge: 'Get started',
      ),
      SelfCareCardData(
        title: 'Flexibility',
        subtitle: 'Mobility for everyday comfort',
        imagePath: 'moc/Strength details-1.png',
        accent: Color(0xFFF7E8FB),
        route: '/self-care/strength',
        badge: 'Get started',
      ),
    ],
  ),
  SelfCareSection(
    title: 'Facial Care',
    cards: [
      SelfCareCardData(
        title: 'Slim down your face',
        subtitle: 'Lift and sculpt softly',
        imagePath: 'moc/Facial Care.png',
        accent: Color(0xFFFFE9F2),
        route: '/self-care/skincare',
      ),
      SelfCareCardData(
        title: 'Glow up your skin',
        subtitle: 'Cleanse and hydrate',
        imagePath: 'moc/SkinCare-2.png',
        accent: Color(0xFFF7E5FB),
        route: '/self-care/skincare',
      ),
    ],
  ),
  SelfCareSection(
    title: 'Relaxing stretching',
    cards: [
      SelfCareCardData(
        title: 'Neck pain relief',
        subtitle: 'Release upper-body tension',
        imagePath: 'moc/relaxing details.png',
        accent: Color(0xFFFFE8ED),
        route: '/self-care/timer',
      ),
      SelfCareCardData(
        title: 'Lower back stretch',
        subtitle: 'Slow restorative motion',
        imagePath: 'moc/relaxing details-2.png',
        accent: Color(0xFFFFEFF3),
        route: '/self-care/timer',
      ),
    ],
  ),
  SelfCareSection(
    title: 'Articles',
    cards: [
      SelfCareCardData(
        title: 'Period pain Pills',
        subtitle: '4 min read',
        imagePath: 'moc/Article.png',
        accent: Color(0xFFFFE4EA),
        route: '/self-care/article',
      ),
      SelfCareCardData(
        title: 'Menstrual Cups',
        subtitle: '6 min read',
        imagePath: 'moc/Article Details-5.png',
        accent: Color(0xFFF0E4FD),
        route: '/self-care/article',
      ),
    ],
  ),
];
