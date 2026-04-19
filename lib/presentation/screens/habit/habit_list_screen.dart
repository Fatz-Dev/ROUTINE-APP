import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/habit_categories.dart';
import '../../../core/constants/habit_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/habit_provider.dart';
import 'add_habit_screen.dart';

class HabitListScreen extends ConsumerWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Habit'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddHabitScreen()),
            ),
          ),
        ],
      ),
      body: habits.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox_rounded,
                        size: 80,
                        color: Colors.grey.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text('Belum ada habit',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      'Tekan tombol + untuk menambah habit pertamamu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: habits.length,
              itemBuilder: (_, i) {
                final h = habits[i];
                final color = AppColors.habitColors[
                    h.colorIndex % AppColors.habitColors.length];
                final category = HabitCategory.fromName(h.category);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(HabitIcons.get(h.iconKey), color: color),
                    ),
                    title: Text(h.name,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle:
                        Text('${category.emoji} ${category.label}'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => AddHabitScreen(existing: h)),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
