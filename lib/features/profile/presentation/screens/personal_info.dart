import 'package:flutter/material.dart';
import 'package:perla_app/core/theme/app_colors.dart';
import 'package:perla_app/shared/widgets/common_widgets.dart';
import 'package:perla_app/shared/widgets/profile_widgets.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  bool _editing = false;

  @override
  Widget build(BuildContext context) {
    return SimplePage(
      title: 'Personal Information',
      child: SingleChildScrollView(
        child: Column(

          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      AssetImage('assets/images/onboarding/Avatar-21.png'),
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
            const FieldLabel('Full Name'),
            const InfoField(text: 'Sara Hoseini'),
            const SizedBox(height: 18),
            const FieldLabel('Email Address'),
            const InfoField(text: 'Sarahoseini@gmail.com'),
            const SizedBox(height: 18),
            const FieldLabel('Date of Birth'),
            const InfoField(
                text: '17.08.1998', trailing: Icons.calendar_today_outlined),
            const SizedBox(height: 18),
            const FieldLabel('My Goal'),
            const InfoField(
                text: '2 Selected', trailing: Icons.keyboard_arrow_down_rounded),
            if (_editing) ...[
              const SizedBox(height: 40),
              PrimaryButton(
                label: 'Save Changes',
                onPressed: () => setState(() => _editing = false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
