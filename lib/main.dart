import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nekoflow/data/models/settings_model.dart';
import 'package:nekoflow/screens/browse_screen.dart';
import 'package:nekoflow/screens/home_screen.dart';
import 'package:nekoflow/screens/search_screen.dart';
import 'package:nekoflow/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsAdapter());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  bool _isDarkMode = true;
  static const _screens = [
    KeyedSubtree(key: ValueKey("Home"), child: HomeScreen()),
    KeyedSubtree(key: ValueKey("Search"), child: SearchScreen()),
    KeyedSubtree(key: ValueKey("Browse"), child: BrowseScreen()),
    KeyedSubtree(key: ValueKey("Settings"), child: SettingsScreen()),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Simulating a network call or heavy computation
    await Future.delayed(const Duration(seconds: 1));

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      // You can perform additional state updates here if needed
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.robotoCondensedTextTheme(),
      ),
      darkTheme: ThemeData.dark().copyWith(
          textTheme:
              GoogleFonts.montserratTextTheme().apply(bodyColor: Colors.white)),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.oswald(
                color: Colors.white, // Default color for the main text
                fontSize: 24.0, // Set your desired font size
                fontStyle: FontStyle.italic,
              ),
              children: const <TextSpan>[
                TextSpan(
                    text: 'SHONEN',
                    style: TextStyle(
                        color: Colors.white)), // Default color for 'SHONEN'
                TextSpan(
                  text: 'X',
                  style: TextStyle(
                    color: Colors.red, // Red color for 'X'
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: _isDarkMode ? Colors.white : Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
