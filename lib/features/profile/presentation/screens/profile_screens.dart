import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/constants/app_assets.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

// Recuperation des infos de l'utilisateur 


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userProfileAnsync = ref.watch(userProfileProvider);

    return SimplePage(
      title: l10n.myProfile,
      child: userProfileAnsync.when(
        loading: () => const Center(child: ProfileSkeleton()),
        error: (error, stackTrace) => Center(child: Text("Erreur $error"),),
        data: (profile) => SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 46,
              backgroundImage:
                  AssetImage(AppAssets.avatar),
            ),
            const SizedBox(height: 16),
            
            Text(profile.displayName ?? 'Peria', style: AppText.h3),
            const SizedBox(height: 4),

            // if(profile.email != null)
            //   Text(
            //     profile.email ?? ' ',
            //     style: AppText.body.copyWith(color: AppColors.grey500),
            //   ),
            
            const SizedBox(height: 28),
            SectionLabel(l10n.myAccount),
            MenuGroup(items: [
              MenuItemData(
                l10n.personalInformation,
                Icons.person_outline,
                () => context.go('/profile/personal-info'),
              ),
              MenuItemData(
                l10n.partner,
                Icons.favorite_border,
                () => context.go('/profile/partner'),
              ),
              MenuItemData(
                l10n.accountSecurity,
                Icons.shield_outlined,
                () => context.go('/profile/account-security'),
              ),
            ]),
            const SizedBox(height: 22),
            SectionLabel(l10n.appSetting),
            MenuGroup(items: [
              MenuItemData(
                l10n.settings,
                Icons.settings_outlined,
                () => context.go('/profile/settings'),
              ),
              MenuItemData(
                l10n.notifications,
                Icons.notifications_none_rounded,
                () => context.go('/profile/notifications'),
              ),
            ]),
            const SizedBox(height: 22),
            SectionLabel(l10n.supportLegal),
            MenuGroup(items: [
              MenuItemData(l10n.helpSupport, Icons.help_outline_rounded, () {}),
              MenuItemData(l10n.logOut, Icons.logout_rounded, () {}, danger: true),
            ]),
          ],
        ),
      ),
        
      )
    );
  }
}
