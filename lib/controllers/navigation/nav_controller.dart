import 'package:face_attendance/views/pages/01_intro/intro_screen.dart';
import 'package:face_attendance/views/pages/02_auth/login_screen.dart';
import 'package:face_attendance/views/pages/03_main/main_screen.dart';
import 'package:face_attendance/views/pages/04_attendance/attendance.dart';
import 'package:face_attendance/views/pages/05_verifier/verifier.dart';
import 'package:face_attendance/views/pages/06_members/members.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NavigationController extends GetxController {
  /* <---- Main App Navigation ----> */
  Future<Widget> appRootNavigation() async {
    // Temporary Value
    bool userloggedIn = false;

    if (await isIntroDone() == false) {
      return IntroScreen();
    } else if (userloggedIn == true) {
      return MainScreenUI();
    } else {
      return LoginScreenAlt();
    }
  }

  /// Used For Home Navigation
  int currentIndex = 0;

  onNavTap(int index) {
    currentIndex = index;
    update();
  }

  /// Decides Which Page to return based on the nav index
  Widget currentSelectedPage() {
    if (currentIndex == 0) {
      return AttendanceScreen();
    } else if (currentIndex == 1) {
      return VerifierScreen();
    } else if (currentIndex == 2) {
      return MembersScreen();
    } else {
      return AttendanceScreen();
    }
  }

  /* <---- Intro Screen Related ----> */
  /// Used For Storing Data
  static const String _APPS_BOOL_BOX = 'appsBool';
  static const String _BOX_KEY_INTRO = 'introDone';

  /// Save a bool that intro screen has already been showed
  Future<void> introScreenDone() async {
    Box<bool> box = await Hive.openBox(_APPS_BOOL_BOX);
    box.put(_BOX_KEY_INTRO, true);
    print('Done');
  }

  /// Returns true/false if the intro has been done
  Future<bool> isIntroDone() async {
    Box<bool> box = await Hive.openBox(_APPS_BOOL_BOX);
    bool _isDone = box.get(_BOX_KEY_INTRO) ?? false;
    return _isDone;
  }
}
