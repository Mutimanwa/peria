import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class AppointmentConfirmationScreen extends StatelessWidget {
  const AppointmentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final appointmentStart = DateTime(2024, 10, 26, 10, 30);
    final appointmentEnd = DateTime(2024, 10, 26, 11);
    final appointmentDate = DateFormat.yMMMMEEEEd(locale).format(appointmentStart);
    final appointmentTime =
        '${DateFormat.jm(locale).format(appointmentStart)} – ${DateFormat.jm(locale).format(appointmentEnd)}';
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: const Icon(Icons.close_rounded),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.success, width: 2),
              ),
              child:
                  const Icon(Icons.check, color: AppColors.success, size: 40),
            ),
            const SizedBox(height: 20),
            Text(l10n.appointmentConfirmed, style: AppText.h3),
            const SizedBox(height: 8),
            Text(
              l10n.appointmentBooked('Adrian Cole'),
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 22),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundImage: AssetImage('moc/Chat Page-72.png'),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text('4.5 | ${l10n.appointmentReviewCount(2340)}',
                                  style: AppText.caption
                                      .copyWith(fontWeight: FontWeight.w700)),
                            ),
                            const SizedBox(height: 10),
                            const Text('Dr. Adrian Cole', style: AppText.h5),
                            Text(l10n.appointmentGynecologist,
                                style: AppText.body
                                    .copyWith(color: AppColors.grey600)),
                            Text(l10n.appointmentGynOncologyFocus,
                                style: AppText.caption
                                    .copyWith(color: AppColors.grey500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),
                  _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      text: appointmentDate),
                  const SizedBox(height: 16),
                  _InfoRow(
                      icon: Icons.access_time_outlined,
                      text: appointmentTime),
                  const SizedBox(height: 16),
                  _InfoRow(
                      icon: Icons.videocam_outlined,
                      text: l10n.appointmentVideoConsultation),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 26),
              child: PrimaryButton(
                label: l10n.appointmentDoneBackToChat,
                onPressed: () => context.go('/ai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppColors.grey700),
        ),
        const SizedBox(width: 12),
        Text(text, style: AppText.body.copyWith(color: AppColors.grey700)),
      ],
    );
  }
}
