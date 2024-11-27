import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied || await Permission.storage.isRestricted) {
        // Request permission for Android 12 and below
        var result = await Permission.photos.request();
        debugPrint('Storage permission result: $result');
        if (result.isGranted) {
          _showMessage("Storage permission granted!");
        } else if (result.isPermanentlyDenied) {
          _showMessage("Permission permanently denied. Open settings to enable it.");
          await openAppSettings();
        }
      } else if (await Permission.storage.isGranted) {
        _showMessage("Storage permission already granted!");
      } else {
        _showMessage("Storage permission denied.");
      }

      // Request granular permissions for Android 13+
      if (Platform.isAndroid && await Permission.mediaLibrary.isDenied) {
        var mediaResult = await [
          Permission.mediaLibrary,
          Permission.photos,
          Permission.videos,
        ].request();
        debugPrint('Granular media permissions result: $mediaResult');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: Center(
        child: ElevatedButton(
          onPressed: _requestStoragePermission,
          child: const Text('Request Storage Permission'),
        ),
      ),
    );
  }
}
