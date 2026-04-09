import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/theme/theme.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
const _Bubble(
                      text: 'Hey, just checking in.', assistant: true),
                  const SizedBox(height: 10),
const _Bubble(
                      text: 'How are you feeling around your PMS days lately?',
                      assistant: true),
                  const SizedBox(height: 10),
                  const _Bubble(text: 'Cramps or body aches', assistant: false),
                  const SizedBox(height: 10),
                  const _Bubble(
                      text:
                          'Got it. Everyone feels this phase a little differently.',
                      assistant: true),
                  const SizedBox(height: 10),
                  const _Bubble(
                      text:
                          'Do you usually have trouble focusing or getting things done these days?',
                      assistant: true),
                  const SizedBox(height: 10),
                  const _Bubble(text: 'Yes, a lot', assistant: false),
                  const SizedBox(height: 10),
                  const _Bubble(
                      text: 'Here are a few gentle ways to stay balanced',
                      assistant: true),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 170,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        _SuggestionCard(
                            title: 'Drink water',
                            imagePath: 'moc/Chat Page-66.png'),
                        SizedBox(width: 12),
                        _SuggestionCard(
                            title: 'Move gently',
                            imagePath: 'moc/Chat Page-67.png'),
                        SizedBox(width: 12),
                        _SuggestionCard(
                            title: 'Take a pause',
                            imagePath: 'moc/Chat Page-69.png'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _Bubble(
                      text: 'Wanna learn a bit more about this?',
                      assistant: true),
                  const SizedBox(height: 10),
                  const _Bubble(text: "Yeah, I'm curious", assistant: false),
                  const SizedBox(height: 10),
                  const _Bubble(
                      text: "Here's a full article. give it a read!",
                      assistant: true),
                  const SizedBox(height: 14),
                  _ArticleCard(onTap: () => context.go('/self-care/article')),
                  const SizedBox(height: 10),
                  const _Bubble(text: 'I Read it', assistant: false),
                  const SizedBox(height: 10),
                  const _Bubble(
                      text:
                          "I've preselected your symptoms. Are these correct, or do you have others to add?",
                      assistant: true),
                  const SizedBox(height: 10),
                  const _Bubble(text: 'Yes, that works!', assistant: false),
                  const SizedBox(height: 12),
                  _SymptomsCard(onTap: () => context.go('/symptoms')),
                  const SizedBox(height: 20),
                  Center(
                      child: Text('Wed, Apr 9',
                          style: AppText.caption
                              .copyWith(color: AppColors.grey500))),
                  const SizedBox(height: 12),
                  const _Bubble(
                      text:
                          "We know it's not easy to get through days like this. you're not alone",
                      assistant: true),
                  const SizedBox(height: 12),
                  _CalendarCard(onTap: () => context.go('/ai/appointment')),
                  const SizedBox(height: 12),
                  const _Bubble(
                      text:
                          "Based on your calendar, your PMS days are from the 13th to the 17th, and you already have a doctor's appointment on the 18th.",
                      assistant: true),
                  const SizedBox(height: 10),
                  const _Bubble(
                      text: 'I suggest the 19th instead. how does that sound?',
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
        Text('Your Assistant',
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
                    const Text('Never-Ending\nCramps', style: AppText.h5),
                    const SizedBox(height: 8),
                    Text("When period pain isn't typical.",
                        style: AppText.body.copyWith(color: AppColors.grey500)),
                  ]),
            ),
          ]),
          const SizedBox(height: 10),
          Text(
            'Learn why cramps linger and when to seek help. Perry also shares tips to ease discomfort.',
            style: AppText.body.copyWith(color: AppColors.grey700),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Icon(Icons.schedule_outlined,
                size: 16, color: AppColors.grey500),
            const SizedBox(width: 4),
            Text('4 min',
                style: AppText.caption.copyWith(color: AppColors.grey500)),
            const Spacer(),
            Text('Read Now',
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
            Text('Your Symptoms Are All Set',
                style: AppText.label.copyWith(fontWeight: FontWeight.w700)),
          ]),
          const Divider(height: 24),
          Wrap(spacing: 10, runSpacing: 10, children: const [
            _Chip(label: 'Cramps'),
            _Chip(label: 'Headache'),
            _Chip(label: 'Sad'),
          ]),
          const SizedBox(height: 18),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Open symptoms',
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
              children: const [
                _MiniButton(icon: Icons.chevron_left_rounded),
                Text('Sep', style: AppText.h6),
                _MiniButton(icon: Icons.chevron_right_rounded),
              ]),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su']
                .map((e) => SizedBox(
                    width: 28, child: Text(e, textAlign: TextAlign.center)))
                .toList(),
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
              _legend('PMS day Conflict'),
              const SizedBox(height: 6),
              _legend('Doctor visit Conflict'),
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
            Text('Ask anything...',
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
