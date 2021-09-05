import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/views/pages/02_auth/login_screen.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                      Container(
                        width: Get.width * 0.5,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(
                            AppImages.LOGIN_FACE_LOGO,
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
                  Get.to(() => LoginScreenAlt());
                },
                child: Text('Sign In With Other Option'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
