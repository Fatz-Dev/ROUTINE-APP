import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/habit.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/services/hive_service.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(HiveService.instance);
});

class HabitListNotifier extends StateNotifier<List<Habit>> {
  HabitListNotifier(this._repo) : super(_repo.getAll());
  final HabitRepository _repo;

  void refresh() => state = _repo.getAll();

  Future<Habit> create({
    required String name,
    required String iconKey,
    required int colorIndex,
    required String category,
    String? description,
    bool hasTarget = false,
    int? targetValue,
    String? targetUnit,
    int incrementStep = 1,
  }) async {
    final h = await _repo.create(
      name: name,
      iconKey: iconKey,
      colorIndex: colorIndex,
      category: category,
      description: description,
      hasTarget: hasTarget,
      targetValue: targetValue,
      targetUnit: targetUnit,
      incrementStep: incrementStep,
    );
    refresh();
    return h;
  }

  Future<void> update(Habit habit) async {
    await _repo.update(habit);
    refresh();
  }

  Future<void> delete(String id) async {
    await _repo.softDelete(id);
    refresh();
  }
}

final habitListProvider =
    StateNotifierProvider<HabitListNotifier, List<Habit>>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return HabitListNotifier(repo);
});
