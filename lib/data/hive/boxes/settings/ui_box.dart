import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:developer' as dev;

import 'package:shonenx/data/hive/models/settings/ui_model.dart';

class UiBox {
  Box<UiSettings>? _box;
  final String boxName = 'player_settings';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<UiSettings>(boxName);
      dev.log('Box opened');
    } else {
      _box = Hive.box<UiSettings>(boxName);
      dev.log('Box reused');
    }
  }

  bool get isInitialized => _box != null;

  ValueListenable<Box<UiSettings>> get boxValueListenable => _box!.listenable();

  List<UiSettings> getAllEntries() => _box?.values.toList() ?? [];

  Future<void> clearAll() async => await _box?.clear();

  UiSettings? getProviderSettings() {
    return _box?.get(0);
  }

  Future<void> savePlayerSettings(UiSettings providerSettings) async {
    await _box?.put(0, providerSettings);
  }

  Future<void> updatePlayerSettings(UiSettings providerSettings) async {
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
