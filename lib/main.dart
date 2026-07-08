import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/app_initializer.dart';
import 'package:shonenx/data/hive/providers/theme_provider.dart';
import 'package:shonenx/theme/app_theme.dart';
import 'package:shonenx/router/router.dart';
import 'package:window_manager/window_manager.dart';

class ToggleFullscreenIntent extends Intent {
  const ToggleFullscreenIntent();
}

void main(List<String> args) async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppInitializer.initialize();
  } catch (e) {
    // Log error or show error screen
    runApp(const MaterialApp(
      home: Scaffold(body: Center(child: Text('Initialization failed'))),
    ));
    return;
  }

  if (runWebViewTitleBarWidget(args)) return;
  // runApp(MaterialApp(
  //   home: SearchBarExample(),
  // ));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isFullscreen = false;

  void _toggleFullscreen() {
    setState(() => _isFullscreen = !_isFullscreen);
    if (!Platform.isAndroid && !Platform.isIOS) {
      windowManager.setFullScreen(_isFullscreen);
    }
    // Optionally adjust system UI for mobile
    if (!_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeSettingsProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(theme),
      darkTheme: AppTheme.dark(theme),
      themeMode: theme.themeMode == 'light'
          ? ThemeMode.light
          : theme.themeMode == 'dark'
              ? ThemeMode.dark
              : ThemeMode.system,
      routerConfig: router,
    );
  }
}
