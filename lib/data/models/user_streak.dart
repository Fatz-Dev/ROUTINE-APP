class UserStreak {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;
  final int totalCompletions;
  final int totalActiveDays;

  const UserStreak({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastCompletedDate,
    required this.totalCompletions,
    required this.totalActiveDays,
  });

  factory UserStreak.empty() => const UserStreak(
        currentStreak: 0,
        longestStreak: 0,
        lastCompletedDate: null,
        totalCompletions: 0,
        totalActiveDays: 0,
      );
}
