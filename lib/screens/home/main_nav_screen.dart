import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../discovery/swipe_card_screen.dart';
import '../chat/chat_list_screen.dart';
import '../map/map_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    SwipeCardScreen(),
    ChatListScreen(),
    MapScreen(),
    NotificationsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppShadows.nav,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.pets, Icons.pets, 'Discover'),
              _navItem(1, Icons.chat_bubble_rounded,
                  Icons.chat_bubble_outline_rounded, 'Chats', badge: 3),
              _navItem(2, Icons.location_on_rounded,
                  Icons.location_on_outlined, 'Map'),
              _navItem(3, Icons.notifications_rounded,
                  Icons.notifications_outlined, 'Alerts', badge: 2),
              _navItem(4, Icons.person_rounded,
                  Icons.person_outline_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label, {
    int badge = 0,
  }) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    key: ValueKey(isActive),
                    color: isActive ? AppColors.primary : AppColors.textHint,
                    size: 24,
                  ),
                ),
                if (badge > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          badge.toString(),
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textHint,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
