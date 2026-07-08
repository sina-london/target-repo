import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shonenx/data/isar/theme_model.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();
    final customPath = '${dir.path}${Platform.pathSeparator}shonenx';
    _isar = await Isar.open(
      [
        ThemeSettingsSchema,
      ],
      directory: customPath,
    );
    return _isar!;
  }

  static Future<void> close() async {
    if (_isar != null) {
      await _isar!.close();
      _isar = null;
    }
  }

  // ----------------------------
  // Theme Settings API
  // ----------------------------

  static Future<ThemeSettings?> getThemeSettings() async {
    final isar = await instance;
    return await isar.themeSettings.where().findFirst();
  }

  static Future<void> saveThemeSettings(ThemeSettings settings) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.themeSettings.put(settings);
    });
  }
}
