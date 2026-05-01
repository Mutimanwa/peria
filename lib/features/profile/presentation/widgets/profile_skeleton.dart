import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey100,
      highlightColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar skeleton
            const CircleAvatar(radius: 46, backgroundColor: Colors.white),
            const SizedBox(height: 16),
            // Display name skeleton
            Container(width: 150, height: 24, color: Colors.white),
            const SizedBox(height: 8),
            // Email skeleton
            Container(width: 200, height: 16, color: Colors.white),
            const SizedBox(height: 28),
            // Section "Mon compte" label skeleton
            Container(width: 120, height: 18, color: Colors.white),
            const SizedBox(height: 12),
            // Menu items skeletons for "Mon compte"
            _buildMenuItemSkeleton(),
            const SizedBox(height: 22),
            // Section "Paramètres de l'application" label skeleton
            Container(width: 180, height: 18, color: Colors.white),
            const SizedBox(height: 12),
            // Menu items skeletons for "Paramètres de l'application"
            _buildMenuItemSkeleton(count: 2),
            const SizedBox(height: 22),
            // Section "Support & Légal" label skeleton
            Container(width: 140, height: 18, color: Colors.white),
            const SizedBox(height: 12),
            // Menu items skeletons for "Support & Légal"
            _buildMenuItemSkeleton(count: 2, withDanger: true),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemSkeleton({int count = 3, bool withDanger = false}) {
    return Column(
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              // Icon skeleton
              Container(
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 16),
              // Text skeleton
              Expanded(
                child: Container(
                  height: 16,
                  color: Colors.white,
                ),
              ),
              // Trailing icon skeleton (chevron)
              if (!withDanger || index != count - 1)
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
            ],
          ),
        );
      }),
    );
  }
}