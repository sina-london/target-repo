import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/onboarding/onboarding_model.dart';
import 'package:nekoflow/data/models/settings/settings_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(WatchlistModelAdapter());
  Hive.registerAdapter(RecentlyWatchedItemAdapter());
  Hive.registerAdapter(ContinueWatchingItemAdapter());
  Hive.registerAdapter(OnboardingModelAdapter());
  await Hive.openBox<SettingsModel>('user_settings');
  await Hive.openBox<WatchlistModel>('user_watchlist');
  await Hive.openBox<OnboardingModel>('onboarding');
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isDarkMode = true;
  late Box<SettingsModel> settingsBox;

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
        body: OnboardingScreen(), 
      ),
    );
  }
}
