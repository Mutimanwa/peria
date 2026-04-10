import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class CrampsReliefScreen extends StatelessWidget {
  const CrampsReliefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          child: SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Cramps Relief',
                    style: AppText.h3,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        // ignore: prefer_const_constructors
                        child: Icon(Icons.local_hospital,
                            size: 80, color: AppColors.primary400),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '7 simple exercises to relieve menstrual cramps.',
                        style: AppText.body,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Start Exercises',
                        onPressed: () =>
                            context.go('/self-care/activity-detail'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
