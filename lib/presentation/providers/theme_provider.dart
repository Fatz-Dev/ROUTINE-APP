import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/hive_service.dart';

/// Settings disimpan di Hive box 'settings' dengan key string.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_read()) {}

  static ThemeMode _read() {
    final box = HiveService.instance.settings;
    final raw = box.get('themeMode', defaultValue: 'system') as String;
    switch (raw) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final box = HiveService.instance.settings;
    await box.put('themeMode', mode.name);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
