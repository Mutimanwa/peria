import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class ActivityTimerScreen extends StatefulWidget {
  const ActivityTimerScreen({super.key});

  @override
  State<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends State<ActivityTimerScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  TextSpan(text: l10n.selfCareExerciseJumpingJacks),
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
            Text(l10n.selfCareFullBodyCardio,
                style: AppText.body.copyWith(color: AppColors.grey500)),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'moc/Strength details.png',
                width: double.infinity,
                height: 330,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox(
                        width: 180,
                        height: 180,
                        child: CircularProgressIndicator(
                          value: .35,
                          strokeWidth: 5,
                          backgroundColor: AppColors.grey200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary400),
                        ),
                      ),
                      Text('02:00',
                          style:
                              AppText.h3.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text('04:00',
                      style: AppText.h5.copyWith(color: AppColors.grey700)),
                  const Spacer(),
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
                        onTap: () => _showPauseDialog(context),
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.grey900,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.pause_rounded,
                              color: AppColors.white, size: 36),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () =>
                            context.go('/self-care/congratulations'),
                        icon: const Icon(Icons.skip_next_rounded,
                            size: 34, color: AppColors.grey900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPauseDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          contentPadding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('moc/Chat Page-68.png',
                  width: 86, height: 86, fit: BoxFit.cover),
              const SizedBox(height: 12),
              Text(l10n.selfCareWait, style: AppText.h4),
              const SizedBox(height: 6),
              Text(
                l10n.selfCareOnlyMinutesLeft(2),
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        this.context.go('/self-care/congratulations');
                      },
                      child: Text(l10n.selfCareQuit,
                          style:
                              AppText.label.copyWith(color: AppColors.grey700)),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.grey900,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(l10n.selfCareKeepGoing,
                            style:
                                AppText.label.copyWith(color: AppColors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
