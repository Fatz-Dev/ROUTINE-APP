import 'habit_categories.dart';

class HabitSuggestion {
  final String name;
  final String iconKey;
  final HabitCategory category;
  final String? description;
  final bool hasTarget;
  final int? targetValue;
  final String? targetUnit;

  const HabitSuggestion({
    required this.name,
    required this.iconKey,
    required this.category,
    this.description,
    this.hasTarget = false,
    this.targetValue,
    this.targetUnit,
  });
}

class HabitSuggestions {
  HabitSuggestions._();

  static const List<HabitSuggestion> all = [
    HabitSuggestion(
      name: 'Olahraga',
      iconKey: 'run',
      category: HabitCategory.kesehatan,
      description: 'Jaga tubuh tetap aktif',
      hasTarget: true,
      targetValue: 30,
      targetUnit: 'menit',
    ),
    HabitSuggestion(
      name: 'Minum Air',
      iconKey: 'water',
      category: HabitCategory.kesehatan,
      description: 'Hidrasi untuk tubuh sehat',
      hasTarget: true,
      targetValue: 8,
      targetUnit: 'gelas',
    ),
    HabitSuggestion(
      name: 'Meditasi',
      iconKey: 'meditation',
      category: HabitCategory.mindfulness,
      description: 'Tenangkan pikiran, temukan fokus',
      hasTarget: true,
      targetValue: 10,
      targetUnit: 'menit',
    ),
    HabitSuggestion(
      name: 'Baca Buku',
      iconKey: 'book',
      category: HabitCategory.produktivitas,
      description: 'Minimal beberapa halaman per hari',
      hasTarget: true,
      targetValue: 10,
      targetUnit: 'halaman',
    ),
    HabitSuggestion(
      name: 'Tidur Tepat Waktu',
      iconKey: 'sleep',
      category: HabitCategory.kesehatan,
      description: 'Sebelum jam 23:00',
    ),
    HabitSuggestion(
      name: 'Makan Sehat',
      iconKey: 'food',
      category: HabitCategory.kesehatan,
      description: 'Sayur & protein di setiap makan',
    ),
    HabitSuggestion(
      name: 'Jalan Pagi',
      iconKey: 'walk',
      category: HabitCategory.kesehatan,
      hasTarget: true,
      targetValue: 20,
      targetUnit: 'menit',
    ),
    HabitSuggestion(
      name: 'Belajar',
      iconKey: 'study',
      category: HabitCategory.produktivitas,
      hasTarget: true,
      targetValue: 30,
      targetUnit: 'menit',
    ),
    HabitSuggestion(
      name: 'Menulis Jurnal',
      iconKey: 'journal',
      category: HabitCategory.mindfulness,
    ),
    HabitSuggestion(
      name: 'Yoga',
      iconKey: 'yoga',
      category: HabitCategory.kesehatan,
      hasTarget: true,
      targetValue: 15,
      targetUnit: 'menit',
    ),
    HabitSuggestion(
      name: 'Menabung',
      iconKey: 'money',
      category: HabitCategory.keuangan,
    ),
    HabitSuggestion(
      name: 'Bersyukur',
      iconKey: 'heart',
      category: HabitCategory.mindfulness,
    ),
  ];
}
