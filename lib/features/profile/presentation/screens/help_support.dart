import 'package:flutter/material.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // We can track the expanded state of each FAQ item.
  // Using a Set to allow multiple expanded items, or an int to only allow one.
  final Set<int> _expandedItems = {};

  final List<Map<String, String>> _faqs = [
    {
      "question": "How do I log my period and symptoms?",
      "answer":
          "You can log your period and symptoms directly from the Home screen by tapping the '+' button or interacting with the circular calendar."
    },
    {
      "question": "Is my health data secure?",
      "answer":
          "Yes, we prioritize your privacy. All your health data is stored securely and is never shared with third parties without your explicit consent."
    },
    {
      "question": "How does partner sharing work?",
      "answer":
          "You can invite a partner via the Settings menu. They will only see the data you explicitly choose to share with them."
    },
    {
      "question": "How can I customize notifications?",
      "answer":
          "Go to Profile > Settings > Notifications to customize alerts for your cycle, medications, and more."
    },
    {
      "question": "How do I delete my account?",
      "answer":
          "You can delete your account permanently by going to Profile > Settings > Security > Delete Account."
    },
    {
      "question": "How can I contact support?",
      "answer":
          "You can contact support directly from this page using the buttons below!"
    },
  ];

  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedItems.contains(index)) {
        _expandedItems.remove(index);
      } else {
        _expandedItems.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Note: Some translations might not exist yet, using AppLocalizations or fallback strings
    final l10n = AppLocalizations.of(context);
    final isDesktop = MediaQuery.of(context).size.width >=
        768; // For responsive layout safety

    return SimplePage(
      title: l10n.helpSupport,
      fallbackRoute: '/profile',
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric( vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors
                      .grey50, // Slightly lighter or same as AppColors.grey100
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Anything...",
                    hintStyle: AppText.body.copyWith(color: AppColors.grey400),
                    border: InputBorder.none,
                    prefixIcon: null,
                    suffixIcon:
                        const Icon(Icons.search, color: AppColors.grey400),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // FAQs
              ...List.generate(_faqs.length, (index) {
                final faq = _faqs[index];
                final isExpanded = _expandedItems.contains(index);

                return Column(
                  children: [
                    InkWell(
                      onTap: () => _toggleExpanded(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                faq['question']!,
                                style: AppText.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.grey900,
                                ),
                              ),
                            ),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: AppColors.grey400,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 16.0, right: 32.0),
                        child: Text(
                          faq['answer']!,
                          style:
                              AppText.body.copyWith(color: AppColors.grey600),
                        ),
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 48),

              // Contact Us Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.grey300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Contact Us",
                      style: AppText.label.copyWith(color: AppColors.grey400),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.grey300)),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ContactButton(
                    icon: Icons.phone_outlined,
                    onTap: () {},
                  ),
                  _ContactButton(
                    icon: Icons.email_outlined,
                    onTap: () {},
                  ),
                  _ContactButton(
                    icon: Icons.chat_bubble_outline,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Icon(icon, color: AppColors.grey900),
          ),
        ),
      ),
    );
  }
}
