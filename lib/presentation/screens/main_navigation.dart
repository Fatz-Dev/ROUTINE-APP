import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import 'habit/add_habit_screen.dart';
import 'home/home_screen.dart';
import 'profil/profil_screen.dart';
import 'rekap/rekap_screen.dart';
import 'statistik/statistik_screen.dart';

/// Bottom navigation 5 tab: Home, Kalender, [+] Tambah Habit (FAB center),
/// Achievement (Statistik), Settings (Profil).
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    RekapScreen(),
    StatistikScreen(), // Achievement
    ProfilScreen(),
  ];

  void _onTabSelected(int i) {
    setState(() => _index = i);
  }

  void _openAddHabit() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddHabitScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddHabit,
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(
            'assets/images/logo_bg_transparant.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        elevation: 0,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: 'Home',
                selected: _index == 0,
                onTap: () => _onTabSelected(0),
              ),
              _NavItem(
                icon: Icons.calendar_month_outlined,
                selectedIcon: Icons.calendar_month_rounded,
                label: 'Kalender',
                selected: _index == 1,
                onTap: () => _onTabSelected(1),
              ),
              const SizedBox(width: 48), // space for FAB
              _NavItem(
                icon: Icons.emoji_events_outlined,
                selectedIcon: Icons.emoji_events_rounded,
                label: 'Achievement',
                selected: _index == 2,
                onTap: () => _onTabSelected(2),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings_rounded,
                label: 'Settings',
                selected: _index == 3,
                onTap: () => _onTabSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondaryLight;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? selectedIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
