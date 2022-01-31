import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/02_entrypoint/entrypoint.dart';
import '../../../features/04_verifier/views/pages/static_verifier_page.dart';
import '../../../features_user/core/views/entrypoint_member.dart';
import '../../auth/controllers/login_controller.dart';
import '../../auth/views/pages/email_not_verified_page.dart';
import '../../themes/themes.dart';
import '../controllers/core_controller.dart';
import 'components/loading_app.dart';

//// APP STARTS HERE 💙
class TuringTechApp extends StatelessWidget {
  final CoreController core;

  const TuringTechApp({Key? key, required this.core}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Turing Tech',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: core.appThemeMode(),
      home: const AppRoot(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
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
          return const LoadingApp();
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
      /// When the app has been locked into static verifier mode
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
          return const LoadingApp();
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
          return const EmailNotVerifiedPage();
        }

        /// IF The app is in loading state
        else {
          return const LoadingApp();
        }
      });
    }
  }
}
