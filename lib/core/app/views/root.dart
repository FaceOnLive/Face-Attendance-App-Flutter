import 'package:face_attendance/core/auth/views/pages/email_address_not_verified.dart';

import '../../../features/04_verifier/views/pages/static_verifier.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/constants.dart';
import '../controllers/core_controller.dart';
import '../../auth/controllers/login_controller.dart';
import '../../themes/themes.dart';
import '../../../features/02_entrypoint/entrypoint.dart';

import '../../../features_user/core/views/entrypoint_member.dart';

//// APP STARTS HERE 💙
// ignore: use_key_in_widget_constructors
class TuringTechApp extends StatelessWidget {
  // Needed for themes
  final settings = Get.put(CoreController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turing Tech',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: settings.appThemeMode(),
      home: const AppRoot(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      // enableLog: false,
    );
  }
}

/// Loading Builder
class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoreController>(
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

class _MainUI extends GetView<CoreController> {
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
        }

        /// If we are checking admin
        else if (_login.currentAuthState.value == AuthState.isCheckingAdmin) {
          // are we checking user is admin
          return const _LoadingApp();
        }

        /// If the user is not admin but a app member
        else if (_login.currentAuthState.value == AuthState.userLoggedIn) {
          return const AppMemberMainUi();
        }

        /// If It is admin
        else if (_login.currentAuthState.value == AuthState.adminLoggedIn) {
          return const EntryPointUI();
        }

        /// If the email is unverified
        else if (_login.currentAuthState.value == AuthState.emailUnverified) {
          return const EmailNotVerifiedScreen();
        }

        /// IF The app is in loading state
        else {
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
