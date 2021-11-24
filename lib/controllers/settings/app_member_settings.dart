import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

import '../../views/pages/app_member/02_home/home.dart';
import '../../views/pages/app_member/03_profile/profile.dart';

class AppMemberSettingsController extends GetxController {
  /// Used in entry point screen
  int currentIndex = 0;
  onNavTap(int index) {
    currentIndex = index;
    update();
  }

  /// Decides Which Page to return based on the nav index
  Widget currentSelectedPage() {
    if (currentIndex == 0) {
      return const AppMemberHomeScreen();
    } else if (currentIndex == 1) {
      return const AppMemberProfileScreen();
    } else {
      return const AppMemberHomeScreen();
    }
  }
}
