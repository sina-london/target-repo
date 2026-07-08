import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shonenx/data/hive/models/settings/player_model.dart';

final playerSettingsProvider =
    NotifierProvider<PlayerSettingsNotifier, PlayerSettings>(
  PlayerSettingsNotifier.new,
);

class PlayerSettingsNotifier extends Notifier<PlayerSettings> {
  static const _boxName = 'player_settings';
  static const _key = 'settings';

  @override
  PlayerSettings build() {
    final box = Hive.box<PlayerSettings>(_boxName);
    return box.get(_key, defaultValue: PlayerSettings()) ?? PlayerSettings();
  }

  void updateSettings(PlayerSettings Function(PlayerSettings) updater) {
    state = updater(state);
    Hive.box<PlayerSettings>(_boxName).put(_key, state);
  }
}
