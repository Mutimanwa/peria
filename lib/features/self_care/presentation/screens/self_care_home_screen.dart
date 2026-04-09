import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/self_care/presentation/screens/self_care_data.dart';
import 'package:perla_app/shared/widgets/custom_bottom_nav.dart';

class SelfCareHomeScreen extends StatefulWidget {
  const SelfCareHomeScreen({super.key});

  @override
  State<SelfCareHomeScreen> createState() => _SelfCareHomeScreenState();
}

class _SelfCareHomeScreenState extends State<SelfCareHomeScreen> {
  NavItem _activeTab = NavItem.journal;
  String _selectedFilter = 'All';

  static const List<String> _filters = [
    'All',
    'Cramps Relief',
    'Hormonal Balance',
    'Facial Care',
  ];

  List<SelfCareSection> get _visibleSections {
    if (_selectedFilter == 'All') {
      return kSelfCareSections;
    }
    return kSelfCareSections
        .where((section) => section.title
            .toLowerCase()
            .contains(_selectedFilter.toLowerCase().split(' ').first))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SelfCareHeader(
                    onNotificationTap: () => context.go('/notification'),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      'What do you want\nto learn today?',
                      style: AppText.h2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final label = _filters[index];
                        final selected = label == _selectedFilter;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFilter = label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.grey900
                                  : AppColors.grey100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              label,
                              style: AppText.caption.copyWith(
                                color: selected
                                    ? AppColors.white
                                    : AppColors.grey700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final section in _visibleSections) ...[
                    Text(section.title, style: AppText.h5),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: section.title == 'Articles'
                          ? 188
                          : section.title == 'Facial Care'
                              ? 235
                              : 172,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: section.cards.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final card = section.cards[index];
                          return _SelfCareCard(card: card);
                        },
                      ),
                    ),
                    if (section.title == 'Facial Care')
                      const SizedBox(height: 10),
                    if (section.title == 'Articles') const SizedBox(height: 10),
                    if (section.title == 'Relaxing stretching')
                      const SizedBox(height: 14),
                    if (section.title != 'Articles') const SizedBox(height: 22),
                  ],
                  _MeditationHeroCard(
                    onTap: () => context.go('/self-care/meditation'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _activeTab,
              onTap: (tab) {
                setState(() => _activeTab = tab);
                if (tab == NavItem.cycle) {
                  context.go('/home');
                } else if (tab == NavItem.ai) {
                  context.go('/ai');
                } else if (tab == NavItem.journal) {
                  context.go('/journal');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SelfCareHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const _SelfCareHeader({required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.go('/profile'),
          child: const CircleAvatar(
            radius: 18,
            backgroundImage:
                AssetImage('assets/images/onboarding/Avatar-21.png'),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.favorite, color: AppColors.primary300, size: 16),
            const SizedBox(width: 6),
            Text(
              'Perla',
              style: AppText.label.copyWith(
                color: AppColors.primary400,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.grey200),
            ),
            child: const Icon(Icons.notifications_none_rounded, size: 20),
          ),
        ),
      ],
    );
  }
}

class _SelfCareCard extends StatelessWidget {
  final SelfCareCardData card;

  const _SelfCareCard({required this.card});

  @override
  Widget build(BuildContext context) {
    final width = card.large ? 196.0 : 160.0;
    final height = card.large ? 164.0 : 220.0;

    return GestureDetector(
      onTap: () => context.go(card.route),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              card.accent,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: card.large ? -10 : 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  card.imagePath,
                  width: card.large ? 118 : 140,
                  height: card.large ? 140 : 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              left: 14,
              top: 14,
              right: 82,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.title,
                      style: AppText.h6.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    card.subtitle,
                    style: AppText.caption.copyWith(color: AppColors.grey600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (card.badge != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        card.badge!,
                        style: AppText.caption.copyWith(
                          color: AppColors.grey900,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeditationHeroCard extends StatelessWidget {
  final VoidCallback onTap;

  const _MeditationHeroCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 184,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage('moc/Sleep Meditation.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.45),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Deep Sleep\nMeditation',
                  style: AppText.h4.copyWith(color: AppColors.white)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            size: 16, color: AppColors.white),
                        const SizedBox(width: 4),
                        Text('Play',
                            style: AppText.caption
                                .copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
