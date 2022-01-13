import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/camerakit/camera_kit_controller.dart';
import '../../../../core/camerakit/camera_kit_view.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../../../05_members/views/controllers/member_controller.dart';
import '../controllers/user_serial_keeper.dart';
import '../controllers/verify_controller.dart';
import '../dialogs/static_verifier_sheet_lock.dart';

class StaticVerifierScreen extends StatefulWidget {
  const StaticVerifierScreen({Key? key}) : super(key: key);

  @override
  State<StaticVerifierScreen> createState() => _StaticVerifierScreenState();
}

class _StaticVerifierScreenState extends State<StaticVerifierScreen> {
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
      Get.put(MembersController());
      Get.put(VerifyController());
      Get.put(UserSerialKeeper());
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
    Get.delete<CameraKitController>(force: true);
    _isScreenReady.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: SafeArea(
          child: Column(
            children: [
              Obx(
                () => _isScreenReady.isFalse
                    ? const _LoadingCamera()
                    : const _CameraSection(),
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
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width * 0.5,
              child:
                  Hero(tag: AppImages.logo, child: Image.asset(AppImages.logo)),
            ),
            const CircularProgressIndicator(),
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
      init: CameraKitController(),
      builder: (controller) => Expanded(
        child: Stack(
          alignment: Alignment.center,
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
                  Get.find<VerifyController>()
                      .onRecognizedMember(verifiedUserIDint: serachID);
                },
                previewFlashMode: CameraFlashMode.auto,
                cameraKitController: controller,
                androidCameraMode: AndroidCameraMode.apiX,
                cameraSelector: CameraSelector.front,
              ),
            ),
            /* <---- Verifier Button ----> */
            Positioned(
              width: Get.width * 0.9,
              bottom: Get.height * 0.04,
              child: const _UnlockButton(),
            ),
            /* <---- Camera Switch Button ----> */
            Positioned(
              top: Get.height * 0.1,
              right: 10,
              child: FloatingActionButton(
                onPressed: controller.toggleCameraLens,
                child: const Icon(Icons.switch_camera_rounded),
                backgroundColor: AppColors.primaryColor,
              ),
            ),

            /// MESSAGE SHOWING
            Positioned(
              bottom: Get.height * 0.15,
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

class _UnlockButton extends StatelessWidget {
  const _UnlockButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        boxShadow: AppDefaults.boxShadow,
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
            child: const CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(
                AppImages.logo,
              ),
            ),
          ),
          Text(
            'Verifier',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Get.bottomSheet(const StaticVerifierLockUnlock(),
                  isScrollControlled: true);
            },
            icon: const Icon(Icons.lock),
          ),
        ],
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
            duration: AppDefaults.duration,
            child: AnimatedContainer(
              duration: AppDefaults.duration,
              margin: const EdgeInsets.all(AppDefaults.margin),
              padding: const EdgeInsets.all(10),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDefaults.borderRadius,
                boxShadow: AppDefaults.boxShadow,
              ),
              child: controller.isVerifyingNow
                  ? Container(
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
