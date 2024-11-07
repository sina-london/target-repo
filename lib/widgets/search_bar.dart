// This file is located at: lib/widgets/search_bar.dart
import 'package:flutter/material.dart';

class Searchbar extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearch;

  const Searchbar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onEditingComplete: () => onSearch(),
              decoration: InputDecoration(
                  hintText: "Search Anime...", border: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
