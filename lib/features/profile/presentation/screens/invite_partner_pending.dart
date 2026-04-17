import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class PartnerInvitationPendingScreen extends StatelessWidget {
  const PartnerInvitationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Partner',
      child: Column(
        children: [
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'moc/Partner Pending Screen (1).png',
              height: 185,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          const SizedBox(height: 24),
          const Text("You've Invited Your Partner!",
              style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            "We'll let you know when they accept.",
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                      color: AppColors.grey900, shape: BoxShape.circle),
                  child: const Icon(Icons.person_add_alt_1_rounded,
                      color: AppColors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Samrad@gmail.com',
                        style: AppText.label
                            .copyWith(fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xFFF6C542),
                                shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('Status: Pending Approval',
                            style: AppText.body
                                .copyWith(color: AppColors.grey600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(label: 'Resend Invitation', onPressed: () {}),
          const SizedBox(height: 12),
          OutlineButton(
              label: 'Cancel Invitation',
              onPressed: () => context.go('/profile/partner')),
        ],
      ),
    );
  }
}
