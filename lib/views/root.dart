import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_images.dart';
import '../controllers/auth/login_controller.dart';
import '../controllers/settings/settings_controller.dart';
import 'pages/03_entrypoint/entrypoint.dart';
import 'pages/05_verifier/static_verifier.dart';
import 'pages/app_member/01_entrypoint/entrypoint_member.dart';
import 'themes/themes.dart';

//// APP \\
// ignore: use_key_in_widget_constructors
class TuringTechApp extends StatelessWidget {
  // Needed for themes
  final settings = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turing Tech',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: settings.appThemeMode(),
      home: const AppRoot(),
      debugShowCheckedModeBanner: false,
      // enableLog: false,
    );
  }
}

/// Loading Builder
class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        // Loading Database, And Firebase
        if (controller.everyThingLoadedUp) {
          return const _MainUI();
        } else {
          return const _LoadingApp();
        }
      },
    );
  }
}

class _MainUI extends GetView<SettingsController> {
  const _MainUI({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController _login = Get.find();
    if (controller.isInVerifierMode()) {
      return const StaticVerifierScreen();
    } else {
      return Obx(() {
        // Intro Screen or Login Screen
        if (_login.user == null) {
          return controller.introOrLogin();
        } else if (_login.isCheckingAdmin.value) {
          // are we checking user is admin
          return const _LoadingApp();
        } else if (!_login.isAdmin) {
          // is the user is admin
          return const AppMemberMainUi();
        } else if (_login.user != null &&
            _login.isCheckingAdmin.value == false &&
            _login.isAdmin == true) {
          // Home sweet home
          return const EntryPointUI();
        } else {
          return const _LoadingApp();
        }
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
        child: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: Get.width * 0.5,
                child: Hero(
                  tag: AppImages.mainLogo,
                  child: Image.asset(AppImages.mainLogo),
                ),
              ),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
