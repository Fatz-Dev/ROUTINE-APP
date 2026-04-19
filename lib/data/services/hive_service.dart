import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/daily_completion.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';

/// Singleton service untuk manage Hive boxes.
class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  static const String habitsBox = 'habits';
  static const String completionsBox = 'completions';
  static const String profileBox = 'profile';
  static const String settingsBox = 'settings';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Register adapters (manual, tanpa build_runner)
    if (!Hive.isAdapterRegistered(11)) Hive.registerAdapter(HabitAdapter());
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(DailyCompletionAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(UserProfileAdapter());

    await Future.wait([
      Hive.openBox<Habit>(habitsBox),
      Hive.openBox<DailyCompletion>(completionsBox),
      Hive.openBox<UserProfile>(profileBox),
      Hive.openBox(settingsBox),
    ]);

    _initialized = true;
  }

  Box<Habit> get habits => Hive.box<Habit>(habitsBox);
  Box<DailyCompletion> get completions =>
      Hive.box<DailyCompletion>(completionsBox);
  Box<UserProfile> get profile => Hive.box<UserProfile>(profileBox);
  Box get settings => Hive.box(settingsBox);
}
