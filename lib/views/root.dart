import 'pages/05_verifier/static_verifier.dart';
import '../controllers/auth/login_controller.dart';
import 'pages/03_main/main_screen.dart';
import '../constants/app_images.dart';
import '../controllers/navigation/nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: NavigationController(),
      autoRemove: false,
      builder: (controller) {
        if (controller.everyThingLoadedUp) {
          return _MainUI();
        } else {
          return _LoadingApp();
        }
      },
    );
  }
}

class _MainUI extends GetView<NavigationController> {
  const _MainUI({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController _login = Get.find();
    if (controller.isInVerifierMode()) {
      return StaticVerifierScreen();
    } else {
      return Obx(() {
        return _login.user == null ? controller.introOrLogin() : MainScreenUI();
      });
    }
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
