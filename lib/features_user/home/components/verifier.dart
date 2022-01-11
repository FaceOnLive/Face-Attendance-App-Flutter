import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../core/camerakit/camera_kit_controller.dart';
import '../../../core/camerakit/camera_kit_view.dart';
import '../../core/controllers/app_member_verify.dart';

class AppMemberVerifierWidget extends GetView<AppMemberVerifyController> {
  const AppMemberVerifierWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /* <---- Status -----> */
        GetBuilder<AppMemberVerifyController>(
          builder: (_) {
            switch (controller.verifyingState) {
              case VerifyingState.attended:
                {
                  return Image.asset(
                    AppImages.illustrationAttendFound,
                    width: Get.width * 0.8,
                  );
                }
              case VerifyingState.verifying:
                {
                  return const OpenCameraPreview();
                }

              case VerifyingState.verified:
                {
                  return const _VerifyingAnimation();
                }
              case VerifyingState.unverified:
                {
                  return Image.asset(
                    AppImages.illustrationFaceID,
                    width: Get.width * 0.5,
                  );
                }
              default:
                return Image.asset(
                  AppImages.illustrationFaceID,
                  width: Get.width * 0.5,
                );
            }
          },
        ),

        /// Verify Button
        GetBuilder<AppMemberVerifyController>(
          builder: (_) {
            if (controller.verifyingState == VerifyingState.attended) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('You attended today in {Space}'),
                  Icon(
                    Icons.check_box_rounded,
                    color: AppColors.appGreen,
                  ),
                ],
              );
            } else if (controller.verifyingState == VerifyingState.unverified) {
              return Column(
                children: [
                  AppButton(
                    label: 'Verify, it\'s you',
                    width: Get.width * 0.5,
                    fontSize: AppText.h6.fontSize,
                    onTap: controller.verifyUser,
                  ),
                  Text(
                    'Once you are in your space location \n press the verify button',
                    textAlign: TextAlign.center,
                    style: AppText.caption,
                  )
                ],
              );
            } else {
              return const Center(
                child: Text('Error with widgetdata'),
              );
            }
          },
        ),
      ],
    );
  }
}

class _VerifyingAnimation extends StatelessWidget {
  const _VerifyingAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/face_id.json',
          frameRate: FrameRate.max,
          width: Get.width * 0.5,
          repeat: true,
        ),
        AppSizes.hGap10,
        Text(
          'Checking...',
          style: AppText.caption,
        )
      ],
    );
  }
}

class OpenCameraPreview extends StatefulWidget {
  const OpenCameraPreview({Key? key}) : super(key: key);

  @override
  State<OpenCameraPreview> createState() => _OpenCameraPreviewState();
}

class _OpenCameraPreviewState extends State<OpenCameraPreview> {
  @override
  void initState() {
    super.initState();
    Get.put(CameraKitController());
  }

  @override
  void dispose() {
    Get.delete<CameraKitController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const _CameraSection();
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
                child: CameraKitView(
                  doFaceAnalysis: true,
                  scaleType: ScaleTypeMode.fit,
                  onRecognized: (int serachID) {
                    if (serachID == 1) {
                      controller.pauseCamera();
                      Get.find<AppMemberVerifyController>().onRecognizedUser();
                    }
                  },
                  previewFlashMode: CameraFlashMode.auto,
                  cameraKitController: controller,
                  androidCameraMode: AndroidCameraMode.apiX,
                  cameraSelector: CameraSelector.front,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
