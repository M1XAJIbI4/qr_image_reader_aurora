import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'qr_image_reader_aurora_method_channel.dart';

abstract class QrImageReaderAuroraPlatform extends PlatformInterface {
  QrImageReaderAuroraPlatform() : super(token: _token);

  static final Object _token = Object();

  static QrImageReaderAuroraPlatform _instance = MethodChannelQrImageReaderAurora();

  /// The default instance of [QrImageReaderAuroraPlatform] to use.
  ///
  /// Defaults to [MethodChannelQrImageReaderAurora].
  static QrImageReaderAuroraPlatform get instance => _instance;

  static set instance(QrImageReaderAuroraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> analyzeImage(String imagePath) {
    throw UnimplementedError('analyzeImage() has not been implemented.');
  }
}
