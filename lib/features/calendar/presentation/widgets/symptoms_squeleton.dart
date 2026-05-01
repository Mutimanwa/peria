import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:peria_app/core/theme/theme.dart';

class SymptomsSkeleton extends StatelessWidget {
  const SymptomsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  
                  // Header
                  _buildHeaderSkeleton(),
                  const SizedBox(height: 16),
                  
                  // Week selector
                  _buildWeekSelectorSkeleton(),
                  const SizedBox(height: 16),
                  
                  // Info banner
                  _buildInfoBannerSkeleton(),
                  const SizedBox(height: 16),
                  
                  // Category cards
                  _buildCategoryCardSkeleton(
                    titleWidth: 150,
                    pillCount: 5,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryCardSkeleton(
                    titleWidth: 100,
                    pillCount: 4,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryCardSkeleton(
                    titleWidth: 120,
                    pillCount: 6,
                  ),
                  const SizedBox(height: 8),
                  _buildCategoryCardSkeleton(
                    titleWidth: 80,
                    pillCount: 3,
                  ),
                  const SizedBox(height: 8),
                  
                  // Daily context card
                  _buildDailyContextCardSkeleton(),
                ],
              ),
            ),
          ),
          
          // Floating button skeleton
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 140,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            width: 50,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekSelectorSkeleton() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            width: 56,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  width: 20,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoBannerSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  Widget _buildCategoryCardSkeleton({
    required double titleWidth,
    required int pillCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: titleWidth,
              height: 22,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(
                pillCount,
                (index) => Container(
                  width: 85,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyContextCardSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notes title
            Container(
              width: 80,
              height: 22,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            // Text field area
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            const SizedBox(height: 18),
            // Intensity label
            Container(
              width: 70,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 10),
            // Intensity buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                5,
                (index) => Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}