import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class PartnerScreen extends StatelessWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Partner',
      child: Column(
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('moc/Partner Pending Screen.png',
                height: 185, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          const Text('Connect with your partner',
              style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Securely share key cycle dates, predictions, and ovulation windows.',
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          PrimaryButton(
              label: 'Invite Partner',
              onPressed: () => context.go('/profile/partner/invite')),
          const SizedBox(height: 12),
          OutlineButton(label: 'Learn More', onPressed: () {}),
        ],
      ),
    );
  }
}
