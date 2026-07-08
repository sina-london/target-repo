import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nekoflow/data/models/settings_model.dart';
import 'package:nekoflow/screens/home_screen.dart';
import 'package:nekoflow/screens/search_screen.dart';
import 'package:nekoflow/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsModelAdapter());
  await Hive.openBox<SettingsModel>('userSettings');
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
  static const _screens = [
    KeyedSubtree(key: ValueKey("Browse"), child: SettingsScreen()),
    KeyedSubtree(key: ValueKey("Home"), child: HomeScreen()),
    KeyedSubtree(key: ValueKey("Search"), child: SearchScreen()),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // void _toggleTheme() {
  //   setState(() {
  //     _isDarkMode = !_isDarkMode;
  //   });
  // }

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
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
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
          marginR: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
          splashBorderRadius: 50,
          borderRadius: 500,
          indicatorColor: Colors.pink[100],
          enablePaddingAnimation: true,
          items:  [
            CrystalNavigationBarItem(
              icon: Icons.book,
              unselectedIcon: Icons.book,
              selectedColor: Colors.pink[100],
            ),
            CrystalNavigationBarItem(
              icon: Icons.home,
              unselectedIcon: Icons.home,
              selectedColor: Colors.pink[100],
            ),
            CrystalNavigationBarItem(
              icon: Icons.search,
              unselectedIcon: Icons.search,
              selectedColor: Colors.pink[100],
            ),
            
          ],
        ),
      ),
    );
  }
}
