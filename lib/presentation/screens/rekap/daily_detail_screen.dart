import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/habit_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../providers/completion_provider.dart';
import '../../providers/habit_provider.dart';

class DailyDetailScreen extends ConsumerWidget {
  final DateTime date;
  const DailyDetailScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completions = ref.watch(dateCompletionsProvider(date));
    final habits = ref.watch(habitListProvider);
    final completedIds = completions.map((c) => c.habitId).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppDateUtils.formatShortID(date)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppDateUtils.formatFullID(date),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${completedIds.length}/${habits.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...habits.map((h) {
            final done = completedIds.contains(h.id);
            final color = AppColors.habitColors[
                h.colorIndex % AppColors.habitColors.length];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(HabitIcons.get(h.iconKey), color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      h.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(
                    done ? Icons.check_circle_rounded : Icons.cancel_outlined,
                    color: done ? AppColors.primary : Colors.grey,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
