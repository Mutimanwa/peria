import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/self_care/presentation/screens/self_care_data.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class ActivityStepScreen extends StatelessWidget {
  const ActivityStepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final step = kCrampsSteps.first;
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
                  TextSpan(text: step.title),
                  TextSpan(
                    text: '        1',
                    style: AppText.h3.copyWith(color: AppColors.primary400),
                  ),
                  TextSpan(
                    text: '/5',
                    style: AppText.h3.copyWith(color: AppColors.grey900),
                  ),
                ],
              ),
            ),
            Text(step.subtitle,
                style: AppText.body.copyWith(color: AppColors.grey500)),
            const SizedBox(height: 18),
            Expanded(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      step.imagePath,
                      width: double.infinity,
                      height: 330,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 170,
                        height: 170,
                        child: CircularProgressIndicator(
                          value: .22,
                          strokeWidth: 6,
                          backgroundColor: AppColors.grey200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary400),
                        ),
                      ),
                      Column(
                        children: [
                          Text('00:05',
                              style: AppText.h3
                                  .copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 22),
                          Text('00:24',
                              style: AppText.h6
                                  .copyWith(color: AppColors.grey600)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.skip_previous_rounded,
                      size: 34, color: AppColors.grey900),
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
                    child: const Icon(Icons.play_arrow_rounded,
                        color: AppColors.white, size: 36),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.skip_next_rounded,
                      size: 34, color: AppColors.grey900),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
