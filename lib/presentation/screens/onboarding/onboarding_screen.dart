import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/habit_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  final _pages = const [
    _OnboardPageData(
      titleBefore: 'Presensi Habit\n',
      titleHighlight: 'Harian',
      subtitle:
          'Bangun konsistensi dengan cara yang paling sederhana. Cukup satu sentuhan.',
      previewIcon: 'water',
      previewName: 'Minum Air Putih',
      previewMeta: 'TARGET: 2L / HARI',
    ),
    _OnboardPageData(
      titleBefore: 'Tekan Sidik Jari,\n',
      titleHighlight: 'Selesai',
      subtitle:
          'Sentuh sekali, habitmu tercatat. Tidak perlu input panjang, tidak perlu scroll.',
      previewIcon: 'run',
      previewName: 'Olahraga 30 Menit',
      previewMeta: 'CHECK-IN HARIAN',
    ),
    _OnboardPageData(
      titleBefore: 'Lihat Rekap\n',
      titleHighlight: 'Progresmu',
      subtitle:
          'Pantau konsistensi lewat kalender, heatmap, dan streak. Rayakan setiap kemajuan.',
      previewIcon: 'target',
      previewName: 'Streak 12 Hari',
      previewMeta: 'KEEP GOING 🔥',
    ),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            left: -50,
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
            right: -80,
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
            child: Column(
              children: [
                // Header: ROUTINE + LEWATI
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ROUTINE',
                        style: AppTheme.brandLogoStyle(
                          color: isDark ? AppColors.primaryMid : AppColors.primaryDark,
                          size: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: isDark ? Colors.white54 : Colors.black45,
                        ),
                        child: const Text(
                          'LEWATI',
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (_, i) => _OnboardPage(data: _pages[i]),
                  ),
                ),

                // Footer section
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
                  child: Column(
                    children: [
                      // Page indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == _index ? 32 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: i == _index
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.2),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: i == _index
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLast ? 'MULAI' : 'LANJUT',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          // TODO: Login action
                        },
                        child: Text(
                          'SUDAH PUNYA AKUN? MASUK',
                          style: TextStyle(
                            color: isDark ? Colors.white38 : AppColors.textTertiaryLight,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
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

class _OnboardPageData {
  final String titleBefore;
  final String titleHighlight;
  final String subtitle;
  final String previewIcon;
  final String previewName;
  final String previewMeta;
  const _OnboardPageData({
    required this.titleBefore,
    required this.titleHighlight,
    required this.subtitle,
    required this.previewIcon,
    required this.previewName,
    required this.previewMeta,
  });
}

class _OnboardPage extends StatelessWidget {
  final _OnboardPageData data;
  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // Heading
          RichText(
            text: TextSpan(
              style: AppTheme.displayStyle(
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                size: 42,
                weight: FontWeight.w900,
              ),
              children: [
                TextSpan(text: data.titleBefore),
                TextSpan(
                  text: data.titleHighlight,
                  style: AppTheme.displayStyle(
                    color: AppColors.primary,
                    size: 42,
                    weight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 20),
          Text(
            data.subtitle,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          const Spacer(),
          // Visual Illustration Area
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing background for the card
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 2.seconds),
                
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Preview card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.03),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primaryMid, AppColors.primary],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(HabitIcons.get(data.previewIcon),
                                color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.previewName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data.previewMeta,
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
                    
                    const SizedBox(height: 40),
                    
                    // Fingerprint pulse
                    Image.asset(
                      'assets/images/logo_bg_transparant.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds, color: AppColors.primaryLight.withValues(alpha: 0.3)),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
