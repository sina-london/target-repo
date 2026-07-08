import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shonenx/data/hive/models/settings/provider_model.dart';

final providerSettingsProvider = NotifierProvider<ProviderSettingsNotifier, ProviderSettings>(
  ProviderSettingsNotifier.new,
);

class ProviderSettingsNotifier extends Notifier<ProviderSettings> {
  static const _boxName = 'provider_settings';
  static const _key = 'settings';

  @override
  ProviderSettings build() {
    final box = Hive.box<ProviderSettings>(_boxName);
    return box.get(_key, defaultValue: ProviderSettings()) ?? ProviderSettings();
  }

  void updateSettings(ProviderSettings Function(ProviderSettings) updater) {
    state = updater(state);
    Hive.box<ProviderSettings>(_boxName).put(_key, state);
  }
}
