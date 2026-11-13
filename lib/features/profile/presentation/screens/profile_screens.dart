import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/profile_avatar.dart';
import 'package:peria_app/shared/widgets/profile_widgets.dart';

// Recuperation des infos de l'utilisateur

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userProfileAnsync = ref.watch(userProfileProvider);

    return SimplePage(
        title: l10n.myProfile,
        child: userProfileAnsync.when(
          loading: () => const Center(child: ProfileSkeleton()),
          error: (error, stackTrace) => Center(
            child: Text(l10n.unableToLoadProfile),
          ),
          data: (profile) => SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                ProfileAvatar(
                  avatarBase64: profile.avatarBase64,
                  radius: 46,
                ),
                const SizedBox(height: 16),

                Text(profile.displayName ?? 'Peria', style: AppText.h3),
                const SizedBox(height: 4),

                // if(profile.email != null)
                //   Text(
                //     profile.email ?? ' ',
                //     style: AppText.body.copyWith(color: AppColors.textSecondary),
                //   ),

                const SizedBox(height: 28),
                SectionLabel(l10n.myAccount),
                MenuGroup(items: [
                  if (FirebaseAuth.instance.currentUser?.isAnonymous ?? false)
                    MenuItemData(
                      l10n.createAccount,
                      Icons.person_add_alt_1_outlined,
                      () => context.push('/email'),
                    ),
                  MenuItemData(
                    l10n.personalInformation,
                    Icons.person_outline,
                    () => context.push('/profile/personal-info'),
                  ),
                  MenuItemData(
                    l10n.accountSecurity,
                    Icons.shield_outlined,
                    () => context.push('/profile/account-security'),
                  ),
                ]),
                const SizedBox(height: 22),
                SectionLabel(l10n.appSetting),
                MenuGroup(items: [
                  MenuItemData(
                    l10n.settings,
                    Icons.settings_outlined,
                    () => context.push('/profile/settings'),
                  ),
                ]),
                const SizedBox(height: 22),
                SectionLabel(l10n.supportLegal),
                MenuGroup(items: [
                  MenuItemData(l10n.helpSupport, Icons.help_outline_rounded,
                      () => context.push('/profile/help-support')),
                  MenuItemData(
                    l10n.logOut,
                    Icons.logout_rounded,
                    () => _signOut(context, ref),
                    danger: true,
                  ),
                ]),
              ],
            ),
          ),
        ));
  }
}

Future<void> _signOut(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final isAnonymous =
      ref.read(authProvider).user?.isAnonymous ??
          FirebaseAuth.instance.currentUser?.isAnonymous ??
          false;

  // An anonymous account has no way back: leaving it deletes everything.
  if (isAnonymous) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          l10n.anonymousLogoutTitle,
          style: AppText.h5.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(
          l10n.anonymousLogoutMessage,
          style: AppText.body.copyWith(color: AppColors.textSecondary, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.cancel,
              style: AppText.label.copyWith(color: AppColors.grey700),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.logOut,
              style: AppText.label.copyWith(
                color: AppColors.textError,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
  }

  try {
    await FirebaseAuth.instance.signOut();
  } catch (_) {
    // Still leave the signed-in area if the session is already gone.
  }
  if (context.mounted) context.go('/welcome');
}
