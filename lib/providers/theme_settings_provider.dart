import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/data/isar/theme_model.dart';
import 'package:shonenx/services/isar_service.dart';

class ThemeSettingsNotifier extends AsyncNotifier<ThemeSettings?> {
  @override
  Future<ThemeSettings?> build() async {
    return await IsarService.getThemeSettings();
  }

  Future<void> updateThemeSettings(ThemeSettings newSettings) async {
    state = const AsyncLoading();
    await IsarService.saveThemeSettings(newSettings);
    state = AsyncData(newSettings);
  }
}

final themeSettingsProvider =
    AsyncNotifierProvider<ThemeSettingsNotifier, ThemeSettings?>(
        ThemeSettingsNotifier.new);
