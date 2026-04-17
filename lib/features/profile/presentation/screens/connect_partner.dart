import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/core/theme/app_text.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class ConnectedPartnerScreen extends StatefulWidget {
  const ConnectedPartnerScreen({super.key});

  @override
  State<ConnectedPartnerScreen> createState() => _ConnectedPartnerScreenState();
}

class _ConnectedPartnerScreenState extends State<ConnectedPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Partner',
      child: Column(
        children: [
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('moc/Partner Pending Screen (2).png',
                height: 185, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          const Text("You're connected with Reza!",
              style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            'You can now manage your shared cycle data and insights below.',
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
                        color: Colors.black, shape: BoxShape.circle)),
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
                                color: AppColors.success,
                                shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('Status: Connected',
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
              label: 'Manage Sharing Settings',
              onPressed: () => context.go('/profile/partner/sharing')),
          const SizedBox(height: 12),
          OutlineButton(
            label: 'Disconnect Partner',
            onPressed: () => _showDisconnectDialog(context),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog(BuildContext context) {
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
            const Text('Disconnect from Sam?',
                style: AppText.h4, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'This will immediately stop all data sharing.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Cancel',
                            style: AppText.label
                                .copyWith(color: AppColors.grey700)))),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        this.context.go('/profile/partner');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grey900,
                          shape: const StadiumBorder()),
                      child: Text('Disconnect',
                          style:
                              AppText.label.copyWith(color: AppColors.white)),
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
