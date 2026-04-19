import 'package:uuid/uuid.dart';

import '../../core/utils/date_utils.dart';
import '../models/daily_completion.dart';
import '../models/habit.dart';
import '../models/user_streak.dart';
import '../services/hive_service.dart';
import 'habit_repository.dart';

class CompletionRepository {
  CompletionRepository(this._hive, this._habitRepo);
  final HiveService _hive;
  final HabitRepository _habitRepo;
  final _uuid = const Uuid();

  String _key(String habitId, DateTime date) =>
      '${habitId}_${AppDateUtils.dateKey(date)}';

  DailyCompletion? getByKey(String habitId, DateTime date) {
    return _hive.completions.get(_key(habitId, date));
  }

  /// Cek apakah habit sudah **fully completed** hari ini.
  bool isFullyCompletedOn(String habitId, DateTime date, {Habit? habit}) {
    final completion = getByKey(habitId, date);
    if (completion == null) return false;
    return completion.isFullyCompleted;
  }

  /// Tap fingerprint untuk habit:
  /// - Binary: buat record (sekali per hari, tidak bertambah).
  /// - Target: buat record jika belum, atau naikkan progressValue.
  /// Return null jika habit sudah fully completed hari ini.
  Future<DailyCompletion?> tap({
    required String habitId,
    DateTime? date,
  }) async {
    final habit = _habitRepo.getById(habitId);
    if (habit == null) return null;

    final d = date ?? DateTime.now();
    final key = _key(habitId, d);
    final existing = _hive.completions.get(key);

    if (habit.hasTarget && habit.targetValue != null) {
      // Target-based
      if (existing == null) {
        final completion = DailyCompletion(
          id: _uuid.v4(),
          habitId: habitId,
          dateKey: AppDateUtils.dateKey(d),
          completionDate: AppDateUtils.dateOnly(d),
          completedAt: DateTime.now(),
          progressValue: habit.targetValue!,
          targetSnapshot: habit.targetValue,
        );
        await _hive.completions.put(key, completion);
        return completion;
      } else {
        if (existing.isFullyCompleted) return null;
        existing.progressValue = habit.targetValue!;
        existing.completedAt = DateTime.now();
        await _hive.completions.put(key, existing);
        return existing;
      }
    } else {
      // Binary
      if (existing != null) return null;
      final completion = DailyCompletion(
        id: _uuid.v4(),
        habitId: habitId,
        dateKey: AppDateUtils.dateKey(d),
        completionDate: AppDateUtils.dateOnly(d),
        completedAt: DateTime.now(),
        progressValue: 1,
        targetSnapshot: null,
      );
      await _hive.completions.put(key, completion);
      return completion;
    }
  }

  /// Batalkan presensi terakhir (untuk Undo).
  /// Binary: hapus record.
  /// Target: kurangi progressValue atau hapus jika jadi 0.
  Future<void> undoTap({
    required String habitId,
    DateTime? date,
  }) async {
    final habit = _habitRepo.getById(habitId);
    if (habit == null) return;
    final d = date ?? DateTime.now();
    final key = _key(habitId, d);
    final existing = _hive.completions.get(key);
    if (existing == null) return;

    if (habit.hasTarget) {
      existing.progressValue -= habit.targetValue!;
      if (existing.progressValue <= 0) {
        await _hive.completions.delete(key);
      } else {
        await _hive.completions.put(key, existing);
      }
    } else {
      await _hive.completions.delete(key);
    }
  }

  /// Semua completion untuk tanggal tertentu.
  List<DailyCompletion> getByDate(DateTime date) {
    final key = AppDateUtils.dateKey(date);
    return _hive.completions.values.where((c) => c.dateKey == key).toList();
  }

  List<DailyCompletion> getInRange(DateTime start, DateTime end) {
    final s = AppDateUtils.dateOnly(start);
    final e = AppDateUtils.dateOnly(end);
    return _hive.completions.values
        .where((c) =>
            !c.completionDate.isBefore(s) && !c.completionDate.isAfter(e))
        .toList();
  }

  List<DailyCompletion> getByMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);
    return getInRange(start, end);
  }

  /// Map dateKey -> jumlah habit yang FULLY completed pada hari itu.
  Map<String, int> fullyCompletedCountByDate({DateTime? from, DateTime? to}) {
    final map = <String, int>{};
    Iterable<DailyCompletion> source = _hive.completions.values;
    if (from != null && to != null) {
      final s = AppDateUtils.dateOnly(from);
      final e = AppDateUtils.dateOnly(to);
      source = source.where((c) =>
          !c.completionDate.isBefore(s) && !c.completionDate.isAfter(e));
    }
    for (final c in source) {
      if (!c.isFullyCompleted) continue;
      map[c.dateKey] = (map[c.dateKey] ?? 0) + 1;
    }
    return map;
  }

  /// Hitung streak berdasarkan hari "perfect" (semua habit aktif fully selesai).
  UserStreak calculateStreak() {
    final habits = _habitRepo.getAll();
    if (habits.isEmpty) return UserStreak.empty();

    final totalHabits = habits.length;
    // Defensive check for potential null items in Hive box
    final all = _hive.completions.values.whereType<DailyCompletion>().toList();
    final totalCompletions = all.where((c) => c.isFullyCompleted).length;

    final byDate = <String, int>{};
    for (final c in all) {
      if (!c.isFullyCompleted) continue;
      byDate[c.dateKey] = (byDate[c.dateKey] ?? 0) + 1;
    }

    final totalActiveDays = byDate.keys.length;

    final perfectDates = <DateTime>[];
    for (final entry in byDate.entries) {
      if (entry.value >= totalHabits) {
        final parts = entry.key.split('-');
        perfectDates.add(DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        ));
      }
    }
    perfectDates.sort();

    int longest = 0;
    int run = 0;
    DateTime? prev;
    for (final d in perfectDates) {
      if (prev != null && d.difference(prev).inDays == 1) {
        run++;
      } else {
        run = 1;
      }
      if (run > longest) longest = run;
      prev = d;
    }

    int current = 0;
    final today = AppDateUtils.dateOnly(DateTime.now());
    final perfectSet = perfectDates.map((d) => AppDateUtils.dateKey(d)).toSet();

    var cursor = today;
    if (!perfectSet.contains(AppDateUtils.dateKey(cursor))) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    while (perfectSet.contains(AppDateUtils.dateKey(cursor))) {
      current++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    DateTime? lastDate;
    if (all.isNotEmpty) {
      // Sort with defensive null check on completedAt just in case
      final validCompletions = all.where((c) => c != null).toList();
      if (validCompletions.isNotEmpty) {
        validCompletions.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        lastDate = validCompletions.first.completedAt;
      }
    }

    return UserStreak(
      currentStreak: current,
      longestStreak: longest,
      lastCompletedDate: lastDate,
      totalCompletions: totalCompletions,
      totalActiveDays: totalActiveDays,
    );
  }
}
