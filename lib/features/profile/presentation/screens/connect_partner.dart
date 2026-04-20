import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:perla_app/l10n/app_localizations.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class ConnectedPartnerScreen extends ConsumerStatefulWidget {
  const ConnectedPartnerScreen({super.key});

  @override
  ConsumerState<ConnectedPartnerScreen> createState() =>
      _ConnectedPartnerScreenState();
}

class _ConnectedPartnerScreenState extends ConsumerState<ConnectedPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final partnerAsync = ref.watch(partnerSettingsProvider);
    return SimplePage(
      title: l10n.partner,
      child: partnerAsync.when(
        data: (partner) => Column(
          children: [
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'moc/Partner Pending Screen (2).png',
                height: 185,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.connectedPartnerTitle(
                partner.partnerEmail ?? l10n.yourPartnerFallback,
              ),
              style: AppText.h2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              l10n.partnerConnectedDescription,
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
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.partnerEmail ?? '-',
                        style: AppText.label.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.statusConnected,
                            style: AppText.body.copyWith(color: AppColors.grey600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: l10n.manageSharingSettings,
              onPressed: () => context.go('/profile/sharing-settings'),
            ),
            const SizedBox(height: 12),
            OutlineButton(
              label: l10n.disconnectPartner,
              onPressed: () => _showDisconnectDialog(context),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text(l10n.unableToLoadPartner)),
      ),
    );
  }

  void _showDisconnectDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final partner = ref.read(partnerSettingsProvider).valueOrNull;
    final partnerName = partner?.partnerEmail ?? l10n.yourPartnerFallback;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('moc/Chat Page-68.png', width: 84, height: 84),
            const SizedBox(height: 14),
            Text(
              l10n.disconnectFromPartnerTitle(partnerName),
              style: AppText.h4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.disconnectWarning,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.cancel,
                      style: AppText.label.copyWith(color: AppColors.grey700),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(partnerSettingsProvider.notifier).disconnectPartner();
                        this.context.go('/profile/partner');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey900,
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        l10n.disconnect,
                        style: AppText.label.copyWith(color: AppColors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
