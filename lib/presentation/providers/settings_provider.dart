import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/hive_service.dart';
import '../../data/services/notification_service.dart';

class SettingsState {
  final bool notificationEnabled;
  final TimeOfDay reminderTime;

  const SettingsState({
    required this.notificationEnabled,
    required this.reminderTime,
  });

  SettingsState copyWith({
    bool? notificationEnabled,
    TimeOfDay? reminderTime,
  }) {
    return SettingsState(
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(_load());

  static SettingsState _load() {
    final box = HiveService.instance.settings;
    final enabled = box.get('notifEnabled', defaultValue: true) as bool;
    final hour = box.get('notifHour', defaultValue: 8) as int;
    final minute = box.get('notifMinute', defaultValue: 0) as int;
    return SettingsState(
      notificationEnabled: enabled,
      reminderTime: TimeOfDay(hour: hour, minute: minute),
    );
  }

  Future<void> setEnabled(bool value) async {
    state = state.copyWith(notificationEnabled: value);
    final box = HiveService.instance.settings;
    await box.put('notifEnabled', value);
    if (value) {
      await NotificationService.instance.requestPermission();
      await NotificationService.instance.scheduleDailyReminder(
        hour: state.reminderTime.hour,
        minute: state.reminderTime.minute,
      );
    } else {
      await NotificationService.instance.cancelAll();
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    state = state.copyWith(reminderTime: time);
    final box = HiveService.instance.settings;
    await box.put('notifHour', time.hour);
    await box.put('notifMinute', time.minute);
    if (state.notificationEnabled) {
      await NotificationService.instance.scheduleDailyReminder(
        hour: time.hour,
        minute: time.minute,
      );
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
