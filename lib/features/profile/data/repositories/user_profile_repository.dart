import 'package:flutter/foundation.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/profile/data/models/user_profile.dart';

class UserProfileRepository {
  UserProfileRepository({
    UserRepository? userRepository,
  }) : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[UserProfileRepository] $message');
    }
  }

  Future<UserProfile> load() async {
    _log('loading user profile');
    final snap = await _userRepository.getUserProfile();
    final data = snap.data();
    _log('user profile load completed exists=${data != null}');
    if (data == null) return const UserProfile();
    return UserProfile.fromJson(data);
  }

  Future<void> save(UserProfile profile) async {
    _log('saving user profile');
    await _userRepository.saveUserProfile(userData: profile.toJson());
    _log('user profile saved');
  }
}
