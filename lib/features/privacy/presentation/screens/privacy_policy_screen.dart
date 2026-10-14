import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/privacy/domain/privacy_policy_content.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final copy = PrivacyPolicyContent.forLanguageCode(languageCode);

    return SimplePage(
      title: copy.title,
      fallbackRoute: '/welcome',
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PolicyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.versionAndDate,
                    style: AppText.caption.copyWith(
                      color: AppColors.primary600,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    copy.introduction,
                    style: AppText.body.copyWith(
                      color: AppColors.grey700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            for (final section in copy.sections) ...[
              _PolicySectionCard(section: section),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _PolicySectionCard extends StatelessWidget {
  const _PolicySectionCard({required this.section});

  final PrivacyPolicySection section;

  @override
  Widget build(BuildContext context) {
    return _PolicyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(section.title, style: AppText.h5),
          if (section.paragraphs.isNotEmpty) const SizedBox(height: 10),
          for (final paragraph in section.paragraphs) ...[
            Text(
              paragraph,
              style: AppText.body.copyWith(
                color: AppColors.grey700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
          ],
          for (final bullet in section.bullets) ...[
            _PolicyBullet(text: bullet),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _PolicyBullet extends StatelessWidget {
  const _PolicyBullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary400,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppText.body.copyWith(
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PolicyCard extends StatelessWidget {
  const _PolicyCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.grey200),
      ),
      child: child,
    );
  }
}
