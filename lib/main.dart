import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/onboarding/onboarding_model.dart';
import 'package:nekoflow/data/models/settings/settings_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/data/theme/theme_manager.dart';
import 'package:nekoflow/screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SettingsModelAdapter());
  Hive.registerAdapter(WatchlistModelAdapter());
  Hive.registerAdapter(RecentlyWatchedItemAdapter());
  Hive.registerAdapter(ContinueWatchingItemAdapter());
  Hive.registerAdapter(AnimeItemAdapter());
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
  late Box<SettingsModel> settingsBox;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Access the already-opened settings box
    settingsBox = Hive.box<SettingsModel>('user_settings');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.getTheme(ThemeType.greenForest),
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(toolbarHeight: 0),
        body: OnboardingScreen(),
      ),
    );
  }
}
