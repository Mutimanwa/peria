import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/onboarding/domain/minimum_age.dart';
import 'package:peria_app/features/profile/presentation/providers/user_profile_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

/// Blocks the rest of the app when a saved birth date is under 10.
///
/// While the profile is still loading, the child stays visible so the screen
/// is never a blank black route. A missing birth date is not treated as
/// underage; the date-of-birth step is what prevents new accounts from
/// continuing without a valid age.
class MinimumAgeGate extends ConsumerWidget {
  const MinimumAgeGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateOfBirth = ref.watch(userProfileProvider).valueOrNull?.dateOfBirth;
    if (dateOfBirth != null &&
        !isAtLeastMinimumAge(dateOfBirth, DateTime.now())) {
      return const AgeRestrictedScreen();
    }
    return child;
  }
}

class AgeRestrictedScreen extends StatelessWidget {
  const AgeRestrictedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.primary50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cake_outlined,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.ageRestrictedTitle,
                  style: AppText.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.ageRestrictedBody(minimumAccountAgeYears),
                  style: AppText.body,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                PrimaryButton(
                  label: l10n.updateDateOfBirth,
                  onPressed: () => context.go('/date-of-birth'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
