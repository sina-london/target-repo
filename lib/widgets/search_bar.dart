// This file is located at: lib/widgets/search_bar.dart
import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const Searchbar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onEditingComplete: onSearch,
        decoration: const InputDecoration(
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search for Anime...",
        ),
      ),
    );
  }
}
