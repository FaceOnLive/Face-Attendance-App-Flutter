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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: SafeArea(
          child: Column(
            children: [
              GetBuilder<AppCameraController>(
                init: AppCameraController(),
                builder: (controller) => controller.activatingCamera == true
                    ? Expanded(
                        child: Center(child: CircularProgressIndicator()))
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
              ),
            ],
          ),
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
