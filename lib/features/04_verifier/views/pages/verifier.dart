import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../camerakit/camera_kit_controller.dart';
import '../../../../camerakit/camera_kit_view.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../controllers/verify_controller.dart';
import 'static_verifier_sheet_lock.dart';
import '../components/temporary_functions.dart';

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
  final RxBool _isScreenReady = false.obs;

  Future<void> _waitABit() async {
    await Future.delayed(
      const Duration(seconds: 1),
    ).then((value) {
      Get.put(CameraKitController());
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
      builder: (controller) => Expanded(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              // child: CameraPreview(controller.cameraController),
              child: CameraKitView(
                doFaceAnalysis: true,
                scaleType: ScaleTypeMode.fit,
                onRecognized: (serachID) {
                  print("Recognized");
                  print("-----serach id: " + serachID.toString());
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
                  _UseAsAVerifierButton(),
                ],
              ),
            ),
            /* <---- Camera Switch Button ----> */
            Positioned(
              top: 15,
              right: 10,
              child: Opacity(
                opacity: 0.5,
                child: FloatingActionButton(
                  onPressed: controller.toggleCameraLens,
                  child: const Icon(Icons.switch_camera_rounded),
                  backgroundColor: AppColors.primaryColor,
                ),
              ),
            ),

            /// MESSAGE SHOWING
            Positioned(
              bottom: Get.height * 0.10,
              left: 0,
              right: 0,
              child: const _ShowMessage(),
            ),

            /// TEMPORARY
            // const TemporaryFunctionToCheckMethod(),
          ],
        ),
      ),
    );
  }
}

class _ShowMessage extends StatelessWidget {
  /// This will show up when verification started
  const _ShowMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyController>(
      builder: (controller) {
        return Center(
          child: AnimatedOpacity(
            // IF We Should show the card
            opacity: controller.showProgressIndicator ? 1.0 : 0.0,
            duration: AppDefaults.defaultDuration,
            child: AnimatedContainer(
              duration: AppDefaults.defaultDuration,
              margin: const EdgeInsets.all(AppSizes.defaultMargin),
              padding: const EdgeInsets.all(10),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDefaults.defaulBorderRadius,
                boxShadow: AppDefaults.defaultBoxShadow,
              ),
              child: controller.isVerifyingNow
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          AppSizes.wGap10,
                          Text('Verifying'),
                        ],
                      ),
                    )
                  : controller.verifiedMember == null
                      ? const ListTile(
                          title: Text('No Member Found'),
                          trailing: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        )
                      : ListTile(
                          leading: MemberImageLeading(
                            imageLink: controller.verifiedMember!.memberPicture,
                          ),
                          title: Text(controller.verifiedMember!.memberName),
                          subtitle: Text(controller.verifiedMember!.memberNumber
                              .toString()),
                          trailing: const Icon(
                            Icons.check_box_rounded,
                            color: AppColors.appGreen,
                          ),
                        ),
            ),
          ),
        );
      },
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
            const StaticVerifierLockUnlock(
              isLockMode: true,
            ),
            isScrollControlled: true);
      },
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.defaultRadius),
            topRight: Radius.circular(AppSizes.defaultRadius),
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
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
