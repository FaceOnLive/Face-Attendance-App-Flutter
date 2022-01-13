import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/worker_manager.dart';

import '../../../../core/constants/constants.dart';

class AppPhotoService {
  static Future<File?> getImageFromGallery() async {
    File? _image;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _image = await _goToImageCropper(File(pickedFile.path));
      return _image;
    } else {
      print('No image selected.');
    }
    return _image;
  }

  static Future<File?> getImageFromCamera() async {
    File? _image;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      _image = await _goToImageCropper(File(pickedFile.path));
      return _image;
    } else {
      print('No image selected.');
    }
    return _image;
  }

  /* <---- Image Cropper ----> */
  static Future<File> _goToImageCropper(File? imageFile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Prefered Size 500x500',
          toolbarColor: AppColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Cropper',
        ));
    return croppedFile!;
  }

  /// Gives a File From an url
  /// If the file is in cache you will get the cached file
  static Future<File> fileFromImageUrl(String imageUrl) async {
    File? _gotImage;

    // IF the file is available in cache
    File? _imageFromCache = await getImageFromCache(imageUrl);

    if (_imageFromCache != null) {
      _gotImage = _imageFromCache;
    } else {
      final response = await http.get(Uri.parse(imageUrl));

      final documentDirectory = await getApplicationDocumentsDirectory();

      final Map<String, dynamic> data = {
        'path': documentDirectory.path,
        'response': response.bodyBytes,
      };

      File _file =
          await Executor().execute(fun1: _writeFileToDiskIsolated, arg1: data);

      _gotImage = _file;
    }

    return _gotImage;
  }

  static Future<File> _writeFileToDiskIsolated(
      Map<String, dynamic> data) async {
    File _theFile = File(data['path'] + 'imagetest');
    _theFile.writeAsBytes(data['response']);
    return _theFile;
  }

  /// Get Image From Cache
  static Future<File?> getImageFromCache(String imageUrl) async {
    File? _dartFile;
    FileInfo? file = await DefaultCacheManager().getFileFromCache(imageUrl);
    if (file != null) {
      _dartFile = file.file;
    } else {
      _dartFile = null;
    }
    return _dartFile;
  }
}
