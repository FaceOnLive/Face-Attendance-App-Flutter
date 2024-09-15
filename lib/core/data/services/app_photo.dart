import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/worker_manager.dart';

class AppPhotoService {
  static Future<File?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      return workerManager.execute<File?>(
        () => _processAndCropImage(pickedFile.path),
        priority: WorkPriority.high,
      );
    } else {
      print('No image selected.');
      return null;
    }
  }

  static Future<File?> getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      return workerManager.execute<File?>(
        () => _processAndCropImage(pickedFile.path),
        priority: WorkPriority.high,
      );
    } else {
      print('No image selected.');
      return null;
    }
  }

  static Future<File?> _processAndCropImage(String imagePath) async {
    final imageFile = File(imagePath);
    return _goToImageCropper(imageFile);
  }

  static Future<File?> _goToImageCropper(File? imageFile) async {
    if (imageFile == null) return null;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile == null) return null;

    final myFile = await croppedFile.readAsBytes();
    return File.fromRawPath(myFile);
  }

  static Future<File> fileFromImageUrl(String imageUrl) async {
    File? cachedImage = await getImageFromCache(imageUrl);
    if (cachedImage != null) return cachedImage;

    return workerManager.execute<File>(
      () => downloadAndSaveImage(imageUrl),
      priority: WorkPriority.high,
    );
  }

  static Future<File> downloadAndSaveImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(
        '${documentDirectory.path}/downloaded_image_${DateTime.now().millisecondsSinceEpoch}');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static Future<File?> getImageFromCache(String imageUrl) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
    return fileInfo?.file;
  }
}
