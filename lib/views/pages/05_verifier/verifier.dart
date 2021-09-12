import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/camera/camera_controller.dart';
import '../../themes/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'static_verifier_unlock.dart';

class VerifierScreen extends StatelessWidget {
  const VerifierScreen({Key? key}) : super(key: key);

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
                ],
              ),
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
              isLock: true,
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
