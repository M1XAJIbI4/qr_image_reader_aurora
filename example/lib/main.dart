import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:qr_image_reader_aurora/qr_image_reader_aurora.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _files = [
    "/home/defaultuser/Pictures/qr_code.bmp",
    "/home/defaultuser/Pictures/qr_code.jpg",
    "/home/defaultuser/Pictures/qr_code.png",
    "/home/defaultuser/Pictures/qr_code.tiff",
    'asgag'
  ];

  final _qrImageReaderAuroraPlugin = QrImageReaderAurora();
  final _resultNotifier = ValueNotifier<String?>(null);

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String?> _analyzeImage(String filePath) async {
    String? result;
    try {
      result = await _qrImageReaderAuroraPlugin.analyzeImage(filePath) ??
          'Unknown platform version';
    } on PlatformException {
      print("ERROR PLATFORM EXCEPTION ");
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ValueListenableBuilder<String?>(
            valueListenable: _resultNotifier,
            builder: (_, result, __) {
              final text =
                  (result ?? '').isNotEmpty ? result! : 'no qr code on file';
              return AnimatedSwitcher(
                duration: kThemeAnimationDuration,
                child: Text(text),
              );
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0) + const EdgeInsets.only(top: 80),
          child: Column(
            children: _files.map((e) => _getButton(e)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _getButton(String path) {
    return TextButton(
      onPressed: () async {
        final result = await _analyzeImage(path);
        _resultNotifier.value = result;
      },
      child: Text(path),
    );
  }

  @override
  void dispose() {
    _resultNotifier.dispose();
    super.dispose();
  }
}
