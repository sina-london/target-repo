import 'package:flutter/material.dart';

class Stream extends StatefulWidget {
  final String id;
  final String title;
  const Stream({super.key, required this.id, required this.title});

  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.id),
      ),
    );
  }
}
