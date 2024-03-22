import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
    "assets/qr_code_bmp.bmp",
    "assets/qr_code_jpeg.jpeg",
    "assets/qr_code_png.png",
    "assets/qr_code_tiff.tiff",
  ];

  final _qrImageReaderAuroraPlugin = QrImageReaderAurora();
  final _resultMaps = <String, ValueNotifier<String>>{};
  bool _isAnalyzing = false;

  Future<String?> _analyzeImage(String filePath) async {
    String? result;
    try {
      result = await _qrImageReaderAuroraPlugin.analyzeImage(filePath) ??
          'no qr code';
    } on PlatformException {
      print("ERROR PLATFORM EXCEPTION ");
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    for (final f in _files) {
      _resultMaps[f] = ValueNotifier<String>('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView.separated(
        itemCount: _files.length,
        itemBuilder: (_, index) {
          final asset = _files[index];
          return Column(
            children: [
              SizedBox(
                height: 100,
                child: Image.asset(asset),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _onAnalyzeTap(asset),
                    child: const Text('Analyze'),
                  ),
                  const SizedBox(width: 20),
                  if (_resultMaps[asset] != null) ValueListenableBuilder(
                    valueListenable: _resultMaps[asset]!, 
                    builder: (_, res, __) => Text(res),
                  )
                ],
              ),
            ],
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 10),
      ),
    ));
  }

  Future<void> _onAnalyzeTap(String assetPath) async {
    if (!_isAnalyzing) {
      _isAnalyzing = true;
      try {
        final byteData = await rootBundle.load(assetPath);
        final file = File('${(await getTemporaryDirectory()).path}/$assetPath');
        await file.create(recursive: true);
        await file.writeAsBytes(byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

        final analyzeResult = await _analyzeImage(file.path);
        if (analyzeResult != null) {
          _resultMaps[assetPath]?.value = analyzeResult;
        }
        await file.delete();
      } catch (_) {
      } finally {
        _isAnalyzing = false;
      }
    }
  }

  @override
  void dispose() {
    for (final v in _resultMaps.values) {
      v.dispose();
    }
    super.dispose();
  }
}
