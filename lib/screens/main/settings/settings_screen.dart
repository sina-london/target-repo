import 'package:flutter/material.dart';
import 'package:nekoflow/screens/settings/theme_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 200,
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 35),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.color_lens, size: 35),
            title: Text("Theme", style: TextStyle(fontSize: 20)),
            subtitle: Text("Change the app theme"),
            trailing: Icon(Icons.navigate_next, size: 35),
            onTap: () => Navigator.push(
              context,
              ModalBottomSheetRoute(
                  builder: (context) => ThemeScreen(),
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  useSafeArea: true),
            ),
          ),
        ],
      ),
    );
  }
}
