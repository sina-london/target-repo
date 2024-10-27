// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:nekoflow/screens/browse.dart';
import 'package:nekoflow/screens/home.dart';
import 'package:nekoflow/screens/search.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;
  final _screens = [
    Home(),
    Search(),
    Browse(),
    Container(
      color: Colors.green,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
            bottomNavigationBar: NavigationBar(
              elevation: 0.5,
              selectedIndex: _selectedIndex,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                NavigationDestination(
                  icon: Icon(Icons.widgets),
                  label: "Browse",
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            )));
  }
}
