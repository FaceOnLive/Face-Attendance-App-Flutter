import 'dart:io';
import '../../constants/constants.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AppPhotoService {
  static Future<File?> getImageFromGallery() async {
    File? _image;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

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
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Prefered Size 500x500',
          toolbarColor: AppColors.PRIMARY_COLOR,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    return croppedFile!;
  }

  /// Gives a File From an url
  /// If the file is in cache it will priotize that
  static Future<File> fileFromImageUrl(String imageUrl) async {
    // IF the file is available in cache
    File? _imageFromCache = await getImageFromCache(imageUrl);

    File? _gotImage;

    if (_imageFromCache != null) {
      _gotImage = _imageFromCache;
    } else {
      final response = await http.get(Uri.parse(imageUrl));

      final documentDirectory = await getApplicationDocumentsDirectory();

      final _file = File(join(documentDirectory.path, 'imagetest.png'));

      _file.writeAsBytesSync(response.bodyBytes);

      _gotImage = _file;
    }

    return _gotImage;
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
