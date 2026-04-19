/// Kategori habit untuk organisasi.
enum HabitCategory {
  kesehatan('Kesehatan', '🏃'),
  produktivitas('Produktivitas', '⚡'),
  mindfulness('Mindfulness', '🧘'),
  sosial('Sosial', '💬'),
  keuangan('Keuangan', '💰'),
  lainnya('Lainnya', '✨');

  final String label;
  final String emoji;
  const HabitCategory(this.label, this.emoji);

  static HabitCategory fromName(String? name) {
    return HabitCategory.values.firstWhere(
      (e) => e.name == name,
      orElse: () => HabitCategory.lainnya,
    );
  }
}
