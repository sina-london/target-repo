import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shonenx/data/hive/models/settings/ui_model.dart';

final uiSettingsProvider = NotifierProvider<UiSettingsNotifier, UiSettings>(
  UiSettingsNotifier.new,
);

class UiSettingsNotifier extends Notifier<UiSettings> {
  static const _boxName = 'ui_settings';
  static const _key = 'settings';

  @override
  UiSettings build() {
    final box = Hive.box<UiSettings>(_boxName);
    return box.get(_key, defaultValue: UiSettings()) ?? UiSettings();
  }

  void updateSettings(UiSettings Function(UiSettings) updater) {
    state = updater(state);
    Hive.box<UiSettings>(_boxName).put(_key, state);
  }
}
