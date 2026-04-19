import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../providers/user_provider.dart';
import 'main_navigation.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _showCorporate = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await initializeDateFormatting('id_ID', null);
    // Stage 1: clean splash
    await Future.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    setState(() => _showCorporate = true);
    // Stage 2: corporate splash
    await Future.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    final user = ref.read(userProfileProvider);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => (user != null && user.onboardingDone)
            ? const MainNavigation()
            : const OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _showCorporate
            ? const _CorporateSplash(key: ValueKey('corp'))
            : const _CleanSplash(key: ValueKey('clean')),
      ),
    );
  }
}

/// Stage 1: Clean minimalist splash dengan tagline "TEMUKAN IRAMAMU".
class _CleanSplash extends StatelessWidget {
  const _CleanSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lightBg,
            AppColors.primarySoft,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Text(
              'ROUTINE',
              style: GoogleFontsLocal.brand(color: AppColors.primary, size: 44),
            )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            const Text(
              'TEMUKAN IRAMAMU',
              style: TextStyle(
                color: AppColors.textSecondaryLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/logo_bg_transparant.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            )
                .animate()
                .scale(
                    delay: 400.ms,
                    duration: 600.ms,
                    curve: Curves.elasticOut),
            const Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Text(
                    'Mulai Langkahmu',
                    style: AppTheme.displayStyle(
                      color: AppColors.primary,
                      size: 24,
                      weight: FontWeight.w800,
                    ),
                  ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 8),
                  const Text(
                    'Transformasi besar dimulai dari kebiasaan\nkecil yang konsisten setiap hari.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondaryLight,
                      height: 1.6,
                    ),
                  ).animate().fadeIn(delay: 850.ms),
                ],
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

/// Stage 2: Corporate splash dengan card + footer "ROUTINE TECHNOLOGIES".
class _CorporateSplash extends StatelessWidget {
  const _CorporateSplash({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.lightBg,
            AppColors.primarySoft,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.bubble_chart_rounded,
                          size: 12, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Langkah Utama',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'ROUTINE',
                    style: GoogleFontsLocal.brand(
                        color: AppColors.primaryDark, size: 32),
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/logo_bg_transparant.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
            const SizedBox(height: 36),
            const Text(
              'MULAI LANGKAHMU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 6,
                color: AppColors.textSecondaryLight,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'ROUTINE TECHNOLOGIES • $year',
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTertiaryLight,
                ),
              ),
            ).animate().fadeIn(delay: 700.ms),
          ],
        ),
      ),
    );
  }
}

/// Helper local untuk font brand (avoid duplication).
class GoogleFontsLocal {
  static TextStyle brand({required Color color, double size = 32}) {
    return AppTheme.brandLogoStyle(color: color, size: size);
  }
}
