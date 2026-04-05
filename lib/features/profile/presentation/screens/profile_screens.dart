import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel('Appearance'),
          _MenuGroup(items: [
            _MenuItemData('Theme', Icons.palette_outlined, () {}),
          ]),
          const SizedBox(height: 22),
          const _SectionLabel('Cycle Settings'),
          _MenuGroup(items: [
            _MenuItemData('Period Length', Icons.water_drop_outlined, () {}, trailingText: '7 Days'),
            _MenuItemData('Cycle Length', Icons.calendar_month_outlined, () {}, trailingText: '28 Days'),
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
    );
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool allowAll = false;
  bool fertileWindow = true;
  bool partnerUpdates = true;

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Notifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToggleGroup(items: [
            _ToggleItemData('Allow Notifications', allowAll, (v) => setState(() => allowAll = v)),
          ]),
          const SizedBox(height: 28),
          const _SectionLabel('Cycle Predictions'),
          _ToggleGroup(items: [
            _ToggleItemData('Period Starting', false, (_) {}),
            _ToggleItemData('Fertile Window', fertileWindow, (v) => setState(() => fertileWindow = v)),
            _ToggleItemData('Ovulation Day', false, (_) {}),
          ]),
          const SizedBox(height: 28),
          const _SectionLabel('Reminders'),
          _ToggleGroup(items: [
            _ToggleItemData('Log Symptoms', false, (_) {}),
            _ToggleItemData('Partner Updates', partnerUpdates, (v) => setState(() => partnerUpdates = v)),
          ]),
        ],
      ),
    );
  }
}

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool twoFactor = false;
  bool faceId = true;

  @override
  Widget build(BuildContext context) {
    return _SimplePage(
      title: 'Account & Security',
      child: Column(
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
            _ToggleItemData('Two Factor Authentication', twoFactor, (v) => setState(() => twoFactor = v)),
            _ToggleItemData('Face ID', faceId, (v) => setState(() => faceId = v)),
          ]),
          const SizedBox(height: 22),
          _MenuGroup(items: [
            _MenuItemData('Delete Account', Icons.delete_outline_rounded, () {}, danger: true),
          ]),
        ],
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
                  this.context.go('/profile/partner/connected');
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
              ListTile(
                onTap: item.onTap,
                leading: Icon(item.icon, color: item.danger ? const Color(0xFFFF6E6E) : AppColors.grey700),
                title: Text(
                  item.title,
                  style: AppText.body.copyWith(color: item.danger ? const Color(0xFFFF6E6E) : AppColors.grey800),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.trailingText != null)
                      Text(item.trailingText!, style: AppText.body.copyWith(color: AppColors.grey400)),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.grey400),
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
              SwitchListTile(
                value: item.value,
                onChanged: item.onChanged,
                title: Text(item.title, style: AppText.body),
                activeColor: AppColors.white,
                activeTrackColor: const Color(0xFF4BE28C),
                inactiveThumbColor: AppColors.white,
                inactiveTrackColor: AppColors.grey300,
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
