import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:developer' as dev;

import 'package:shonenx/data/hive/models/settings/theme_model.dart';

class ThemeBox {
  Box<ThemeSettings>? _box;
  final String boxName = 'player_settings';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<ThemeSettings>(boxName);
      dev.log('Box opened');
    } else {
      _box = Hive.box<ThemeSettings>(boxName);
      dev.log('Box reused');
    }
  }

  bool get isInitialized => _box != null;

  ValueListenable<Box<ThemeSettings>> get boxValueListenable =>
      _box!.listenable();

  List<ThemeSettings> getAllEntries() => _box?.values.toList() ?? [];

  Future<void> clearAll() async => await _box?.clear();

  ThemeSettings? getProviderSettings() {
    return _box?.get(0);
  }

  Future<void> savePlayerSettings(ThemeSettings providerSettings) async {
    await _box?.put(0, providerSettings);
  }

  Future<void> updatePlayerSettings(ThemeSettings providerSettings) async {
    await _box?.put(0, providerSettings);
  }

  Future<void> close() async {
    try {
      await _box?.close();
      _box = null;
    } catch (e, stackTrace) {
      dev.log('Error closing SettingsBox: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
