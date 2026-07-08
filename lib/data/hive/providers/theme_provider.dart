// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:shonenx/data/hive/models/settings/theme_model.dart';

// final themeSettingsProvider =
//     NotifierProvider<ThemeSettingsNotifier, ThemeSettings>(
//   ThemeSettingsNotifier.new,
// );

// class ThemeSettingsNotifier extends Notifier<ThemeSettings> {
//   static const _boxName = 'theme_settings';
//   static const _key = 'settings';

//   @override
//   ThemeSettings build() {
//     final box = Hive.box<ThemeSettings>(_boxName);
//     return box.get(_key, defaultValue: ThemeSettings()) ?? ThemeSettings();
//   }

//   void update(ThemeSettings newSettings) {
//     state = newSettings;
//     Hive.box<ThemeSettings>(_boxName).put(_key, newSettings);
//   }

//   void updateField(ThemeSettings Function(ThemeSettings) updater) {
//     state = updater(state);
//     Hive.box<ThemeSettings>(_boxName).put(_key, state);
//   }

//   void resetToDefault() {
//     final defaultTheme = ThemeSettings();
//     state = defaultTheme;
//     Hive.box<ThemeSettings>(_boxName).put(_key, defaultTheme);
//   }
// }
