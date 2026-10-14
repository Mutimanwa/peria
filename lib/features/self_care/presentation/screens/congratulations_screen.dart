import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class CongratulationsScreen extends StatelessWidget {
  const CongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'moc/Congratulations.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 26),
              Text(l10n.selfCareCongratulations, style: AppText.h2),
              const SizedBox(height: 10),
              Text(
                l10n.selfCareCongratulationsMessage,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                label: l10n.selfCareBackHome,
                onPressed: () => context.go('/self-care'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
