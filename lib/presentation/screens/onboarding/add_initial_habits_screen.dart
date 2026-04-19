import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/habit_icons.dart';
import '../../../core/constants/habit_suggestions.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/habit_provider.dart';
import '../../providers/user_provider.dart';
import '../main_navigation.dart';

class AddInitialHabitsScreen extends ConsumerStatefulWidget {
  const AddInitialHabitsScreen({super.key});

  @override
  ConsumerState<AddInitialHabitsScreen> createState() =>
      _AddInitialHabitsScreenState();
}

class _AddInitialHabitsScreenState
    extends ConsumerState<AddInitialHabitsScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final Set<int> _selected = {0, 1, 2};

  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final name = _nameCtrl.text.trim().isEmpty
        ? 'Sahabat Routine'
        : _nameCtrl.text.trim();
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 habit untuk dimulai')),
      );
      return;
    }
    setState(() => _loading = true);

    final suggestions = HabitSuggestions.all;
    final notifier = ref.read(habitListProvider.notifier);
    for (final idx in _selected) {
      final s = suggestions[idx];
      await notifier.create(
        name: s.name,
        iconKey: s.iconKey,
        colorIndex: 0,
        category: s.category.name,
        description: s.description,
        hasTarget: s.hasTarget,
        targetValue: s.targetValue,
        targetUnit: s.targetUnit,
      );
    }

    await ref.read(userProfileProvider.notifier).completeOnboarding(name);

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigation()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final suggestions = HabitSuggestions.all;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo! 👋',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        'Ayo pilih kebiasaan pertamamu untuk memulai perjalanan konsistensimu.',
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 32),
                      
                      // Input Name
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _nameCtrl,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            labelText: 'Nama Panggilan',
                            hintText: 'Contoh: Budi',
                            prefixIcon: const Icon(Icons.person_rounded, color: AppColors.primary),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                      
                      const SizedBox(height: 32),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REKOMENDASI HABIT',
                            style: TextStyle(
                              fontWeight: FontWeight.w900, 
                              fontSize: 13,
                              letterSpacing: 1.2,
                              color: isDark ? Colors.white38 : AppColors.textTertiaryLight,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_selected.length} DIPILIH',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 600.ms),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: suggestions.length,
                    itemBuilder: (_, i) {
                      final s = suggestions[i];
                      final isSelected = _selected.contains(i);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selected.remove(i);
                            } else {
                              _selected.add(i);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primarySoft)
                                : (isDark ? AppColors.darkSurface : Colors.white),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                              width: isSelected ? 2.5 : 1.5,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              )
                            ] : [],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(HabitIcons.get(s.iconKey),
                                        color: AppColors.primary, size: 24),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle_rounded,
                                        color: AppColors.primary, size: 24),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    s.hasTarget
                                        ? '${s.targetValue} ${s.targetUnit}'
                                        : s.category.label.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected ? AppColors.primary : (isDark ? Colors.white38 : AppColors.textTertiaryLight),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: (400 + (i * 100)).ms).scale(begin: const Offset(0.9, 0.9));
                    },
                  ),
                ),
                
                // Bottom Button
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _finish,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 3, color: Colors.white),
                              )
                            : const Text(
                                'MULAI SEKARANG',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
