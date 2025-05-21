import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shonenx/data/hive/models/settings/player_model.dart';
import 'dart:developer' as dev;

class PlayerBox {
  Box<PlayerSettings>? _box;
  final String boxName = 'player_settings';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<PlayerSettings>(boxName);
      dev.log('Box opened');
    } else {
      _box = Hive.box<PlayerSettings>(boxName);
      dev.log('Box reused');
    }
  }

  bool get isInitialized => _box != null;

  ValueListenable<Box<PlayerSettings>> get boxValueListenable =>
      _box!.listenable();

  List<PlayerSettings> getAllEntries() => _box?.values.toList() ?? [];

  Future<void> clearAll() async => await _box?.clear();

  PlayerSettings? getProviderSettings() {
    return _box?.get(0);
  }

  Future<void> savePlayerSettings(PlayerSettings providerSettings) async {
    await _box?.put(0, providerSettings);
  }

  Future<void> updatePlayerSettings(PlayerSettings providerSettings) async {
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
