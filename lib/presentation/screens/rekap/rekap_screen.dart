import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/constants/habit_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../providers/completion_provider.dart';
import '../../providers/habit_provider.dart';
import 'daily_detail_screen.dart';

class RekapScreen extends ConsumerStatefulWidget {
  const RekapScreen({super.key});

  @override
  ConsumerState<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends ConsumerState<RekapScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final counts = ref.watch(completionsHeatmapProvider);
    final habits = ref.watch(habitListProvider);
    final totalHabits = habits.isEmpty ? 1 : habits.length;

    final focused = _focusedDay;
    final monthKey = '${focused.year}-${focused.month.toString().padLeft(2, '0')}';
    
    // Data bulan yang sedang difokuskan
    final monthCompletions = ref.watch(monthCompletionsProvider(monthKey));
    
    final daysInMonth =
        DateTime(focused.year, focused.month + 1, 0).day;
    final totalPossible = daysInMonth * habits.length;
    final monthCompletionCount = monthCompletions.length;
    final completionRate =
        totalPossible == 0 ? 0.0 : (monthCompletionCount / totalPossible) * 100;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          // Kalender
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                locale: 'id_ID',
                firstDay: DateTime(2020),
                lastDay: DateTime(2100),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) =>
                    _selectedDay != null && isSameDay(day, _selectedDay!),
                calendarFormat: _format,
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Bulan',
                  CalendarFormat.twoWeeks: '2 Minggu',
                },
                onFormatChanged: (f) => setState(() => _format = f),
                onPageChanged: (d) => setState(() => _focusedDay = d),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DailyDetailScreen(date: selected),
                    ),
                  );
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    final count = counts[AppDateUtils.dateKey(day)] ?? 0;
                    if (count == 0) return null;
                    final ratio = count / totalHabits;
                    Color dotColor;
                    if (ratio >= 1) {
                      dotColor = AppColors.primary;
                    } else if (ratio >= 0.5) {
                      dotColor = AppColors.primaryMid;
                    } else {
                      dotColor = AppColors.primaryLight;
                    }
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: dotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Summary bulan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ringkasan ${AppDateUtils.formatMonthYear(_focusedDay)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: 'Completion Rate',
                    value: '${completionRate.toStringAsFixed(0)}%',
                    icon: Icons.percent_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    label: 'Total Presensi',
                    value: '$monthCompletionCount',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.primaryMid,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pie chart per habit
          if (habits.isNotEmpty && monthCompletionCount > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kontribusi per Habit',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: habits.map((h) {
                            final count = monthCompletions
                                .where((c) => c.habitId == h.id)
                                .length;
                            final color = AppColors.habitColors[
                                h.colorIndex % AppColors.habitColors.length];
                            return PieChartSectionData(
                              value: count.toDouble(),
                              color: color,
                              title: count > 0 ? '$count' : '',
                              radius: 50,
                              titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: habits.map((h) {
                        final color = AppColors.habitColors[
                            h.colorIndex % AppColors.habitColors.length];
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(HabitIcons.get(h.iconKey),
                                size: 14, color: color),
                            const SizedBox(width: 4),
                            Text(h.name, style: const TextStyle(fontSize: 12)),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7),
              )),
        ],
      ),
    );
  }
}
