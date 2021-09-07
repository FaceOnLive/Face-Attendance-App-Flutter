import 'dart:io';
import 'package:face_attendance/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
}
