import 'package:hive/hive.dart';
import 'package:perla_app/core/storage/hive_boxes.dart';
import 'package:perla_app/features/profile/data/models/user_profile.dart';

class UserProfileRepository {
  Future<UserProfile> load() async {
    final box = Hive.box<UserProfile>(HiveBoxes.userProfile);
    return box.get(0) ?? const UserProfile();
  }

  Future<void> save(UserProfile profile) async {
    final box = Hive.box<UserProfile>(HiveBoxes.userProfile);
    await box.put(0, profile);
  }
}
