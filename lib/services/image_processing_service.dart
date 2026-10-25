import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageProcessingService {
  static const int targetSize = 224;

  Future<File> process(File source) async {
    final bytes = await source.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw const ImageProcessingException(
        'image_decode_failed',
      );
    }

    final oriented = img.bakeOrientation(decoded);

    final scale = targetSize / _maxSide(oriented);

    final newWidth = (oriented.width * scale).round().clamp(1, targetSize);

    final newHeight = (oriented.height * scale).round().clamp(1, targetSize);

    final resized = img.copyResize(
      oriented,
      width: newWidth,
      height: newHeight,
      interpolation: img.Interpolation.average,
    );

    final canvas = img.Image(
      width: targetSize,
      height: targetSize,
    );

    img.fill(
      canvas,
      color: img.ColorRgb8(255, 255, 255),
    );

    final offsetX = ((targetSize - newWidth) / 2).round();
    final offsetY = ((targetSize - newHeight) / 2).round();

    img.compositeImage(
      canvas,
      resized,
      dstX: offsetX,
      dstY: offsetY,
    );

    final jpg = img.encodeJpg(
      canvas,
      quality: 90,
    );

    final tempDir = await getTemporaryDirectory();

    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final outPath = '${tempDir.path}/mushroom_processed_$timestamp.jpg';

    final outFile = File(outPath);

    await outFile.writeAsBytes(
      jpg,
      flush: true,
    );

    return outFile;
  }

  int _maxSide(img.Image image) {
    return image.width >= image.height ? image.width : image.height;
  }
}

class ImageProcessingException implements Exception {
  final String message;

  const ImageProcessingException(this.message);

  @override
  String toString() => message;
}
