import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';

/// Tampilan "Selamat! Semua Selesai Hari Ini" di Home.
class AllCompletedView extends StatelessWidget {
  final int total;
  final VoidCallback onSeeRekap;

  const AllCompletedView({
    super.key,
    required this.total,
    required this.onSeeRekap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ).animate().scale(duration: 1.seconds, curve: Curves.elasticOut),
              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryMid, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 70),
              ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack),
            ],
          ),
          const SizedBox(height: 48),
          Text(
            'Hari yang Sempurna! 🎉',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 32,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 12),
          Text(
            'Luar biasa! Kamu sudah menyelesaikan\nsemua $total habit hari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textTertiaryLight,
              height: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Streak Berlanjut',
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: -0.5),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Kemenangan hari ini adalah fondasi untuk hari esok.',
                        style: TextStyle(fontSize: 13, color: AppColors.textTertiaryLight, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
