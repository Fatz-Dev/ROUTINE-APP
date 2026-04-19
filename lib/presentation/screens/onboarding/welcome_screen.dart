import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'add_initial_habits_screen.dart';

/// Welcome screen setelah onboarding, sebelum add initial habits.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.05 : 0.08),
                shape: BoxShape.circle,
              ),
            ).animate().fadeIn(duration: 1.seconds).scale(begin: const Offset(0.8, 0.8)),
          ),
          Positioned(
            bottom: -50,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.03 : 0.06),
                shape: BoxShape.circle,
              ),
            ).animate().fadeIn(duration: 1.2.seconds, delay: 200.ms),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  // Header
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ROUTINE',
                        style: AppTheme.brandLogoStyle(
                          color: isDark ? AppColors.primaryMid : AppColors.primaryDark,
                          size: 20,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.auto_graph_rounded,
                            color: AppColors.primary.withValues(alpha: 0.8), size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  
                  // Illustration card
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Faint R background
                          Positioned(
                            top: -40,
                            left: -20,
                            child: Text(
                              'R',
                              style: AppTheme.displayStyle(
                                color: AppColors.primary.withValues(alpha: isDark ? 0.04 : 0.06),
                                size: 280,
                                weight: FontWeight.w900,
                              ),
                            ),
                          ).animate().fadeIn(duration: 800.ms),
                          
                          // Glassmorphism-style Main Card
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 320),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface.withValues(alpha: 0.9) : Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                                  blurRadius: 40,
                                  offset: const Offset(0, 15),
                                ),
                              ],
                              border: Border.all(
                                color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 140,
                                            decoration: BoxDecoration(
                                              color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            height: 8,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.05),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 22),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                
                                // Fingerprint unit
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer pulse rings
                                    ...List.generate(2, (index) => Container(
                                      width: 100 + (index * 30),
                                      height: 100 + (index * 30),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.05),
                                        shape: BoxShape.circle,
                                      ),
                                    ).animate(onPlay: (c) => c.repeat()).scale(
                                      begin: const Offset(0.8, 0.8), 
                                      end: const Offset(1.2, 1.2), 
                                      duration: (1.5 + index).seconds, 
                                      curve: Curves.easeOut
                                    ).fadeIn().fadeOut()),

                                    Image.asset(
                                      'assets/images/logo_bg_transparant.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.contain,
                                    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                      begin: const Offset(1, 1),
                                      end: const Offset(1.05, 1.05),
                                      duration: 1.seconds,
                                      curve: Curves.easeInOut
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                // Bottom hint status
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'READY TO PROGRESS',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0),
                        ],
                      ),
                    ),
                  ),

                  // Heading + Subtitle section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Text(
                          'SELAMAT DATANG!\nMUDAH DAN BERMAKNA',
                          textAlign: TextAlign.center,
                          style: AppTheme.displayStyle(
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            size: 26,
                            weight: FontWeight.w900,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                        const SizedBox(height: 16),
                        Text(
                          'Bangun kebiasaanmu dengan presensi harian yang konsisten dan bermakna.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white54 : AppColors.textSecondaryLight,
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                        ).animate().fadeIn(delay: 600.ms),
                      ],
                    ),
                  ),

                  // Actions
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const AddInitialHabitsScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                          ),
                          child: const Text(
                            'TAMBAH HABIT PERTAMA',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const AddInitialHabitsScreen()),
                          );
                        },
                        child: Text(
                          'LEWATI',
                          style: TextStyle(
                            color: isDark ? Colors.white38 : AppColors.textTertiaryLight,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
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
