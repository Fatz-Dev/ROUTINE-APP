import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/services/hive_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(HiveService.instance);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier(this._repo) : super(_repo.get());
  final UserRepository _repo;

  Future<void> save(String name) async {
    final p = await _repo.createOrUpdate(name: name);
    state = p;
  }

  Future<void> completeOnboarding(String name) async {
    final p = await _repo.createOrUpdate(name: name, onboardingDone: true);
    state = p;
  }

  Future<void> markOnboardingDone() async {
    await _repo.markOnboardingDone();
    state = _repo.get();
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  final repo = ref.watch(userRepositoryProvider);
  return UserProfileNotifier(repo);
});
