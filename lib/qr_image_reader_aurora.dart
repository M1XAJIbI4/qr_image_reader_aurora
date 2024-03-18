
import 'qr_image_reader_aurora_platform_interface.dart';

class QrImageReaderAurora {
  Future<String?> getPlatformVersion() {
    return QrImageReaderAuroraPlatform.instance.getPlatformVersion();
  }
}
