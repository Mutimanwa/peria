import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class PartnerScreen extends ConsumerWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final partnerAsync = ref.watch(partnerSettingsProvider);
    return SimplePage(
      title: l10n.partner,
      child: partnerAsync.when(
        data: (partner) => Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'moc/Partner Pending Screen.png',
                height: 185,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              partner.isConnected
                  ? l10n.yourPartnerIsConnected
                  : (partner.isPending
                      ? l10n.invitationPending
                      : l10n.connectWithYourPartner),
              style: AppText.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              partner.isConnected
                  ? l10n.partnerConnectedBody
                  : (partner.isPending
                      ? l10n.partnerPendingBody
                      : l10n.partnerInviteBody),
              style: AppText.body.copyWith(color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            PrimaryButton(
              label: partner.isConnected
                  ? l10n.manageSharing
                  : (partner.isPending ? l10n.viewInvitation : l10n.invitePartner),
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
              label: partner.isConnected ? l10n.disconnect : l10n.learnMore,
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
        error: (_, __) => Center(child: Text(l10n.unableToLoadPartnerSettings)),
      ),
    );
  }
}
