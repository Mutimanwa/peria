import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/profile/data/models/user_profile.dart';
import 'package:perla_app/features/profile/data/repositories/user_profile_repository.dart';

final profileUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(
    userRepository: ref.read(profileUserRepositoryProvider),
  );
});

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile>>((ref) {
  final notifier = UserProfileNotifier(ref.read(userProfileRepositoryProvider));
  notifier.load();
  return notifier;
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  UserProfileNotifier(this._repository) : super(const AsyncValue.loading());

  final UserProfileRepository _repository;

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.load);
  }

  Future<void> update(UserProfile profile) async {
    state = AsyncValue.data(profile);
    await _repository.save(profile);
  }

  Future<void> patch(UserProfile Function(UserProfile current) builder) async {
    final current = state.value ?? const UserProfile();
    final next = builder(current);
    await update(next);
  }
}
