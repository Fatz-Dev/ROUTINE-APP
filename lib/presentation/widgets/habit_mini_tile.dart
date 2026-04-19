import 'package:flutter/material.dart';

import '../../core/constants/habit_categories.dart';
import '../../core/constants/habit_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/daily_completion.dart';
import '../../data/models/habit.dart';

/// Tile kecil untuk list "Langkah Selanjutnya" di Home.
class HabitMiniTile extends StatelessWidget {
  final Habit habit;
  final DailyCompletion? completion;
  final VoidCallback onTap;

  const HabitMiniTile({
    super.key,
    required this.habit,
    required this.completion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final category = HabitCategory.fromName(habit.category);
    final done = completion?.isFullyCompleted ?? false;
    final inProgress = completion != null && !done;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: done
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03)),
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : (isDark ? AppColors.darkSurfaceAlt : AppColors.lightSurfaceAlt),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    HabitIcons.get(habit.iconKey),
                    color: done ? AppColors.primary : AppColors.textTertiaryLight,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: done ? AppColors.textTertiaryLight : null,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _subtitle(habit, category, completion),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (done)
                  const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 28)
                else if (inProgress && habit.hasTarget)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: completion!.progressRatio,
                          strokeWidth: 3.5,
                          strokeCap: StrokeCap.round,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                      Text(
                        '${(completion!.progressRatio * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_rounded, color: AppColors.primary, size: 18),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _subtitle(Habit h, HabitCategory c, DailyCompletion? comp) {
    if (h.hasTarget && h.targetValue != null) {
      if (comp != null) {
        return '${comp.progressValue} / ${h.targetValue} ${h.targetUnit ?? ''} selesai';
      }
      return '${h.targetValue} ${h.targetUnit ?? ''} · ${c.label}';
    }
    return c.label;
  }
}
