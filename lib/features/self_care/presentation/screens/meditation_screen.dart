import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/features/self_care/presentation/screens/self_care_data.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 62, 22, 30),
        child: Column(
          children: [
            const Text('Sleep Meditation', style: AppText.h5),
            const SizedBox(height: 18),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                image: const DecorationImage(
                  image: AssetImage('moc/Sleep Meditation.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.white.withOpacity(0.96),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Relax', style: AppText.h3),
                          Text(
                            'Peace and relaxation',
                            style:
                                AppText.body.copyWith(color: AppColors.grey600),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/self-care/timer'),
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: AppColors.grey900,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: AppColors.white, size: 34),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...kSleepTracks.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            entry.value['image']!,
                            width: 62,
                            height: 62,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.value['title']!,
                                  style: AppText.label
                                      .copyWith(fontWeight: FontWeight.w700)),
                              Text(
                                entry.value['subtitle']!,
                                style: AppText.body
                                    .copyWith(color: AppColors.grey500),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => context.go('/self-care/timer'),
                          icon: const Icon(Icons.play_circle_fill_rounded,
                              color: AppColors.grey900),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
