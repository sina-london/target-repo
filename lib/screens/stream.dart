// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class Stream extends StatefulWidget {
  final String id; // Declare a final variable to accept the ID string

  const Stream({super.key, required this.id}); // Add id to the constructor

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Text(
            'Stream ID: ${widget.id}', // Access the ID using widget.id
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
