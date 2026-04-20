import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/features/profile/presentation/providers/partner_settings_provider.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class InvitePartnerScreen extends ConsumerStatefulWidget {
  const InvitePartnerScreen({super.key});

  @override
  ConsumerState<InvitePartnerScreen> createState() => _InvitePartnerScreenState();
}

class _InvitePartnerScreenState extends ConsumerState<InvitePartnerScreen> {
  final TextEditingController _email =
      TextEditingController(text: 'Samrad@gmail.com');

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Invite Partner',
      child: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset('moc/Invite Partner.png', height: 150),
          const SizedBox(height: 18),
          const Text('Invite your partner',
              style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            "We'll send a secure, private invitation link for your partner.",
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const FieldLabel("Partner's Email Address"),
          TextField(
            controller: _email,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.grey100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Send Invitation',
            onPressed: () async {
              await ref
                  .read(partnerSettingsProvider.notifier)
                  .invitePartner(_email.text);
              if (!mounted) return;
              _showInvitationDialog(context);
            },
          ),
          const SizedBox(height: 12),
          OutlineButton(label: 'Share Link Manually', onPressed: () {}),
        ],
      ),
    );
  }

  void _showInvitationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2)),
              child:
                  const Icon(Icons.check, color: AppColors.success, size: 36),
            ),
            const SizedBox(height: 18),
            const Text('Invitation Sent!', style: AppText.h4),
            const SizedBox(height: 8),
            Text(
              'Your partner has been sent an invitation to accept.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  this.context.go('/profile/partner-pending');
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey900,
                    shape: const StadiumBorder()),
                child: Text('Got it',
                    style: AppText.label.copyWith(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
