import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/camerakit/camera_kit_controller.dart';
import '../../../../core/camerakit/camera_kit_view.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../components/message_pop_up.dart';
import '../components/use_as_a_verifier_button.dart';
import '../controllers/verify_controller.dart';

class VerifierPage extends StatefulWidget {
  const VerifierPage({Key? key}) : super(key: key);

  @override
  State<VerifierPage> createState() => _VerifierPageState();
}

class _VerifierPageState extends State<VerifierPage> {
  /* <---- We should wait a little bit to finish the build,
  because on lower end device it takes time to start the device,
  so the controller doesn't start immedietly.Then we see some white screen, that's why we should wait a little bit.
   -----> */
  final RxBool _isScreenReady = false.obs;

  late CameraKitController _cameraController;

  Future<void> _waitABit() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ).then((value) {});
    _isScreenReady.trigger(true);
  }

  /// State
  @override
  void initState() {
    super.initState();
    _cameraController = Get.put(CameraKitController());
    _waitABit();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    Get.delete<CameraKitController>(force: true);
    _isScreenReady.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Verifier',
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Obx(() => _isScreenReady.isFalse
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const _CameraSection()),
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
    return GetBuilder<CameraKitController>(
      builder: (controller) {
        return Expanded(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                // child: CameraPreview(controller.cameraController),
                child: controller.isCameraPaused
                    ? CameraPausedWidget(onResume: () {
                        controller.resumeCamera();
                      })
                    : CameraKitView(
                        doFaceAnalysis: true,
                        scaleType: ScaleTypeMode.fit,
                        onRecognized: (serachID) {
                          print("Recognized");
                          print("-----serach id: " + serachID.toString());
                          Get.find<VerifyController>()
                              .onRecognizedMember(verifiedUserIDint: serachID);
                          controller.pauseCamera();
                        },
                        previewFlashMode: CameraFlashMode.auto,
                        cameraKitController: controller,
                        androidCameraMode: AndroidCameraMode.apiX,
                        cameraSelector: CameraSelector.front,
                      ),
              ),
              /* <---- Verifier Button ----> */
              Positioned(
                bottom: 0,
                child: Column(
                  children: const [
                    UseAsAVerifierButton(),
                  ],
                ),
              ),

              // /* <---- Camera Switch Button ----> */
              // Positioned(
              //   top: 15,
              //   right: 10,
              //   child: Opacity(
              //     opacity: 0.5,
              //     child: FloatingActionButton(
              //       onPressed: controller.toggleCameraLens,
              //       child: const Icon(Icons.switch_camera_rounded),
              //       backgroundColor: AppColors.primaryColor,
              //     ),
              //   ),
              // ),

              /// MESSAGE SHOWING
              Positioned(
                bottom: Get.height * 0.10,
                left: 0,
                right: 0,
                child: const ShowMessagePopUP(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CameraPausedWidget extends StatelessWidget {
  const CameraPausedWidget({
    Key? key,
    required this.onResume,
  }) : super(key: key);

  final void Function() onResume;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Camera Paused',
          style: AppText.h6,
        ),
        Text(
          'The camera is paused to save resource',
          style: AppText.caption,
        ),
        AppSizes.hGap15,
        AppButton(
          label: 'Resume Camera',
          onTap: onResume,
          margin: const EdgeInsets.all(AppDefaults.margin),
        )
      ],
    );
  }
}
