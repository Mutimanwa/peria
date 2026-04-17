import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'My Profile',
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 46,
              backgroundImage:
                  AssetImage('assets/images/onboarding/Avatar-21.png'),
            ),
            const SizedBox(height: 16),
            const Text('Sara Hoseini', style: AppText.h3),
            const SizedBox(height: 4),
            Text('Sarahoseini@gmail.com',
                style: AppText.body.copyWith(color: AppColors.grey500)),
            const SizedBox(height: 28),
            const SectionLabel('My Account'),
            MenuGroup(items: [
              MenuItemData('Personal Information', Icons.person_outline,
                  () => context.go('/profile/personal-info')),
              MenuItemData('Partner', Icons.favorite_border,
                  () => context.go('/profile/partner')),
              MenuItemData('Account & Security', Icons.shield_outlined,
                  () => context.go('/profile/account-security')),
            ]),
            const SizedBox(height: 22),
            const SectionLabel('App Setting'),
            MenuGroup(items: [
              MenuItemData('Settings', Icons.settings_outlined,
                  () => context.go('/profile/settings')),
              MenuItemData('Notifications', Icons.notifications_none_rounded,
                  () => context.go('/profile/notifications')),
            ]),
            const SizedBox(height: 22),
            const SectionLabel('Support & Legal'),
            MenuGroup(items: [
              MenuItemData('Help & Support', Icons.help_outline_rounded, () {}),
              MenuItemData('Log out', Icons.logout_rounded, () {}, danger: true),
            ]),
          ],
        ),
      ),
    );
  }
}



