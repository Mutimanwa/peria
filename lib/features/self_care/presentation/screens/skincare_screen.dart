import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/self_care/presentation/screens/self_care_data.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class SkincareScreen extends StatelessWidget {
  const SkincareScreen({super.key});

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
                  TextSpan(text: kSkinCareSteps[1].title),
                  TextSpan(
                    text: '        2',
                    style: AppText.h3.copyWith(color: AppColors.primary400),
                  ),
                  TextSpan(
                    text: '/5',
                    style: AppText.h3.copyWith(color: AppColors.grey900),
                  ),
                ],
              ),
            ),
            Text(kSkinCareSteps[1].subtitle,
                style: AppText.body.copyWith(color: AppColors.grey500)),
            const SizedBox(height: 14),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      kSkinCareSteps[1].imagePath,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text('8', style: AppText.h2),
                        Text('times',
                            style: AppText.body
                                .copyWith(color: AppColors.grey500)),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFEEF4), Color(0xFFF4E9FC)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: kSkinCareSteps.map((step) {
                              final selected = step == kSkinCareSteps[1];
                              return Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Container(
                                    height: 54,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.primary400
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Image.asset(step.imagePath,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('previous',
                                  style: AppText.body
                                      .copyWith(color: AppColors.grey800)),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.go('/self-care/congratulations'),
                              child: Text('Next',
                                  style: AppText.body
                                      .copyWith(color: AppColors.grey900)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
