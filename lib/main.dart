import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/settings/settings_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/screens/main/home_screen.dart';
import 'package:nekoflow/screens/main/watchlist_screen.dart';
import 'package:nekoflow/screens/main/search_screen.dart';
import 'package:nekoflow/screens/main/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(WatchlistModelAdapter());
  Hive.registerAdapter(RecentlyWatchedItemAdapter());
  Hive.registerAdapter(ContinueWatchingItemAdapter());
  await Hive.openBox<SettingsModel>('user_settings');
  await Hive.openBox<WatchlistModel>('user_watchlist');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 1;
  bool _isDarkMode = true;
  late Box<SettingsModel> settingsBox;

  static const _screens = [
    SettingsScreen(),
    HomeScreen(),
    SearchScreen(),
    WatchlistScreen()
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Access the already-opened settings box
    settingsBox = Hive.box<SettingsModel>('user_settings');

    // Listen for changes in the 'isDarkTheme' key
    settingsBox.listenable().addListener(() {
      setState(() {
        _isDarkMode = settingsBox
                .get('isDarkTheme',
                    defaultValue: SettingsModel(isDarkTheme: true))
                ?.isDarkTheme ??
            true;
      });
    });

    // Initialize the _isDarkMode based on the current value in the box
    _isDarkMode = settingsBox
            .get('isDarkTheme', defaultValue: SettingsModel(isDarkTheme: true))
            ?.isDarkTheme ??
        true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: Colors.white,
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(toolbarHeight: 0),
        body: _screens[_selectedIndex], 
        bottomNavigationBar: CrystalNavigationBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: _isDarkMode ? Colors.white : Colors.black,
          unselectedItemColor: Colors.grey,
          enableFloatingNavBar: true,
          marginR: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
          splashBorderRadius: 50,
          borderRadius: 500,
          indicatorColor: Colors.pink[100],
          enablePaddingAnimation: true,
          items: [
            CrystalNavigationBarItem(
              icon: Icons.settings,
              unselectedIcon: Icons.settings,
              selectedColor: Colors.pink,
            ),
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home,
              selectedColor: Colors.pink,
            ),
            CrystalNavigationBarItem(
              icon: Icons.search,
              unselectedIcon: Icons.search,
              selectedColor: Colors.pink,
            ),
            CrystalNavigationBarItem(
              icon: Icons.bookmark,
              unselectedIcon: Icons.bookmark,
              selectedColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
