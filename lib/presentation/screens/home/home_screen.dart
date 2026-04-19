import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/daily_quotes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../providers/completion_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/habit_featured_card.dart';
import '../../widgets/habit_mini_tile.dart';
import '../../widgets/progress_ring.dart';
import '../habit/add_habit_screen.dart';
import '../rekap/rekap_screen.dart';
import 'all_completed_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final ConfettiController _confetti;
  // Removed final _selectedDate, now using todayDateProvider from Riverpod

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _onTap(String habitId) async {
    final completion = await ref.read(todayProvider.notifier).tap(habitId);
    if (completion == null) return;
    if (completion.isFullyCompleted) _confetti.play();

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        content: Text(
          completion.isFullyCompleted ? 'Selesai! 🎉 Luar biasa!' : 'Check-in tercatat',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        action: SnackBarAction(
          label: 'URUNGKAN',
          textColor: Colors.white,
          onPressed: () => ref.read(todayProvider.notifier).undo(habitId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final today = ref.watch(todayProvider);
    final selectedDate = ref.watch(todayDateProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final name = user?.name ?? 'Sahabat';
    final quote = DailyQuotes.forDate(selectedDate);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddHabitScreen()),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        highlightElevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 32),
      ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom Header
              SliverAppBar(
                expandedHeight: 140,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: theme.scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.2,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ROUTINE',
                        style: AppTheme.brandLogoStyle(
                          color: isDark ? AppColors.primaryMid : AppColors.primaryDark,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppDateUtils.isSameDay(ref.watch(todayDateProvider), DateTime.now())
                              ? AppDateUtils.greetingByHour().toUpperCase()
                              : AppDateUtils.formatDayMonth(ref.watch(todayDateProvider)).toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                            color: AppColors.primary.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Halo, $name',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Calendar Strip
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    height: 85,
                    child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 14, // Show 2 weeks
                    itemBuilder: (context, index) {
                      final day = DateTime.now().subtract(Duration(days: 7 - index));
                      final selectedDate = ref.watch(todayDateProvider);
                      final isSelected = AppDateUtils.isSameDay(day, selectedDate);
                      final isToday = AppDateUtils.isSameDay(day, DateTime.now());

                      return GestureDetector(
                        onTap: () => ref.read(todayDateProvider.notifier).state = day,
                        child: AnimatedContainer(
                          duration: 300.ms,
                          width: 58,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.darkSurfaceAlt : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05)),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                [
                                  'MIN',
                                  'SEN',
                                  'SEL',
                                  'RAB',
                                  'KAM',
                                  'JUM',
                                  'SAB'
                                ][day.weekday % 7],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : AppColors.textTertiaryLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                day.day.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              if (isToday && !isSelected)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ).animate().scale(delay: (index * 40).ms, duration: 400.ms, curve: Curves.easeOutBack);
                    },
                  ),
                ),
              ),
            ),

              // Progress Overview
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [AppColors.darkSurfaceAlt, AppColors.darkSurface]
                            : [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Progres Hari Ini',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                today.allDone ? 'Semua Selesai! ✨' : '${today.pending.length} habit tersisa',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: today.progress,
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                                  minHeight: 8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 70,
                              height: 70,
                              child: CircularProgressIndicator(
                                value: today.progress,
                                strokeWidth: 8,
                                strokeCap: StrokeCap.round,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '${(today.progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
              ),

              // Quote Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_quote_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'INSPIRASI HARI INI',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.05)),
                        ),
                        child: Text(
                          '"${quote['text']}"',
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ),

              // Section Header: Prioritas
              if (!today.allDone && today.featured != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Text(
                      'Prioritas Sekarang',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

              // Featured Card
              if (!today.allDone && today.featured != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: HabitFeaturedCard(
                      habit: today.featured!,
                      completion: today.completions[today.featured!.id],
                      onTap: () => _onTap(today.featured!.id),
                    ),
                  ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.9, 0.9)),
                ),

              // All Completed View
              if (today.allDone && today.total > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: AllCompletedView(
                      total: today.total,
                      onSeeRekap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RekapScreen()),
                      ),
                    ),
                  ),
                ),

              // Next Steps Section
              if (!today.allDone && today.pending.length > 1)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Habit Lainnya',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '${today.pending.length - 1} pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Mini Tiles
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList.builder(
                  itemCount: today.pending.length > 1
                      ? today.pending.length - 1 + today.doneCount
                      : today.doneCount,
                  itemBuilder: (_, i) {
                    final List others = [
                      ...today.pending.skip(1),
                      ...today.done,
                    ];
                    if (i >= others.length) return null;
                    final h = others[i];
                    return HabitMiniTile(
                      habit: h,
                      completion: today.completions[h.id],
                      onTap: () => _onTap(h.id),
                    ).animate().fadeIn(delay: (400 + (i * 50)).ms).slideX(begin: 0.1);
                  },
                ),
              ),

              // Empty State
              if (today.total == 0)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.rocket_launch_rounded,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          ).animate(onPlay: (controller) => controller.repeat(reverse: true)).moveY(begin: -10, end: 10, duration: 2.seconds, curve: Curves.easeInOut),
                          const SizedBox(height: 60),
                          // Decorative Empty Illustration
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.08),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Icon(
                                Icons.auto_awesome_mosaic_rounded,
                                size: 64,
                                color: AppColors.primary.withValues(alpha: 0.4),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Mulai Langkah Kecilmu',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Belum ada habit untuk hari ini. Tambahkan habit baru untuk mulai membangun rutinitas positif.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                            ),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Buat Habit Pertama'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.primaryMid,
                AppColors.primaryLight,
                Color(0xFFFFC83D),
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
