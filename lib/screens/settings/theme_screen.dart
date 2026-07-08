import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nekoflow/data/models/settings/settings_model.dart';
import 'package:nekoflow/data/theme/theme_manager.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  ThemeType? _selectedTheme;
  late Box<SettingsModel> settingsBox;

  final List<Map<String, dynamic>> _themeOptions = [
    {'icon': Icons.sunny, 'label': 'Light'},
    {'icon': Icons.dark_mode, 'label': 'Dark'},
    {'icon': Icons.brightness_auto, 'label': 'Auto'},
  ];

  @override
  void initState() {
    super.initState();
    // Open the settings Hive box and set the initial theme based on the saved value
    settingsBox = Hive.box<SettingsModel>('user_settings');
    _selectedTheme = settingsBox
            .get('theme',
                defaultValue: SettingsModel(theme: ThemeType.greenForest))
            ?.theme ??
        ThemeType.greenForest;
  }

  // Update theme in Hive and set the selected theme
  void _updateTheme(String themeLabel) {
    // setState(() {
    //   _selectedTheme = themeLabel;
    // });
    // settingsBox.put('theme', SettingsModel(theme: themeLabel.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.navigate_before,
            size: 35,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        iconTheme: Theme.of(context).iconTheme,
        title: Text("Theme", style: Theme.of(context).textTheme.headlineLarge),
        toolbarHeight: 200,
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose Theme",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Theme mode options as buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _themeOptions.map((option) {
                bool isSelected = option['label'] == 'Auto';
                return GestureDetector(
                  onTap: () => _updateTheme(option['label']),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(option['icon'] as IconData,
                            color:
                                isSelected ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color),
                        const SizedBox(width: 8),
                        Text(
                          option['label'],
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
                        ),
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.check,
                                color: Theme.of(context).iconTheme.color, size: 20),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
