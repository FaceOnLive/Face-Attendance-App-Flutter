import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/controllers/camera_controller.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data/services/app_photo.dart';
import '../../../07_settings/views/controllers/user_controller.dart';
import '../controllers/verify_controller.dart';

class TemporaryFunctionToCheckMethod extends GetView<AppCameraController> {
  const TemporaryFunctionToCheckMethod({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Get.height * 0.12,
      child: Column(
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              // XFile _image = await controller.cameraController.takePicture();
              // Uint8List _file = await _image.readAsBytes();

              // bool _isPersonPresent = await Get.find<VerifyController>()
              //     .isPersonDetected(capturedImage: _file);
              //
              // if (_isPersonPresent) {
              //   Get.snackbar(
              //     'A Face is detected',
              //     'This is a dummy function, you should return the real value',
              //     colorText: Colors.white,
              //     backgroundColor: Colors.green,
              //   );
              // }
            },
            label: const Text('Detect Person'),
            icon: const Icon(Icons.camera),
            backgroundColor: AppColors.primaryColor,
          ),
          AppSizes.hGap20,
          /* <----  -----> */
          FloatingActionButton.extended(
            onPressed: () async {
              XFile _image = await controller.cameraController.takePicture();
              Uint8List _uin8file = await _image.readAsBytes();
              // File _file = File.fromRawPath(_uin8file);

              String? user = await Get.find<VerifyController>()
                  .verifyPersonList(memberToBeVerified: _uin8file);

              if (user != null) {
                Get.snackbar(
                  'Person Verified: $user',
                  'Verified Member',
                  colorText: Colors.white,
                  backgroundColor: Colors.green,
                );
              }
            },
            label: const Text('Verify From All'),
            icon: const Icon(Icons.people_alt_rounded),
            backgroundColor: AppColors.primaryColor,
          ),
          AppSizes.hGap20,
          /* <----  -----> */
          FloatingActionButton.extended(
            onPressed: () async {
              XFile _image = await controller.cameraController.takePicture();
              Uint8List _file = await _image.readAsBytes();

              String _currentUserImageUrl =
                  Get.find<AppUserController>().currentUser.userProfilePicture!;
              File _currentUserImage =
                  await AppPhotoService.fileFromImageUrl(_currentUserImageUrl);

              bool _isVerified =
                  await Get.find<VerifyController>().verfiyPersonSingle(
                capturedImage: _file,
                personImage: _currentUserImage,
              );

              if (_isVerified) {
                Get.snackbar(
                  'Person Verified Successfull',
                  'Verified Member',
                  colorText: Colors.white,
                  backgroundColor: Colors.green,
                );
              }
            },
            label: const Text('Verify Single'),
            icon: const Icon(Icons.person),
            backgroundColor: AppColors.primaryColor,
          ),
          AppSizes.hGap10,
        ],
      ),
    );
  }
}
