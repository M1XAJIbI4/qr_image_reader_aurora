
import 'qr_image_reader_aurora_platform_interface.dart';

class QrImageReaderAurora {
  Future<String?> analyzeImage(String imagePath) {
    return QrImageReaderAuroraPlatform.instance.analyzeImage(imagePath);
  }
}
