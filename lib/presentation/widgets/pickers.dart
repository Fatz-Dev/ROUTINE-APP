import 'package:flutter/material.dart';

import '../../core/constants/habit_icons.dart';
import '../../core/theme/app_colors.dart';

class IconPickerSheet extends StatelessWidget {
  final String? selected;
  const IconPickerSheet({super.key, this.selected});

  static Future<String?> show(BuildContext context, {String? selected}) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => IconPickerSheet(selected: selected),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = HabitIcons.allKeys;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Pilih Ikon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: GridView.builder(
              controller: controller,
              padding: const EdgeInsets.all(16),
              itemCount: keys.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (_, i) {
                final k = keys[i];
                final isSelected = k == selected;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.pop(context, k),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.grey.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(HabitIcons.get(k),
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimaryLight),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
