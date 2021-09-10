import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/controllers/navigation/nav_controller.dart';
import 'package:face_attendance/utils/ui_helper.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      builder: (controller) {
        return FutureBuilder<bool>(
            future: controller.onAppStart(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                return GestureDetector(
                  onTap: () {
                    AppUiHelper.dismissKeyboard(context: context);
                  },
                  child: controller.appRootNavigation(),
                );
              } else {
                return _LoadingApp();
              }
            });
      },
    );
  }
}

class _LoadingApp extends StatelessWidget {
  /// When Starting the database and other services which is asynchronise,
  /// this will give a user a feedback, so that user won't see a black screen.
  const _LoadingApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
      ),
    );
  }
}
