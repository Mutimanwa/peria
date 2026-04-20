import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class PartnerInvitationPendingScreen extends ConsumerWidget {
  const PartnerInvitationPendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnerAsync = ref.watch(partnerSettingsProvider);
    return SimplePage(
      title: 'Partner',
      child: partnerAsync.when(
        data: (partner) => Column(
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
                      Text(partner.partnerEmail ?? '-',
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
            PrimaryButton(
              label: 'Resend Invitation',
              onPressed: () async {
                final email = partner.partnerEmail;
                if (email == null || email.isEmpty) return;
                await ref.read(partnerSettingsProvider.notifier).invitePartner(email);
              },
            ),
            const SizedBox(height: 12),
            OutlineButton(
              label: 'Cancel Invitation',
              onPressed: () async {
                await ref.read(partnerSettingsProvider.notifier).cancelInvitation();
                if (context.mounted) context.go('/profile/partner');
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load invitation')),
      ),
    );
  }
}
