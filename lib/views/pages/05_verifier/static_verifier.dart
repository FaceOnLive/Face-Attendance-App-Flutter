import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../constants/app_sizes.dart';
import '../../../controllers/members/member_controller.dart';
import '../../../controllers/verifier/verify_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../controllers/camera/camera_controller.dart';
import 'static_verifier_LockUnlock.dart';
import '../../themes/text.dart';

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
    _isScreenReady.close();
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
                  /* <---- Camera Switch Button ----> */
                  Positioned(
                    top: Get.height * 0.1,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: controller.toggleCameraLens,
                      child: Icon(Icons.switch_camera_rounded),
                      backgroundColor: AppColors.PRIMARY_COLOR,
                    ),
                  ),

                  /// MESSAGE SHOWING
                  Positioned(
                    bottom: Get.height * 0.15,
                    left: 0,
                    right: 0,
                    child: _ShowMessage(),
                  ),

                  /// TEMPORARY
                  _TemporaryFunctionToCheckMethod(),
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
              margin: EdgeInsets.all(AppSizes.DEFAULT_MARGIN),
              padding: EdgeInsets.all(10),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDefaults.defaulBorderRadius,
                boxShadow: AppDefaults.defaultBoxShadow,
              ),
              child: controller.isVerifyingNow
                  ? Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          AppSizes.wGap10,
                          Text('Verifying'),
                        ],
                      ),
                    )
                  : controller.verifiedMember == null
                      ? ListTile(
                          title: Text('No Member Found'),
                          trailing: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        )
                      : ListTile(
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                controller.verifiedMember!.memberPicture),
                          ),
                          title: Text(controller.verifiedMember!.memberName),
                          subtitle: Text(controller.verifiedMember!.memberNumber
                              .toString()),
                          trailing: Icon(
                            Icons.check_box_rounded,
                            color: AppColors.APP_GREEN,
                          ),
                        ),
            ),
          ),
        );
      },
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
      top: Get.height * 0.12,
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
                  'This is a dummy function, you should return the real value',
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
          // FloatingActionButton.extended(
          //   onPressed: () async {
          //     XFile _image = await controller.cameraController.takePicture();
          //     Uint8List _file = await _image.readAsBytes();

          //     String _currentUserImageUrl =
          //         Get.find<AppUserController>().currentUser.userProfilePicture!;
          //     File _currentUserImage =
          //         await AppPhotoService.fileFromImageUrl(_currentUserImageUrl);

          //     bool _isVerified =
          //         await Get.find<VerifyController>().verfiyPersonSingle(
          //       capturedImage: _file,
          //       personImage: _currentUserImage,
          //     );

          //     if (_isVerified) {
          //       Get.snackbar(
          //         'Person Verified Successfull',
          //         'Verified Member',
          //         colorText: Colors.white,
          //         backgroundColor: Colors.green,
          //       );
          //     }
          //   },
          //   label: Text('Verify Single'),
          //   icon: Icon(Icons.person),
          //   backgroundColor: AppColors.PRIMARY_COLOR,
          // ),
        ],
      ),
    );
  }
}
