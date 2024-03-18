import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'qr_image_reader_aurora_platform_interface.dart';

/// An implementation of [QrImageReaderAuroraPlatform] that uses method channels.
class MethodChannelQrImageReaderAurora extends QrImageReaderAuroraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('qr_image_reader_aurora');

  @override
  Future<String?> analyzeImage(String imagePath) async {
    final version = await methodChannel.invokeMethod<String>('analyzeImage');
    return version;
  }
}
