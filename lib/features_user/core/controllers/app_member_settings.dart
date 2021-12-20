import 'package:face_attendance/features_user/home/views/home.dart';
import 'package:face_attendance/features_user/profile/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

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
