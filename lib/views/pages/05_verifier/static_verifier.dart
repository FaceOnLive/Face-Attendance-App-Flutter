import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/controllers/camera/camera_controller.dart';
import 'package:face_attendance/views/pages/05_verifier/static_verifier_unlock.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

class StaticVerifierScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifier'),
        leading: BackButton(
          onPressed: () {
            Get.bottomSheet(StaticVerifierUnlock(), isScrollControlled: true);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _CameraSection(),
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
      init: AppCameraController(),
      builder: (controller) => controller.activatingCamera == true
          ? Expanded(child: Center(child: CircularProgressIndicator()))
          : Expanded(
              child: Stack(
                children: [
                  CameraPreview(controller.controller),
                  /* <---- Verifier Button ----> */
                  Positioned(
                    bottom: 0,
                    child: _UnlockButton(),
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
                ],
              ),
            ),
    );
  }
}

class _UnlockButton extends StatelessWidget {
  const _UnlockButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(StaticVerifierUnlock(), isScrollControlled: true);
      },
      child: Container(
        height: Get.height * 0.1,
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
          children: [
            Text(
              'UNLOCK',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
