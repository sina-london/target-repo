import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nekoflow/screens/main/home/home_screen.dart';
import 'package:nekoflow/screens/main/search/search_screen.dart';
import 'package:nekoflow/screens/main/settings/settings_screen.dart';
import 'package:nekoflow/screens/main/watchlist/watchlist_screen.dart';

class AppRouter extends StatefulWidget {

  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  int _selectedIndex = 1;

  static const _screens = [
    SettingsScreen(),
    HomeScreen(),
    SearchScreen(),
    WatchlistScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CrystalNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        // selectedItemColor: _isDarkMode ? Colors.white : Colors.black,
        unselectedItemColor: Colors.grey,
        enableFloatingNavBar: true,
        marginR: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
        splashBorderRadius: 50,
        borderRadius: 500,
        enablePaddingAnimation: true,
        items: [
          CrystalNavigationBarItem(
            icon: Icons.settings,
            unselectedIcon: Icons.settings,
            selectedColor: Theme.of(context).indicatorColor,
          ),
          CrystalNavigationBarItem(
            icon: Icons.home,
            unselectedIcon: Icons.home,
            selectedColor: Theme.of(context).indicatorColor,
          ),
          CrystalNavigationBarItem(
            icon: Icons.search,
            unselectedIcon: Icons.search,
            selectedColor: Theme.of(context).indicatorColor,
          ),
          CrystalNavigationBarItem(
            icon: Icons.bookmark,
            unselectedIcon: Icons.bookmark,
            selectedColor: Theme.of(context).indicatorColor,
          ),
        ],
      ),
    );
  }
}
