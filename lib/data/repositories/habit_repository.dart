import 'package:uuid/uuid.dart';

import '../models/habit.dart';
import '../services/hive_service.dart';

class HabitRepository {
  HabitRepository(this._hive);
  final HiveService _hive;
  final _uuid = const Uuid();

  List<Habit> getAll() {
    final list = _hive.habits.values.where((h) => h.isActive).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list;
  }

  Habit? getById(String id) => _hive.habits.get(id);

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
    final now = DateTime.now();
    final habit = Habit(
      id: _uuid.v4(),
      name: name,
      iconKey: iconKey,
      colorIndex: colorIndex,
      category: category,
      description: description,
      hasTarget: hasTarget,
      targetValue: targetValue,
      targetUnit: targetUnit,
      incrementStep: incrementStep,
      createdAt: now,
      updatedAt: now,
    );
    await _hive.habits.put(habit.id, habit);
    return habit;
  }

  Future<void> update(Habit habit) async {
    await _hive.habits.put(habit.id, habit.copyWith(updatedAt: DateTime.now()));
  }

  Future<void> softDelete(String id) async {
    final habit = _hive.habits.get(id);
    if (habit == null) return;
    await _hive.habits.put(id, habit.copyWith(isActive: false));
  }

  Future<void> hardDelete(String id) async {
    await _hive.habits.delete(id);
  }
}
