import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 60, 18, 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'moc/Article.png',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'October 4, 2021   •   4 min read',
              style: AppText.caption.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pain Relief Pills for Menstrual Cramps: How They Work and When to Use Them',
              style: AppText.h4,
            ),
            const SizedBox(height: 14),
            Text(
              'Find quick, gentle relief during your period.',
              style: AppText.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),
            ...const [
              _ArticleSection(
                title: 'Why cramps happen:',
                bullets: [
                  'Caused by uterine contractions that help shed the lining.',
                  'Triggered by high levels of prostaglandins that raise pain and tension.',
                ],
              ),
              _ArticleSection(
                title: 'Best pain relief options:',
                bullets: [
                  'NSAIDs like ibuprofen or naproxen reduce inflammation and ease muscle contractions.',
                  'Acetaminophen can help with mild pain if NSAIDs are not suitable.',
                ],
              ),
              _ArticleSection(
                title: 'When to take them:',
                bullets: [
                  'At the first sign of cramps or just before your period starts.',
                  'Always take with food or water to avoid stomach irritation.',
                ],
              ),
              _ArticleSection(
                title: 'Be careful with overuse:',
                bullets: [
                  'Too much medication may cause nausea, fatigue, or stomach pain.',
                  'Follow the recommended dose and ask for medical advice if pain is severe.',
                ],
              ),
              _ArticleSection(
                title: 'Extra comfort tips:',
                bullets: [
                  'Use a warm compress on your lower belly.',
                  'Try gentle stretching or light movement to relax your muscles.',
                  'Stay hydrated and give yourself enough rest.',
                ],
              ),
            ],
            const SizedBox(height: 14),
            Text(
              'A little care goes a long way - your body deserves it.',
              style: AppText.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FeedbackButton(
                  icon: Icons.thumb_up_alt_outlined,
                  selected: true,
                  onTap: () => _showFeedbackDialog(context),
                ),
                const SizedBox(width: 18),
                _FeedbackButton(
                  icon: Icons.thumb_down_alt_outlined,
                  onTap: () => _showFeedbackDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Add Comment',
              onPressed: () => _showFeedbackDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child:
                    const Icon(Icons.check, size: 36, color: AppColors.success),
              ),
              const SizedBox(height: 20),
              const Text('Thanks for feedback!',
                  style: AppText.h4, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                "Feedback received. We'll do our best to bring you a better user experience",
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.grey900,
                    shape: const StadiumBorder(),
                  ),
                  child: Text('OK',
                      style: AppText.label.copyWith(color: AppColors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ArticleSection extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const _ArticleSection({required this.title, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppText.body.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          for (final item in bullets)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('• $item',
                  style: AppText.body.copyWith(color: AppColors.grey700)),
            ),
        ],
      ),
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF6D8) : AppColors.grey100,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            color: selected ? const Color(0xFFE4A100) : AppColors.grey700),
      ),
    );
  }
}
