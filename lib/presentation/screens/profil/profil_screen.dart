import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/habit_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/habit_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../habit/add_habit_screen.dart';
import '../habit/habit_list_screen.dart';
import '../splash_screen.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  Future<void> _editName(BuildContext context, WidgetRef ref) async {
    final user = ref.read(userProfileProvider);
    final controller = TextEditingController(text: user?.name ?? '');
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nama panggilan'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (newName != null && newName.isNotEmpty) {
      await ref.read(userProfileProvider.notifier).save(newName);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final theme = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);
    final habits = ref.watch(habitListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            elevation: 0,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
            title: Text(
              'Pengaturan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isDark
                            ? Colors.white12
                            : Colors.black.withValues(alpha: 0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: isDark ? 0.3 : 0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Stack(
                        children: [
                          // Dekorasi artistik membulat
                          Positioned(
                            top: -40,
                            right: -20,
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.02)
                                    : Colors.black.withValues(alpha: 0.02),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -50,
                            right: 60,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.02)
                                    : Colors.black.withValues(alpha: 0.03),
                              ),
                            ),
                          ),
                          // Konten
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                // Avatar dengan bayangan dan kontras tinggi
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.name ?? 'Sahabat Routine',
                                        style: TextStyle(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 22,
                                            letterSpacing: -0.5,
                                            fontWeight: FontWeight.w900,
                                            height: 1.1),
                                      ),
                                      const SizedBox(height: 8),
                                      // Badge cantik untuk statistik
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white
                                                  .withValues(alpha: 0.05)
                                              : Colors.black
                                                  .withValues(alpha: 0.04),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.white
                                                    .withValues(alpha: 0.05)
                                                : Colors.black
                                                    .withValues(alpha: 0.03),
                                          ),
                                        ),
                                        child: Text(
                                          '${habits.length} habit aktif dilacak',
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Tombol edit bulat dan menyatu (blended)
                                Container(
                                  decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : Colors.black
                                              .withValues(alpha: 0.04),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.05)
                                            : Colors.transparent,
                                      )),
                                  child: IconButton(
                                    icon: Icon(Icons.edit_rounded,
                                        color: isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                        size: 22),
                                    onPressed: () => _editName(context, ref),
                                    tooltip: 'Edit Profil',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Section: Manajemen
                  _SectionTitle('Manajemen'),
                  _MenuTile(
                    icon: Icons.list_alt_rounded,
                    title: 'Daftar Habit',
                    subtitle: 'Kelola, edit, atau hapus rutinitas',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HabitListScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.add_circle_outline_rounded,
                    title: 'Tambah Habit',
                    subtitle: 'Eksplorasi habit baru',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AddHabitScreen()),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section: Preferensi
                  _SectionTitle('Preferensi'),
                  _MenuTile(
                    icon: Icons.palette_outlined,
                    title: 'Tema Visual',
                    subtitle: _themeLabel(theme),
                    onTap: () => _showThemeSheet(context, ref),
                  ),
                  _MenuTile(
                    icon: Icons.notifications_outlined,
                    title: 'Pengingat Harian',
                    subtitle: settings.notificationEnabled
                        ? 'Aktif • ${_formatTime(settings.reminderTime)}'
                        : 'Mati',
                    trailing: Switch.adaptive(
                      value: settings.notificationEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (v) =>
                          ref.read(settingsProvider.notifier).setEnabled(v),
                    ),
                    onTap: () => _pickTime(context, ref),
                  ),
                  const SizedBox(height: 24),

                  // Section: Lainnya
                  _SectionTitle('Lainnya'),
                  _MenuTile(
                    icon: Icons.code_rounded,
                    title: 'Pengembang',
                    subtitle: 'FatzDev (fatz-dev)',
                    trailing: const Icon(Icons.open_in_new_rounded,
                        size: 20, color: AppColors.primary),
                    onTap: () async {
                      final url = Uri.parse('https://github.com/Fatz-Dev');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                  ),
                  _MenuTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang ROUTINE',
                    subtitle: 'Versi 1.0.0',
                    onTap: () => _showAbout(context),
                  ),
                  _MenuTile(
                    icon: Icons.rotate_left_rounded,
                    title: 'Kembali ke Awal',
                    subtitle: 'Muat ulang aplikasi',
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const SplashScreen()),
                        (_) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 48), // Spacing below
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Mode Terang';
      case ThemeMode.dark:
        return 'Mode Gelap';
      case ThemeMode.system:
        return 'Ikuti Perangkat';
    }
  }

  String _formatTime(TimeOfDay t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _showThemeSheet(BuildContext context, WidgetRef ref) async {
    final current = ref.read(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurfaceAlt : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text('Tema Visual',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              const SizedBox(height: 16),
              ...ThemeMode.values.map((m) => RadioListTile<ThemeMode>(
                    title: Text(_themeLabel(m),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    value: m,
                    groupValue: current,
                    activeColor: AppColors.primary,
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(themeModeProvider.notifier).set(v);
                        Navigator.pop(context);
                      }
                    },
                  )),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final current = ref.read(settingsProvider).reminderTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      await ref.read(settingsProvider.notifier).setTime(picked);
    }
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'ROUTINE',
      applicationVersion: '1.0.0',
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.asset(
          'assets/images/logo.png',
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      ),
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'Habit tracker dengan rekap cepat dan antarmuka premium.\n\n'
            'Dirancang untuk membantumu fokus memonitor perkembangan '
            'tanpa terkoneksi internet (offline-first).',
            style: TextStyle(height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceAlt : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailing ??
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
