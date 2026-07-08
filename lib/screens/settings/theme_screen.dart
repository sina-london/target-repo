import 'package:flutter/material.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  bool _isDarkMode = false; // Default to false, i.e., light mode
  String? _selectedTheme = 'Dark';
  final List<Map<String, dynamic>> _themeOptions = [
    {'icon': Icons.sunny, 'label': 'Light'},
    {'icon': Icons.dark_mode, 'label': 'Dark'},
    {'icon': Icons.brightness_auto, 'label': 'Auto'}
  ];

  @override
  Widget build(BuildContext context) {
    // Icon and label for each theme mode

    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme", style: TextStyle(fontSize: 35)),
        toolbarHeight: 200,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Themes",
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(),
                // Theme mode options using ListView
                ..._themeOptions.map((option) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTheme = option['label'];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              if (_selectedTheme == option['label'])
                                Icon(Icons.check),
                              Icon(option['icon'] as IconData)
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
