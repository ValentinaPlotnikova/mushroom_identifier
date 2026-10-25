import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  static const Set<String> _allowedExtensions = {
    'jpg',
    'jpeg',
    'png',
  };

  Future<File?> pickFromCamera() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );

    return _validate(file);
  }

  Future<File?> pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 90,
    );

    return _validate(file);
  }

  File? _validate(XFile? file) {
    if (file == null) return null;

    final name = file.name.toLowerCase();
    final dotIndex = name.lastIndexOf('.');
    final extension = dotIndex >= 0 ? name.substring(dotIndex + 1) : '';

    if (!_allowedExtensions.contains(extension)) {
      throw const ImageFormatException(
        'image_unsupported_format',
      );
    }

    return File(file.path);
  }
}

class ImageFormatException implements Exception {
  final String message;

  const ImageFormatException(this.message);

  @override
  String toString() => message;
}
