import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

import '../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class LoginScreenAlt extends StatefulWidget {
  const LoginScreenAlt({Key? key}) : super(key: key);

  @override
  _LoginScreenAltState createState() => _LoginScreenAltState();
}

class _LoginScreenAltState extends State<LoginScreenAlt>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  /* <---- Trigger the animation on face detection ----> */
  late LottieComposition _composition;
  _onFaceVerified() async {
    await Future.delayed(Duration(seconds: 2)).then((value) {
      _controller
        ..duration = _composition.duration
        ..forward();
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Get.offAll(() => EntryPointUI());
        }
      });
    });
  }

  _onFaceUnverified() async {
    print("NEED TO IMPLEMENT UNVERIFIED STATUS ON FACE");
  }

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
          padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
          child: Column(
            children: [
              Container(
                width: Get.width * 0.3,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Hero(
                  tag: AppImages.MAIN_LOGO,
                  child: Image.asset(
                    AppImages.MAIN_LOGO,
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
                      // This one is static
                      // Container(
                      //   width: Get.width * 0.5,
                      //   child: AspectRatio(
                      //     aspectRatio: 1 / 1,
                      //     child: Image.asset(
                      //       AppImages.ILLUSTRATION_FACE,
                      //     ),
                      //   ),
                      // ),
                      Container(
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
                            'Login With Face Verification',
                            style: AppText.h5.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.PRIMARY_COLOR,
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
                  Get.to(() => LoginScreen());
                },
                child: Text(
                  'Sign in With Other Option',
                  style: AppText.b1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => SignUpScreen());
                },
                child: Text(
                  'New User ?',
                  style: AppText.b1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.PRIMARY_COLOR,
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
