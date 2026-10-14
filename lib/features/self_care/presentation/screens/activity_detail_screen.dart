import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/self_care/presentation/screens/self_care_data.dart';
import 'package:peria_app/features/self_care/presentation/screens/self_care_localization.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';
import 'package:peria_app/shared/widgets/health_information_notice.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 72, 22, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                l10n.selfCareCategoryCramps,
                style: AppText.label.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'moc/cramps details.png',
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _MetaChip(
                  icon: Icons.schedule_rounded,
                  label: l10n.selfCareMinutes(24),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(l10n.selfCareAlignMindBody, style: AppText.h4),
            const SizedBox(height: 6),
            Text(
              l10n.selfCareActivityDescription,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            HealthInformationNotice(
              title: l10n.educationMovementNoticeTitle,
              message: l10n.educationMovementNoticeBody,
            ),
            const SizedBox(height: 22),
            Text(l10n.selfCareYouWillNeed, style: AppText.h6),
            const SizedBox(height: 14),
            SizedBox(
              height: 116,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kCrampsNeeds.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _NeedCard(
                    label: localizeSelfCareData(kCrampsNeeds[index], l10n),
                    imagePath: 'moc/cramps details-${index + 1}.png',
                  );
                },
              ),
            ),
            const SizedBox(height: 22),
            Text(l10n.selfCareRound(1), style: AppText.h6),
            const SizedBox(height: 12),
            ...kCrampsSteps.take(3).map((step) => _StepTile(step)),
            const SizedBox(height: 16),
            Text(l10n.selfCareRound(2), style: AppText.h6),
            const SizedBox(height: 12),
            ...kCrampsSteps.skip(3).map((step) => _StepTile(step)),
            const SizedBox(height: 28),
            PrimaryButton(
              label: l10n.selfCareStart,
              onPressed: () => context.go('/self-care/activity-step'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.white, size: 14),
          const SizedBox(width: 4),
          Text(label, style: AppText.caption.copyWith(color: AppColors.white)),
        ],
      ),
    );
  }
}

class _NeedCard extends StatelessWidget {
  final String label;
  final String imagePath;

  const _NeedCard({required this.label, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset(imagePath, fit: BoxFit.contain)),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: AppText.caption),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final SelfCareStep step;

  const _StepTile(this.step);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              step.imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizeSelfCareData(step.title, l10n),
                    style: AppText.label.copyWith(fontWeight: FontWeight.w700)),
                Text(localizeSelfCareData(step.subtitle, l10n),
                    style: AppText.caption.copyWith(color: AppColors.grey500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
