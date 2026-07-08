import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:developer' as dev;

import 'package:shonenx/data/hive/models/settings/provider_model.dart';

class ProviderBox {
  Box<ProviderSettings>? _box;
  final String boxName = 'provider_settings';

  Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      _box = await Hive.openBox<ProviderSettings>(boxName);
      dev.log('Box opened');
    } else {
      _box = Hive.box<ProviderSettings>(boxName);
      dev.log('Box reused');
    }
  }

  bool get isInitialized => _box != null;

  ValueListenable<Box<ProviderSettings>> get boxValueListenable =>
      _box!.listenable();

  List<ProviderSettings> getAllEntries() => _box?.values.toList() ?? [];

  Future<void> clearAll() async => await _box?.clear();

  ProviderSettings? getProviderSettings() {
    return _box?.get(0);
  }

  Future<void> saveProviderSettings(ProviderSettings providerSettings) async {
    await _box?.put(0, providerSettings);
  }

  Future<void> updateProviderSettings(ProviderSettings providerSettings) async {
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