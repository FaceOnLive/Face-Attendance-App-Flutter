import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/constants.dart';
import '../../../themes/text.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

class LoginPageFace extends StatefulWidget {
  const LoginPageFace({super.key});

  @override
  _LoginPageFaceState createState() => _LoginPageFaceState();
}

class _LoginPageFaceState extends State<LoginPageFace>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  /* <---- Trigger the animation on face detection ----> */
  late LottieComposition _composition;
  _onFaceVerified() {
    _controller
      ..duration = _composition.duration
      ..forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Get.offAll(() => EntryPointUI());
      }
    });
  }

  _onFaceUnverified() {
    AppToast.show('Oops! Your Face Coudn\'t be verfied');
    Get.back();
  }

  bool isVerificationOn = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _onFaceVerified();
    _onFaceUnverified();
  }

  @override
  void dispose() {
    _controller.removeListener(_onFaceUnverified);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            children: [
              Container(
                width: Get.width * 0.3,
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Hero(
                  tag: AppImages.logo,
                  child: Image.asset(
                    AppImages.logo,
                  ),
                ),
              ),
              /* <---- Main Content ----> */
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      /* <---- FaceLOGO ----> */

                      SizedBox(
                        width: Get.width * 0.5,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Lottie.asset(
                            'assets/lottie/face_id.json',
                            controller: _controller,
                            frameRate: FrameRate.max,
                            onLoaded: (composition) {
                              _composition = composition;
                              // _controller
                              //   ..duration = composition.duration
                              //   ..forward();
                            },
                          ),
                        ),
                      ),

                      /* <---- HERO TITLE ----> */
                      Column(
                        children: [
                          Text(
                            'Face Login',
                            style: AppText.h5.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AppSizes.hGap10,
                          Text(
                            'Please put your face in front of you phone',
                            style: AppText.caption,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              /* <---- Sign In With Other Option ----> */
              TextButton(
                onPressed: () {
                  Get.to(() => const LoginPage());
                },
                child: Text(
                  'Sign in With Other Option',
                  style: AppText.b1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SignUpPage());
                },
                child: Text(
                  'New User ?',
                  style: AppText.b1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
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
