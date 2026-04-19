import '../models/user_profile.dart';
import '../services/hive_service.dart';

class UserRepository {
  UserRepository(this._hive);
  final HiveService _hive;

  static const _key = 'me';

  UserProfile? get() => _hive.profile.get(_key);

  Future<UserProfile> createOrUpdate({
    required String name,
    bool? onboardingDone,
  }) async {
    final existing = get();
    final now = DateTime.now();
    final profile = existing == null
        ? UserProfile(
            name: name,
            createdAt: now,
            lastActive: now,
            onboardingDone: onboardingDone ?? false,
          )
        : existing.copyWith(
            name: name,
            lastActive: now,
            onboardingDone: onboardingDone,
          );
    await _hive.profile.put(_key, profile);
    return profile;
  }

  Future<void> markOnboardingDone() async {
    final existing = get();
    if (existing == null) return;
    await _hive.profile
        .put(_key, existing.copyWith(onboardingDone: true, lastActive: DateTime.now()));
  }

  Future<void> touchLastActive() async {
    final existing = get();
    if (existing == null) return;
    await _hive.profile.put(_key, existing.copyWith(lastActive: DateTime.now()));
  }
}
