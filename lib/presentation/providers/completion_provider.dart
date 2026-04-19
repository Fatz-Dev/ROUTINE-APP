import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_utils.dart';
import '../../data/models/daily_completion.dart';
import '../../data/models/habit.dart';
import '../../data/models/user_streak.dart';
import '../../data/repositories/completion_repository.dart';
import '../../data/services/hive_service.dart';
import 'habit_provider.dart';

final completionRepositoryProvider = Provider<CompletionRepository>((ref) {
  final habitRepo = ref.watch(habitRepositoryProvider);
  return CompletionRepository(HiveService.instance, habitRepo);
});

/// State untuk presensi hari ini.
/// Menyimpan completion per habit agar bisa menghitung progress & status.
class TodayState {
  final List<Habit> allHabits;
  final Map<String, DailyCompletion> completions;

  const TodayState({required this.allHabits, required this.completions});

  bool isFullyDone(String habitId) {
    final c = completions[habitId];
    return c != null && c.isFullyCompleted;
  }

  double progressOf(String habitId) {
    final c = completions[habitId];
    if (c == null) return 0.0;
    return c.progressRatio;
  }

  int progressValueOf(String habitId) {
    return completions[habitId]?.progressValue ?? 0;
  }

  /// Habit yang belum fully completed (urut: yang sedang progress dulu, lalu belum mulai).
  List<Habit> get pending {
    final inProgress = <Habit>[];
    final notStarted = <Habit>[];
    for (final h in allHabits) {
      if (isFullyDone(h.id)) continue;
      if (completions.containsKey(h.id)) {
        inProgress.add(h);
      } else {
        notStarted.add(h);
      }
    }
    return [...inProgress, ...notStarted];
  }

  List<Habit> get done =>
      allHabits.where((h) => isFullyDone(h.id)).toList();

  int get total => allHabits.length;
  int get doneCount => done.length;
  double get progress => total == 0 ? 0 : doneCount / total;
  bool get allDone => total > 0 && doneCount == total;

  /// Habit yang di-featured (yang pertama di pending).
  Habit? get featured => pending.isEmpty ? null : pending.first;
}

final todayDateProvider = StateProvider<DateTime>((ref) => AppDateUtils.dateOnly(DateTime.now()));

class TodayNotifier extends StateNotifier<TodayState> {
  TodayNotifier(this._completionRepo, List<Habit> habits, this._currentDate)
      : super(_build(_completionRepo, habits, _currentDate));

  final CompletionRepository _completionRepo;
  final DateTime _currentDate;

  static TodayState _build(
      CompletionRepository repo, List<Habit> habits, DateTime date) {
    final completions = repo.getByDate(date);
    final map = <String, DailyCompletion>{};
    for (final c in completions) {
      map[c.habitId] = c;
    }
    return TodayState(allHabits: habits, completions: map);
  }

  void refresh(List<Habit> habits) {
    state = _build(_completionRepo, habits, _currentDate);
  }

  Future<DailyCompletion?> tap(String habitId) async {
    final c = await _completionRepo.tap(habitId: habitId, date: _currentDate);
    if (c != null) {
      final newMap = {...state.completions, habitId: c};
      state = TodayState(allHabits: state.allHabits, completions: newMap);
    }
    return c;
  }

  Future<void> undo(String habitId) async {
    await _completionRepo.undoTap(habitId: habitId, date: _currentDate);
    final updated = _completionRepo.getByKey(habitId, _currentDate);
    final newMap = {...state.completions};
    if (updated == null) {
      newMap.remove(habitId);
    } else {
      newMap[habitId] = updated;
    }
    state = TodayState(allHabits: state.allHabits, completions: newMap);
  }
}

final todayProvider = StateNotifierProvider<TodayNotifier, TodayState>((ref) {
  final repo = ref.watch(completionRepositoryProvider);
  final habits = ref.watch(habitListProvider);
  final date = ref.watch(todayDateProvider);
  final notifier = TodayNotifier(repo, habits, date);
  ref.listen(habitListProvider, (_, next) => notifier.refresh(next));
  return notifier;
});

final streakProvider = Provider<UserStreak>((ref) {
  final repo = ref.watch(completionRepositoryProvider);
  ref.watch(todayProvider);
  ref.watch(habitListProvider);
  return repo.calculateStreak();
});

final completionsHeatmapProvider = Provider<Map<String, int>>((ref) {
  final repo = ref.watch(completionRepositoryProvider);
  ref.watch(todayProvider);
  return repo.fullyCompletedCountByDate();
});

/// Provider untuk list presensi 1 bulan tertentu (yyyy-MM).
/// Menggunakan String key (yyyy-MM) agar lebih stabil sebagai family key.
final monthCompletionsProvider =
    Provider.family<List<DailyCompletion>, String>((ref, monthKey) {
  final repo = ref.watch(completionRepositoryProvider);
  // Re-fetch saat ada perubahan data hari ini (optimistik)
  ref.watch(todayProvider);
  
  final parts = monthKey.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  
  return repo.getByMonth(year, month);
});

final dateCompletionsProvider =
    Provider.family<List<DailyCompletion>, DateTime>((ref, date) {
  final repo = ref.watch(completionRepositoryProvider);
  ref.watch(todayProvider);
  return repo.getByDate(AppDateUtils.dateOnly(date));
});
