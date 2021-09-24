import '../../../controllers/members/member_controller.dart';
import '../../../controllers/verifier/verify_controller.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../controllers/camera/camera_controller.dart';
import 'static_verifier_LockUnlock.dart';
import '../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';

class StaticVerifierScreen extends StatefulWidget {
  @override
  State<StaticVerifierScreen> createState() => _StaticVerifierScreenState();
}

class _StaticVerifierScreenState extends State<StaticVerifierScreen> {
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
      Get.put(MembersController());
      Get.put(VerifyController());
    });
    _isScreenReady.trigger(true);
  }

  @override
  void initState() {
    super.initState();
    _waitABit();
  }

  @override
  void dispose() {
    Get.delete<AppCameraController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: SafeArea(
          child: Column(
            children: [
              Obx(
                () => _isScreenReady.isFalse
                    ? _LoadingCamera()
                    : _CameraSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingCamera extends StatelessWidget {
  const _LoadingCamera({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width * 0.5,
              child: Hero(
                  tag: AppImages.MAIN_LOGO,
                  child: Image.asset(AppImages.MAIN_LOGO)),
            ),
            CircularProgressIndicator(),
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
                alignment: Alignment.center,
                children: [
                  // CameraPreview(controller.controller),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(controller.cameraController),
                  ),

                  /* <---- Verifier Button ----> */
                  Positioned(
                    width: Get.width * 0.9,
                    bottom: Get.height * 0.04,
                    child: _UnlockButton(),
                  ),
                  /* <---- Camear Switch Button ----> */
                  Positioned(
                    bottom: Get.height * 0.14,
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
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.defaulBorderRadius,
        boxShadow: AppDefaults.defaultBoxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              String _url = 'https://turingtech.vip';
              // Launch Website
              await canLaunch(_url)
                  ? await launch(_url)
                  : throw 'Could not launch $_url';
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                AppImages.MAIN_LOGO,
              ),
            ),
          ),
          Text(
            'Verifier',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.bottomSheet(StaticVerifierLockUnlock(),
                  isScrollControlled: true);
            },
            icon: Icon(Icons.lock),
          ),
        ],
      ),
    );
  }
}
