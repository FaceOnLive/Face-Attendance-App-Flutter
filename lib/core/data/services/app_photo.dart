import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AppPhotoService {
  static Future<File?> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      return _isolateTask(_processAndCropImage, pickedFile.path);
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
      return _isolateTask(_processAndCropImage, pickedFile.path);
    } else {
      print('No image captured.');
      return null;
    }
  }

  static Future<File?> _processAndCropImage(String imagePath) async {
    final imageFile = File(imagePath);
    return _goToImageCropper(imageFile);
  }

  static Future<File?> _goToImageCropper(File? imageFile) async {
    if (imageFile == null) {
      print('No image selected.');
      return null;
    } else {
      print('Image path: ${imageFile.path}');

      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (croppedFile == null) {
        print('Image cropping cancelled or failed.');
        return null;
      } else {
        print('Cropped image path: ${croppedFile.path}');

        // Create a File object directly from the path
        final File imageFile = File(croppedFile.path);

        // Print the path to verify
        print('Selected image path: ${imageFile.path}');

        return imageFile;
      }
    }
  }

  static Future<File> fileFromImageUrl(String imageUrl) async {
    File? cachedImage = await getImageFromCache(imageUrl);
    if (cachedImage != null) return cachedImage;

    return _isolateTask(downloadAndSaveImage, imageUrl);
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

  static Future<T> _isolateTask<T>(Function task, dynamic arg) async {
    final ReceivePort receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      _isolateEntry,
      IsolateData(receivePort.sendPort, task, arg),
      debugName: 'ImageProcessingIsolate',
    );

    final result = await receivePort.first as T;
    receivePort.close();
    isolate.kill();
    return result;
  }

  static void _isolateEntry(IsolateData data) async {
    // Initialize BackgroundIsolateBinaryMessenger
    BackgroundIsolateBinaryMessenger.ensureInitialized(data.token);

    final result = await data.task(data.arg);
    data.sendPort.send(result);
  }

  // static Future<File?> downloadImageWithProgress(String imageUrl) async {
  //   final ReceivePort receivePort = ReceivePort();
  //   final token = RootIsolateToken.instance!;
  //   final isolate = await Isolate.spawn(
  //     _downloadWithProgressEntry,
  //     DownloadData(receivePort.sendPort, imageUrl, token),
  //     debugName: 'ImageDownloadIsolate',
  //   );

  //   File? downloadedFile;
  //   await for (var message in receivePort) {
  //     if (message is double) {
  //       print('Download progress: ${message.toStringAsFixed(2)}%');
  //     } else if (message is File) {
  //       downloadedFile = message;
  //       break;
  //     }
  //   }

  //   receivePort.close();
  //   isolate.kill();
  //   return downloadedFile;
  // }

  // static void _downloadWithProgressEntry(DownloadData data) async {
  //   // Initialize BackgroundIsolateBinaryMessenger
  //   BackgroundIsolateBinaryMessenger.ensureInitialized(data.token);

  //   final response = await http.get(Uri.parse(data.imageUrl));
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //   final file = File(
  //       '${documentDirectory.path}/downloaded_image_${DateTime.now().millisecondsSinceEpoch}');

  //   final totalBytes = response.contentLength ?? 0;
  //   var downloadedBytes = 0;

  //   final sink = file.openWrite();
  //   await for (var chunk in response.body.split('')) {
  //     sink.add(chunk.codeUnits);
  //     downloadedBytes += chunk.length;
  //     data.sendPort.send((downloadedBytes / totalBytes) * 100);
  //   }
  //   await sink.close();

  //   data.sendPort.send(file);
  // }
}

class IsolateData {
  final SendPort sendPort;
  final Function task;
  final dynamic arg;
  final RootIsolateToken token;

  IsolateData(this.sendPort, this.task, this.arg)
      : token = RootIsolateToken.instance!;
}

class DownloadData {
  final SendPort sendPort;
  final String imageUrl;
  final RootIsolateToken token;

  DownloadData(this.sendPort, this.imageUrl, this.token);
}
