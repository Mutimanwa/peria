import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/core/storage/app_settings.dart';
import 'package:perla_app/core/storage/app_settings_provider.dart';
import 'package:perla_app/core/theme/theme.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'My Profile',
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 46,
            backgroundImage: AssetImage('assets/images/onboarding/Avatar-21.png'),
          ),
          const SizedBox(height: 16),
          const Text('Sara Hoseini', style: AppText.h3),
          const SizedBox(height: 4),
          Text('Sarahoseini@gmail.com', style: AppText.body.copyWith(color: AppColors.grey500)),
          const SizedBox(height: 28),
          const _SectionLabel('My Account'),
          _MenuGroup(items: [
            _MenuItemData('Personal Information', Icons.person_outline, () => context.go('/profile/personal-info')),
            _MenuItemData('Partner', Icons.favorite_border, () => context.go('/profile/partner')),
            _MenuItemData('Account & Security', Icons.shield_outlined, () => context.go('/profile/account-security')),
          ]),
          const SizedBox(height: 22),
          const _SectionLabel('App Setting'),
          _MenuGroup(items: [
            _MenuItemData('Settings', Icons.settings_outlined, () => context.go('/profile/settings')),
            _MenuItemData('Notifications', Icons.notifications_none_rounded, () => context.go('/profile/notifications')),
          ]),
          const SizedBox(height: 22),
          const _SectionLabel('Support & Legal'),
          _MenuGroup(items: [
            _MenuItemData('Help & Support', Icons.help_outline_rounded, () {}),
            _MenuItemData('Log out', Icons.logout_rounded, () {}, danger: true),
          ]),
        ],
      ),
    );
  }
}

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Personal Information',
      child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage('assets/images/onboarding/Avatar-21.png'),
              ),
              if (_editing)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: const Icon(Icons.edit_outlined, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          if (!_editing)
            SizedBox(
              width: 150,
              child: OutlineButton(
                label: 'Edit Profile',
                onPressed: () => setState(() => _editing = true),
              ),
            ),
          const SizedBox(height: 28),
          const _FieldLabel('Full Name'),
          const _InfoField(text: 'Sara Hoseini'),
          const SizedBox(height: 18),
          const _FieldLabel('Email Address'),
          const _InfoField(text: 'Sarahoseini@gmail.com'),
          const SizedBox(height: 18),
          const _FieldLabel('Date of Birth'),
          const _InfoField(text: '17.08.1998', trailing: Icons.calendar_today_outlined),
          const SizedBox(height: 18),
          const _FieldLabel('My Goal'),
          const _InfoField(text: '2 Selected', trailing: Icons.keyboard_arrow_down_rounded),
          if (_editing) ...[
            const SizedBox(height: 40),
            PrimaryButton(
              label: 'Save Changes',
              onPressed: () => setState(() => _editing = false),
            ),
          ],
        ],
      ),
    );
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    return _SimplePage(
      title: 'Settings',
      child: settingsState.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionLabel('Appearance'),
            _MenuGroup(items: [
              _MenuItemData('Theme', Icons.palette_outlined, () {}),
            ]),
            const SizedBox(height: 22),
            const _SectionLabel('Cycle Settings'),
            _MenuGroup(items: [
              _MenuItemData(
                'Period Length',
                Icons.water_drop_outlined,
                () => _showCycleLengthPicker(
                  context,
                  title: 'Period Length',
                  currentValue: settings.periodLengthDays,
                  min: 2,
                  max: 12,
                  onSelected: (value) => ref.read(appSettingsProvider.notifier).patch(
                        (current) => current.copyWith(periodLengthDays: value),
                      ),
                ),
                trailingText: '${settings.periodLengthDays} Days',
              ),
              _MenuItemData(
                'Cycle Length',
                Icons.calendar_month_outlined,
                () => _showCycleLengthPicker(
                  context,
                  title: 'Cycle Length',
                  currentValue: settings.cycleLengthDays,
                  min: 20,
                  max: 40,
                  onSelected: (value) => ref.read(appSettingsProvider.notifier).patch(
                        (current) => current.copyWith(cycleLengthDays: value),
                      ),
                ),
                trailingText: '${settings.cycleLengthDays} Days',
              ),
            ]),
            const SizedBox(height: 22),
            const _SectionLabel('Integrations & Sync'),
            _MenuGroup(items: [
              _MenuItemData('Connected Apps', Icons.all_inclusive_rounded, () {}),
            ]),
            const SizedBox(height: 22),
            const _SectionLabel('About'),
            _MenuGroup(items: [
              _MenuItemData('Privacy Policy', Icons.verified_user_outlined, () {}),
              _MenuItemData('App Version', Icons.info_outline_rounded, () {}, trailingText: '1.0.2'),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load settings')),
      ),
    );
  }
}

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    return _SimplePage(
      title: 'Notifications',
      child: settingsState.when(
        data: (settings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ToggleGroup(items: [
              _ToggleItemData(
                'Allow Notifications',
                settings.allowNotifications,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(allowNotifications: v),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            const _SectionLabel('Cycle Predictions'),
            _ToggleGroup(items: [
              _ToggleItemData(
                'Period Starting',
                settings.notifyPeriodStarting,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPeriodStarting: v),
                    ),
              ),
              _ToggleItemData(
                'Fertile Window',
                settings.notifyFertileWindow,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyFertileWindow: v),
                    ),
              ),
              _ToggleItemData(
                'Ovulation Day',
                settings.notifyOvulationDay,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyOvulationDay: v),
                    ),
              ),
            ]),
            const SizedBox(height: 28),
            const _SectionLabel('Reminders'),
            _ToggleGroup(items: [
              _ToggleItemData(
                'Log Symptoms',
                settings.remindLogSymptoms,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(remindLogSymptoms: v),
                    ),
              ),
              _ToggleItemData(
                'Partner Updates',
                settings.notifyPartnerUpdates,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(notifyPartnerUpdates: v),
                    ),
              ),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load notifications')),
      ),
    );
  }
}

class AccountSecurityScreen extends ConsumerWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(appSettingsProvider);
    return _SimplePage(
      title: 'Account & Security',
      child: settingsState.when(
        data: (settings) => Column(
          children: [
            const SizedBox(height: 6),
            Image.asset('assets/images/icons/security.png', width: 96, height: 96),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: _SectionLabel('Account')),
            _MenuGroup(items: [
              _MenuItemData('Email Address', Icons.email_outlined, () {}),
              _MenuItemData('Change Password', Icons.lock_outline_rounded, () {}),
            ]),
            const SizedBox(height: 22),
            const Align(alignment: Alignment.centerLeft, child: _SectionLabel('Security')),
            _ToggleGroup(items: [
              _ToggleItemData(
                'Two Factor Authentication',
                settings.twoFactorEnabled,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(twoFactorEnabled: v),
                    ),
              ),
              _ToggleItemData(
                'Face ID',
                settings.faceIdEnabled,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(faceIdEnabled: v),
                    ),
              ),
              _ToggleItemData(
                'Discreet Mode',
                settings.discreetModeEnabled,
                (v) => ref.read(appSettingsProvider.notifier).patch(
                      (current) => current.copyWith(discreetModeEnabled: v),
                    ),
              ),
            ]),
            const SizedBox(height: 22),
            _MenuGroup(items: [
              _MenuItemData('Delete Account', Icons.delete_outline_rounded, () {}, danger: true),
            ]),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load security settings')),
      ),
    );
  }
}

class PartnerScreen extends StatelessWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Partner',
      child: Column(
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('moc/Partner Pending Screen.png', height: 185, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          const Text('Connect with your partner', style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(
            'Securely share key cycle dates, predictions, and ovulation windows.',
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          PrimaryButton(label: 'Invite Partner', onPressed: () => context.go('/profile/partner/invite')),
          const SizedBox(height: 12),
          OutlineButton(label: 'Learn More', onPressed: () {}),
        ],
      ),
    );
  }
}

class InvitePartnerScreen extends StatefulWidget {
  const InvitePartnerScreen({super.key});

  @override
  State<InvitePartnerScreen> createState() => _InvitePartnerScreenState();
}

class _InvitePartnerScreenState extends State<InvitePartnerScreen> {
  final TextEditingController _email = TextEditingController(text: 'Samrad@gmail.com');

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Invite Partner',
      child: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset('moc/Invite Partner.png', height: 150),
          const SizedBox(height: 18),
          const Text('Invite your partner', style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            "We'll send a secure, private invitation link for your partner.",
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const _FieldLabel("Partner's Email Address"),
          TextField(
            controller: _email,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.grey100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Send Invitation',
            onPressed: () => _showInvitationDialog(context),
          ),
          const SizedBox(height: 12),
          OutlineButton(label: 'Share Link Manually', onPressed: () {}),
        ],
      ),
    );
  }

  void _showInvitationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.success, width: 2)),
              child: const Icon(Icons.check, color: AppColors.success, size: 36),
            ),
            const SizedBox(height: 18),
            const Text('Invitation Sent!', style: AppText.h4),
            const SizedBox(height: 8),
            Text(
              'Your partner has been sent an invitation to accept.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  this.context.go('/profile/partner/pending');
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey900, shape: const StadiumBorder()),
                child: Text('Got it', style: AppText.label.copyWith(color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerInvitationPendingScreen extends StatelessWidget {
  const PartnerInvitationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Partner',
      child: Column(
        children: [
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'moc/Partner Pending Screen (1).png',
              height: 185,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          const SizedBox(height: 24),
          const Text("You've Invited Your Partner!", style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            "We'll let you know when they accept.",
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(color: AppColors.grey900, shape: BoxShape.circle),
                  child: const Icon(Icons.person_add_alt_1_rounded, color: AppColors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Samrad@gmail.com', style: AppText.label.copyWith(fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF6C542), shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('Status: Pending Approval', style: AppText.body.copyWith(color: AppColors.grey600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(label: 'Resend Invitation', onPressed: () {}),
          const SizedBox(height: 12),
          OutlineButton(label: 'Cancel Invitation', onPressed: () => context.go('/profile/partner')),
        ],
      ),
    );
  }
}

class ConnectedPartnerScreen extends StatefulWidget {
  const ConnectedPartnerScreen({super.key});

  @override
  State<ConnectedPartnerScreen> createState() => _ConnectedPartnerScreenState();
}

class _ConnectedPartnerScreenState extends State<ConnectedPartnerScreen> {
  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Partner',
      child: Column(
        children: [
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset('moc/Partner Pending Screen (2).png', height: 185, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 24),
          const Text("You're connected with Reza!", style: AppText.h2, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
            'You can now manage your shared cycle data and insights below.',
            style: AppText.body.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(width: 32, height: 32, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Samrad@gmail.com', style: AppText.label.copyWith(fontWeight: FontWeight.w700)),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('Status: Connected', style: AppText.body.copyWith(color: AppColors.grey600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(label: 'Manage Sharing Settings', onPressed: () => context.go('/profile/partner/sharing')),
          const SizedBox(height: 12),
          OutlineButton(
            label: 'Disconnect Partner',
            onPressed: () => _showDisconnectDialog(context),
          ),
        ],
      ),
    );
  }

  void _showDisconnectDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('moc/Chat Page-68.png', width: 84, height: 84),
            const SizedBox(height: 14),
            const Text('Disconnect from Sam?', style: AppText.h4, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'This will immediately stop all data sharing.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.grey600),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel', style: AppText.label.copyWith(color: AppColors.grey700)))),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        this.context.go('/profile/partner');
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey900, shape: const StadiumBorder()),
                      child: Text('Disconnect', style: AppText.label.copyWith(color: AppColors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SharingSettingsScreen extends StatefulWidget {
  const SharingSettingsScreen({super.key});

  @override
  State<SharingSettingsScreen> createState() => _SharingSettingsScreenState();
}

class _SharingSettingsScreenState extends State<SharingSettingsScreen> {
  bool loggedSymptoms = true;
  bool moodEntries = true;

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Sharing Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Choose What to Share', style: AppText.h3),
          const SizedBox(height: 10),
          Text(
            'You can now manage your shared cycle data and insights below.',
            style: AppText.body.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 22),
          _ToggleGroup(items: [
            _ToggleItemData('Cycle Predictions', false, (_) {}),
            _ToggleItemData('Logged Symptoms', loggedSymptoms, (v) => setState(() => loggedSymptoms = v)),
            _ToggleItemData('Period Dates', false, (_) {}),
            _ToggleItemData('Mood Entries', moodEntries, (v) => setState(() => moodEntries = v)),
          ]),
          const Spacer(),
          PrimaryButton(label: 'Save Changes', onPressed: () => context.pop()),
        ],
      ),
    );
  }
}

class _SimplePage extends StatelessWidget {
  final String title;
  final Widget child;

  const _SimplePage({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showBack: true,
      onBack: () => context.pop(),
      showTitle: true,
      title: title,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 80, 22, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

Future<void> _showCycleLengthPicker(
  BuildContext context, {
  required String title,
  required int currentValue,
  required int min,
  required int max,
  required ValueChanged<int> onSelected,
}) async {
  final result = await showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppText.h4),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (int value = min; value <= max; value++)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: value == currentValue ? AppColors.primary50 : AppColors.grey100,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: value == currentValue ? AppColors.primary300 : AppColors.grey200,
                        ),
                      ),
                      child: Text(
                        '$value',
                        style: AppText.label.copyWith(
                          color: value == currentValue ? AppColors.primary400 : AppColors.grey800,
                        ),
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

  if (result != null) {
    onSelected(result);
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: AppText.caption.copyWith(color: AppColors.grey500, fontWeight: FontWeight.w700)),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppText.body.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}

class _InfoField extends StatelessWidget {
  final String text;
  final IconData? trailing;
  const _InfoField({required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(child: Text(text, style: AppText.body)),
          if (trailing != null) Icon(trailing, color: AppColors.grey500, size: 20),
        ],
      ),
    );
  }
}

class _MenuItemData {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingText;
  final bool danger;

  _MenuItemData(this.title, this.icon, this.onTap, {this.trailingText, this.danger = false});
}

class _MenuGroup extends StatelessWidget {
  final List<_MenuItemData> items;
  const _MenuGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.white.withOpacity(0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          size: 16,
                          color: item.danger ? const Color(0xFFFF6E6E) : AppColors.grey700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppText.body.copyWith(
                            color: item.danger ? const Color(0xFFFF6E6E) : AppColors.grey800,
                          ),
                        ),
                      ),
                      if (item.trailingText != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            item.trailingText!,
                            style: AppText.body.copyWith(color: AppColors.grey400),
                          ),
                        ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
                    ],
                  ),
                ),
              ),
              if (index != items.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }
}

class _ToggleItemData {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  _ToggleItemData(this.title, this.value, this.onChanged);
}

class _ToggleGroup extends StatelessWidget {
  final List<_ToggleItemData> items;
  const _ToggleGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.75),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_toggleIcon(item.title), size: 14, color: AppColors.grey500),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(item.title, style: AppText.body)),
                    Switch(
                      value: item.value,
                      onChanged: item.onChanged,
                      activeColor: AppColors.white,
                      activeTrackColor: const Color(0xFF4BE28C),
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.grey300,
                    ),
                  ],
                ),
              ),
              if (index != items.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  IconData _toggleIcon(String title) {
    if (title.contains('Cycle') || title.contains('Period')) return Icons.autorenew_rounded;
    if (title.contains('Logged') || title.contains('Log')) return Icons.add_circle_outline_rounded;
    if (title.contains('Mood')) return Icons.sentiment_satisfied_alt_outlined;
    if (title.contains('Face ID')) return Icons.fingerprint_rounded;
    if (title.contains('Two Factor')) return Icons.shield_outlined;
    if (title.contains('Partner')) return Icons.people_alt_outlined;
    if (title.contains('Ovulation')) return Icons.event_available_outlined;
    return Icons.radio_button_checked;
  }
}
