import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables
  String _selectedQuality = '720p';
  bool _isDarkTheme = false;
  String _selectedOrientation = 'Portrait';
  String _selectedLayoutMode = 'Grid';
  bool _isLabelEnabled = true;

  // List of options
  final List<String> qualities = ['320p', '480p', '720p', '1080p'];
  final List<String> orientations = ['Portrait', 'Landscape'];
  final List<String> layoutModes = ['Grid', 'List'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SettingsScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Default Quality Selector
            DropdownButtonFormField<String>(
              value: _selectedQuality,
              decoration: InputDecoration(labelText: 'Default Quality'),
              items: qualities.map((quality) {
                return DropdownMenuItem(
                  value: quality,
                  child: Text(quality),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuality = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Theme Toggler
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: _isDarkTheme,
              onChanged: (value) {
                setState(() {
                  _isDarkTheme = value;
                  // Optionally, update the app's theme
                  // You may want to manage theme state using a provider or state management solution.
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Default Orientation Selector
            DropdownButtonFormField<String>(
              value: _selectedOrientation,
              decoration: InputDecoration(labelText: 'Default Orientation'),
              items: orientations.map((orientation) {
                return DropdownMenuItem(
                  value: orientation,
                  child: Text(orientation),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOrientation = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Home Section
            const Text(
              'Home Screen Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

            // Layout Mode Selector
            DropdownButtonFormField<String>(
              value: _selectedLayoutMode,
              decoration: InputDecoration(labelText: 'Layout Mode'),
              items: layoutModes.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLayoutMode = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),

            // Enable/Disable Label
            SwitchListTile(
              title: const Text('Enable Labels'),
              value: _isLabelEnabled,
              onChanged: (value) {
                setState(() {
                  _isLabelEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
