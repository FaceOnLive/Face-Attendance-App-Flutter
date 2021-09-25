import 'dart:io';
import 'dart:typed_data';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/verifier/verify_controller.dart';
import '../../../services/app_photo.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/camera/camera_controller.dart';
import '../../themes/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'static_verifier_LockUnlock.dart';

class VerifierScreen extends StatefulWidget {
  const VerifierScreen({Key? key}) : super(key: key);

  @override
  State<VerifierScreen> createState() => _VerifierScreenState();
}

class _VerifierScreenState extends State<VerifierScreen> {
  /* <---- We should wait a little bit to finish the build,
  because on lower end device it takes time to start the device,
  so the controller doesn't start immedietly.Then we see some white screen, that's why we should wait a little bit.
   -----> */
  RxBool _isScreenReady = false.obs;

  Future<void> _waitABit() async {
    await Future.delayed(
      Duration(seconds: 1),
    ).then((value) {
      Get.put(AppCameraController());
    });
    _isScreenReady.trigger(true);
  }

  /// State
  @override
  void initState() {
    super.initState();
    _waitABit();
  }

  @override
  void dispose() {
    Get.delete<AppCameraController>(force: true);
    _isScreenReady.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Verifier',
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            ),
            Obx(() => _isScreenReady.isFalse
                ? Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _CameraSection()),
          ],
        ),
      ),
    );
  }
}

class _CameraSection extends StatelessWidget {
  const _CameraSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppCameraController>(
      builder: (controller) => controller.activatingCamera == true
          ? Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(controller.cameraController),
                  ),
                  /* <---- Verifier Button ----> */
                  Positioned(
                    bottom: 0,
                    child: _UseAsAVerifierButton(),
                  ),
                  /* <---- Camear Switch Button ----> */
                  Positioned(
                    bottom: Get.height * 0.12,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: controller.toggleCameraLens,
                      child: Icon(Icons.switch_camera_rounded),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    ),
                  ),

                  /// TEMPORARY
                  _TemporaryFunctionToCheckMethod(),
                ],
              ),
            ),
    );
  }
}

class _TemporaryFunctionToCheckMethod extends GetView<AppCameraController> {
  const _TemporaryFunctionToCheckMethod({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: Get.height * 0.12,
      child: Column(
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              XFile _image = await controller.cameraController.takePicture();
              Uint8List _file = await _image.readAsBytes();

              bool _isPersonPresent = await Get.find<VerifyController>()
                  .isPersonDetected(capturedImage: _file);

              if (_isPersonPresent) {
                Get.snackbar(
                  'A Face is detected',
                  'A Person Face is detected',
                  colorText: Colors.white,
                  backgroundColor: Colors.green,
                );
              }
            },
            label: Text('Detect Person'),
            icon: Icon(Icons.camera),
            backgroundColor: AppColors.PRIMARY_COLOR,
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
            label: Text('Verify From All'),
            icon: Icon(Icons.people_alt_rounded),
            backgroundColor: AppColors.PRIMARY_COLOR,
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
            label: Text('Verify Single'),
            icon: Icon(Icons.person),
            backgroundColor: AppColors.PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }
}

class _UseAsAVerifierButton extends StatelessWidget {
  const _UseAsAVerifierButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.bottomSheet(
        //   StaticVerifierPasswordSet(),
        //   isScrollControlled: true,
        // );
        Get.bottomSheet(
            StaticVerifierLockUnlock(
              isLockMode: true,
            ),
            isScrollControlled: true);
      },
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.DEFAULT_RADIUS),
            topRight: Radius.circular(AppSizes.DEFAULT_RADIUS),
          ),
          boxShadow: AppDefaults.defaultBoxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Use as a static verifier',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
