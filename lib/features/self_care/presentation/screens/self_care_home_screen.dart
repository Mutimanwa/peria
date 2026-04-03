import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/custom_bottom_nav.dart';

class SelfCareHomeScreen extends StatefulWidget {
  const SelfCareHomeScreen({super.key});

  @override
  State<SelfCareHomeScreen> createState() => _SelfCareHomeScreenState();
}

class _SelfCareHomeScreenState extends State<SelfCareHomeScreen> {
  NavItem _activeTab = NavItem.journal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120), // Espace sous nav
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('What do you want\nto learn today?',
                          style: AppText.h2, textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 24),
                    // Tabs Placeholder
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildTabPlaceholder('All', true),
                          const SizedBox(width: 8),
                          _buildTabPlaceholder('Cramps Relief', false),
                          const SizedBox(width: 8),
                          _buildTabPlaceholder('Hormonal Balance', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Menstrual cramps relief Section
                    _buildSectionTitle('Menstrual cramps relief'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildImageCardPlaceholder(width: 280, height: 160),
                          const SizedBox(width: 16),
                          _buildImageCardPlaceholder(width: 280, height: 160),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Hormonal Balance Section
                    _buildSectionTitle('Hormonal Balance'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildImageCardPlaceholder(width: 280, height: 160),
                          const SizedBox(width: 16),
                          _buildImageCardPlaceholder(width: 160, height: 160),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Facial Care Section
                    _buildSectionTitle('Facial Care'),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildImageCardPlaceholder(width: 160, height: 220),
                          const SizedBox(width: 16),
                          _buildImageCardPlaceholder(width: 160, height: 220),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Deep Sleep Meditation Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildImageCardPlaceholder(width: double.infinity, height: 200, label: 'Deep Sleep Meditation'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNav(
              currentIndex: _activeTab,
              onTap: (tab) {
                setState(() => _activeTab = tab);
                if (tab == NavItem.cycle) {
                  context.go('/');
                } else if (tab == NavItem.ai) {
                  context.go('/calendar');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: AppText.h4),
      ),
    );
  }

  Widget _buildTabPlaceholder(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.grey900 : AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppText.body.copyWith(
          color: isSelected ? AppColors.white : AppColors.grey900,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildImageCardPlaceholder({required double width, required double height, String? label}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image, size: 40, color: AppColors.primary200),
            if (label != null) ...[
              const SizedBox(height: 8),
              Text(label, style: AppText.h4.copyWith(color: AppColors.primary400)),
            ]
          ],
        ),
      ),
    );
  }
}
