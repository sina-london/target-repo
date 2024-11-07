import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/settings_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box<SettingsModel> settingsBox;
  final defaultSettings = SettingsModel(); // Default instance

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box<SettingsModel>('user_settings');
  }

  Future<void> _updateSetting(String key, dynamic value) async {

    // Update the relevant field in the settings model
    print("Debug val : $key , $value");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: settingsBox.listenable(),
          builder: (context, Box<SettingsModel> box, _) {
            final settings =
                box.get('settings', defaultValue: defaultSettings) ??
                    defaultSettings;

            return ListView(
              children: [
                // Quality Selector
                DropdownButtonFormField<String>(
                  value: settings.defaultQuality,
                  decoration:
                      const InputDecoration(labelText: 'Default Quality'),
                  items: ['320p', '480p', '720p', '1080p'].map((quality) {
                    return DropdownMenuItem(
                      value: quality,
                      child: Text(quality),
                    );
                  }).toList(),
                  onChanged: (value) => _updateSetting('defaultQuality', value),
                ),
                const SizedBox(height: 16.0),

                // Theme Toggle
                SwitchListTile(
                  title: const Text('Dark Theme'),
                  value: false,
                  onChanged: (value) => _updateSetting('isDarkTheme', value),
                ),
                const SizedBox(height: 16.0),

                // Orientation Selector
                DropdownButtonFormField<String>(
                  value: settings.defaultOrientation,
                  decoration:
                      const InputDecoration(labelText: 'Default Orientation'),
                  items: ['Portrait', 'Landscape'].map((orientation) {
                    return DropdownMenuItem(
                      value: orientation,
                      child: Text(orientation),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      _updateSetting('defaultOrientation', value),
                ),
                const SizedBox(height: 16.0),

                // Home Screen Section Label
                const Text(
                  'Home Screen Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),

                // Layout Mode Selector
                DropdownButtonFormField<String>(
                  value: settings.layoutMode,
                  decoration: const InputDecoration(labelText: 'Layout Mode'),
                  items: ['Grid', 'List'].map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                  onChanged: (value) => _updateSetting('layoutMode', value),
                ),
                const SizedBox(height: 16.0),

                // Enable/Disable Label
                SwitchListTile(
                  title: const Text('Enable Labels'),
                  value: settings.isLabelEnabled ?? true,
                  onChanged: (value) => _updateSetting('isLabelEnabled', value),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
