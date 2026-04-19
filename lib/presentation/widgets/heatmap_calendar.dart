import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';

/// Heatmap seperti GitHub – menampilkan intensitas presensi.
class HeatmapCalendar extends StatelessWidget {
  final Map<String, int> countsByDate;
  final int maxPerDay;
  final int weeks; // jumlah minggu yang ditampilkan (dari minggu ini ke belakang)

  const HeatmapCalendar({
    super.key,
    required this.countsByDate,
    this.maxPerDay = 5,
    this.weeks = 14,
  });

  int _intensity(int count) {
    if (count <= 0) return 0;
    final ratio = count / maxPerDay;
    if (ratio >= 1.0) return 4;
    if (ratio >= 0.75) return 3;
    if (ratio >= 0.5) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.dateOnly(DateTime.now());
    // Mulai dari (today - weeks*7 + 1), disesuaikan ke awal minggu (Senin = 1)
    final totalDays = weeks * 7;
    final start = today.subtract(Duration(days: totalDays - 1));

    return LayoutBuilder(
      builder: (context, constraints) {
        final cell = (constraints.maxWidth / weeks).floorToDouble() - 3;
        final size = cell.clamp(10.0, 18.0);
        return SizedBox(
          height: size * 7 + 6 * 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(weeks, (w) {
              return Padding(
                padding: EdgeInsets.only(right: w == weeks - 1 ? 0 : 3),
                child: Column(
                  children: List.generate(7, (d) {
                    final dayIndex = w * 7 + d;
                    final date = start.add(Duration(days: dayIndex));
                    final key = AppDateUtils.dateKey(date);
                    final count = countsByDate[key] ?? 0;
                    final color = AppColors.heatmap(_intensity(count));
                    return Padding(
                      padding: EdgeInsets.only(bottom: d == 6 ? 0 : 3),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
