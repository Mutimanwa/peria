import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class PartnerScreen extends ConsumerWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnerAsync = ref.watch(partnerSettingsProvider);
    return SimplePage(
      title: 'Partner',
      child: partnerAsync.when(
        data: (partner) => Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset('moc/Partner Pending Screen.png',
                  height: 185, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text(
              partner.isConnected
                  ? 'Your partner is connected'
                  : (partner.isPending
                      ? 'Invitation pending'
                      : 'Connect with your partner'),
              style: AppText.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              partner.isConnected
                  ? 'Manage what your partner can see from your cycle and wellbeing data.'
                  : (partner.isPending
                      ? 'Your invitation has been sent. You can manage or resend it from the next screen.'
                      : 'Securely share key cycle dates, predictions, and ovulation windows.'),
              style: AppText.body.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            PrimaryButton(
              label: partner.isConnected
                  ? 'Manage Sharing'
                  : (partner.isPending ? 'View Invitation' : 'Invite Partner'),
              onPressed: () => context.go(
                partner.isConnected
                    ? '/profile/sharing-settings'
                    : (partner.isPending
                        ? '/profile/partner-pending'
                        : '/profile/invite-partner'),
              ),
            ),
            const SizedBox(height: 12),
            OutlineButton(
              label: partner.isConnected ? 'Disconnect' : 'Learn More',
              onPressed: partner.isConnected
                  ? () async {
                      await ref
                          .read(partnerSettingsProvider.notifier)
                          .disconnectPartner();
                    }
                  : () {},
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load partner settings')),
      ),
    );
  }
}
