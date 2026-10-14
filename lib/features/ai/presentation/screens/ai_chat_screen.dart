import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AiHeader(onBack: () => context.pop()),
                  const SizedBox(height: 20),
                  _Bubble(
                      text: l10n.aiChatCheckingIn, assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(
                      text: l10n.aiChatPmsQuestion,
                      assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(text: l10n.aiChatCrampsOrAches, assistant: false),
                  const SizedBox(height: 10),
                  _Bubble(
                      text:
                          l10n.aiChatPhaseVariation,
                      assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(
                      text:
                          l10n.aiChatFocusQuestion,
                      assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(text: l10n.aiChatYesALot, assistant: false),
                  const SizedBox(height: 10),
                  _Bubble(
                      text: l10n.aiChatGentleSuggestions,
                      assistant: true),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _SuggestionCard(
                            title: l10n.aiSuggestionDrinkWater,
                            imagePath: 'moc/Chat Page-66.png'),
                        SizedBox(width: 12),
                        _SuggestionCard(
                            title: l10n.aiSuggestionMoveGently,
                            imagePath: 'moc/Chat Page-67.png'),
                        SizedBox(width: 12),
                        _SuggestionCard(
                            title: l10n.aiSuggestionTakePause,
                            imagePath: 'moc/Chat Page-69.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Bubble(
                      text: l10n.aiChatLearnMore,
                      assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(text: l10n.aiChatImCurious, assistant: false),
                  const SizedBox(height: 10),
                  _Bubble(
                      text: l10n.aiChatArticlePrompt,
                      assistant: true),
                  const SizedBox(height: 14),
                  _ArticleCard(onTap: () => context.go('/self-care/article')),
                  const SizedBox(height: 10),
                  _Bubble(text: l10n.aiChatIReadIt, assistant: false),
                  const SizedBox(height: 10),
                  _Bubble(
                      text:
                          l10n.aiChatSymptomsPrompt,
                      assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(text: l10n.aiChatSymptomsConfirmed, assistant: false),
                  const SizedBox(height: 12),
                  _SymptomsCard(onTap: () => context.go('/symptoms')),
                  const SizedBox(height: 20),
                  Center(
                      child: Text(DateFormat.MMMEd(locale).format(DateTime(2025, 4, 9)),
                          style: AppText.caption
                              .copyWith(color: AppColors.grey500))),
                  const SizedBox(height: 12),
                  _Bubble(
                      text:
                          l10n.aiChatAfterPmsSupport,
                      assistant: true),
                  const SizedBox(height: 12),
                  _CalendarCard(onTap: () => context.go('/ai/appointment')),
                  const SizedBox(height: 12),
                  _Bubble(
                      text:
                          l10n.aiChatCalendarPmsDoctor,
                      assistant: true),
                  const SizedBox(height: 10),
                  _Bubble(
                      text: l10n.aiChatSuggestDate,
                      assistant: true),
                ],
              ),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 24,
            child: _Composer(onVoiceTap: () => context.go('/ai/voice')),
          ),
        ],
      ),
    );
  }
}

class _AiHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _AiHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: onBack,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200)),
          child: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      const SizedBox(width: 12),
      const CircleAvatar(
          radius: 21,
          backgroundImage:
              AssetImage('assets/images/onboarding/Avatar-24.png')),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Perry', style: AppText.h6.copyWith(fontWeight: FontWeight.w700)),
        Text(AppLocalizations.of(context).aiChatAssistantLabel,
            style: AppText.caption.copyWith(color: AppColors.grey500)),
      ]),
    ]);
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool assistant;
  const _Bubble({required this.text, required this.assistant});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: assistant ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 285),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: assistant ? const Color(0xFFF5F2F3) : const Color(0xFFFFE4EA),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(text,
            style:
                AppText.body.copyWith(fontSize: 15, color: AppColors.grey800)),
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  const _SuggestionCard({required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.grey200)),
      child: Column(children: [
        Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(imagePath,
                    fit: BoxFit.cover, width: double.infinity))),
        const SizedBox(height: 10),
        Text(title, style: AppText.h6, textAlign: TextAlign.center),
      ]),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ArticleCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset('moc/Article.png',
                  width: 118, height: 118, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.aiChatArticleTitle, style: AppText.h5),
                    const SizedBox(height: 8),
                    Text(l10n.aiChatArticleSubtitle,
                        style: AppText.body.copyWith(color: AppColors.grey500)),
                  ]),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            l10n.aiChatArticleDescription,
            style: AppText.body.copyWith(color: AppColors.grey700),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.schedule_outlined,
                size: 16, color: AppColors.grey500),
            const SizedBox(width: 4),
            Text(l10n.selfCareMinutesRead(4),
                style: AppText.caption.copyWith(color: AppColors.grey500)),
            const Spacer(),
            Text(l10n.aiChatReadNow,
                style: AppText.label.copyWith(fontWeight: FontWeight.w700)),
          ]),
        ]),
      ),
    );
  }
}

class _SymptomsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _SymptomsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.favorite_border, color: AppColors.primary400),
            const SizedBox(width: 8),
            Text(l10n.aiChatSetSymptomsTitle,
                style: AppText.label.copyWith(fontWeight: FontWeight.w700)),
          ]),
          const Divider(height: 24),
          Wrap(spacing: 10, runSpacing: 10, children: [
            _Chip(label: l10n.aiChatSymptomCramps),
            _Chip(label: l10n.aiChatSymptomHeadache),
            _Chip(label: l10n.moodSad),
          ]),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: Text(l10n.aiChatOpenSymptoms,
                style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
          ),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: const Color(0xFFFFEDF2),
          borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: AppText.label.copyWith(
              color: AppColors.primary400, fontWeight: FontWeight.w700)),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  final VoidCallback onTap;
  const _CalendarCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _MiniButton(icon: Icons.chevron_left_rounded),
                Text(DateFormat.MMM(locale).format(DateTime(2025, 9)),
                    style: AppText.h6),
                const _MiniButton(icon: Icons.chevron_right_rounded),
              ]),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var day = 1; day <= 7; day++)
                SizedBox(
                  width: 28,
                  child: Text(
                    DateFormat.E(locale)
                        .format(DateTime(2025, 9, day))
                        .toLowerCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AppText.caption,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in [
                8,
                9,
                10,
                11,
                12,
                13,
                14,
                15,
                16,
                17,
                18,
                19,
                20,
                21
              ])
                _Day(
                    label: '$d',
                    selected: d == 9,
                    warning: d >= 13 && d <= 18,
                    dotted: d == 18),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFFEFF3),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _legend(l10n.aiChatPmsConflict),
              const SizedBox(height: 6),
              _legend(l10n.aiChatDoctorVisitConflict),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _legend(String text) {
    return Row(children: [
      const Icon(Icons.circle, size: 8, color: AppColors.primary300),
      const SizedBox(width: 8),
      Text(text, style: AppText.body.copyWith(color: AppColors.primary700)),
    ]);
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  const _MiniButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey200)),
      child: Icon(icon, size: 18),
    );
  }
}

class _Day extends StatelessWidget {
  final String label;
  final bool selected;
  final bool warning;
  final bool dotted;
  const _Day(
      {required this.label,
      this.selected = false,
      this.warning = false,
      this.dotted = false});

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.grey900
        : warning
            ? const Color(0xFFFFF2DA)
            : Colors.transparent;
    final color = selected
        ? AppColors.white
        : warning
            ? const Color(0xFFF0A22E)
            : AppColors.grey800;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: dotted ? Border.all(color: AppColors.primary300) : null,
      ),
      alignment: Alignment.center,
      child: Text(label,
          style: AppText.caption
              .copyWith(color: color, fontWeight: FontWeight.w700)),
    );
  }
}

class _Composer extends StatelessWidget {
  final VoidCallback onVoiceTap;
  const _Composer({required this.onVoiceTap});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: const Color(0xFFF5F2F3),
              borderRadius: BorderRadius.circular(26)),
          child: Row(children: [
            Text(AppLocalizations.of(context).aiChatAskAnything,
                style: AppText.body.copyWith(color: AppColors.grey400)),
            const Spacer(),
            const Icon(Icons.add_box_outlined, color: AppColors.grey500),
          ]),
        ),
      ),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: onVoiceTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
              color: AppColors.grey900, shape: BoxShape.circle),
          child: const Icon(Icons.mic_none_rounded, color: AppColors.white),
        ),
      ),
    ]);
  }
}
