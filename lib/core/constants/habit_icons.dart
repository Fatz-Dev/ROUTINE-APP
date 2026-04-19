import 'package:flutter/material.dart';

/// Library ikon built-in yang dipakai untuk habit.
/// Key akan disimpan ke Hive sebagai string.
class HabitIcons {
  HabitIcons._();

  static const Map<String, IconData> icons = {
    'run': Icons.directions_run_rounded,
    'water': Icons.water_drop_rounded,
    'meditation': Icons.self_improvement_rounded,
    'book': Icons.menu_book_rounded,
    'sleep': Icons.nightlight_round,
    'food': Icons.restaurant_rounded,
    'gym': Icons.fitness_center_rounded,
    'walk': Icons.directions_walk_rounded,
    'bike': Icons.directions_bike_rounded,
    'study': Icons.school_rounded,
    'code': Icons.code_rounded,
    'music': Icons.music_note_rounded,
    'art': Icons.palette_rounded,
    'journal': Icons.edit_note_rounded,
    'pray': Icons.mosque_rounded,
    'sun': Icons.wb_sunny_rounded,
    'heart': Icons.favorite_rounded,
    'brain': Icons.psychology_rounded,
    'yoga': Icons.accessibility_new_rounded,
    'coffee': Icons.coffee_rounded,
    'tea': Icons.emoji_food_beverage_rounded,
    'no_phone': Icons.phone_android_rounded,
    'clean': Icons.cleaning_services_rounded,
    'plant': Icons.local_florist_rounded,
    'pet': Icons.pets_rounded,
    'money': Icons.savings_rounded,
    'target': Icons.track_changes_rounded,
    'star': Icons.star_rounded,
    'fire': Icons.local_fire_department_rounded,
    'bolt': Icons.bolt_rounded,
    'smile': Icons.sentiment_very_satisfied_rounded,
    'check': Icons.check_circle_rounded,
  };

  static IconData get(String key) => icons[key] ?? Icons.check_circle_rounded;

  static List<String> get allKeys => icons.keys.toList();
}
