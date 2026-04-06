import 'dart:convert';

import 'package:perla_app/features/profile/data/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileRepository {
  static const _profileKey = 'profile.user_profile.v1';

  Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null || raw.trim().isEmpty) return const UserProfile();
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }
}

