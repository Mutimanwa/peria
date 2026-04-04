import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class StrengthDetailScreen extends StatefulWidget {
  const StrengthDetailScreen({super.key});

  @override
  State<StrengthDetailScreen> createState() => _StrengthDetailScreenState();
}

class _StrengthDetailScreenState extends State<StrengthDetailScreen> {
  double _progress = 0.25;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppText.h3.copyWith(color: AppColors.grey900),
                children: [
                  const TextSpan(text: 'jumping jacks'),
                  TextSpan(
                    text: '        1',
                    style: AppText.h3.copyWith(color: AppColors.primary400),
                  ),
                  TextSpan(
                    text: '/6',
                    style: AppText.h3.copyWith(color: AppColors.grey900),
                  ),
                ],
              ),
            ),
            Text('Full-body cardio', style: AppText.body.copyWith(color: AppColors.grey500)),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'moc/Strength details.png',
                width: double.infinity,
                height: 330,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 26),
            Expanded(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 176,
                        height: 176,
                        child: CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 5,
                          backgroundColor: AppColors.grey200,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary400),
                        ),
                      ),
                      Text('02:00', style: AppText.h3.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('04:00', style: AppText.h5.copyWith(color: AppColors.grey700)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.skip_previous_rounded, size: 34, color: AppColors.grey900),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => context.go('/self-care/timer'),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.grey900,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow_rounded, color: AppColors.white, size: 36),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => context.go('/self-care/congratulations'),
                        icon: const Icon(Icons.skip_next_rounded, size: 34, color: AppColors.grey900),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

