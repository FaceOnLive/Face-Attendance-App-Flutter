import 'package:face_attendance/views/pages/01_intro/intro_screen.dart';
import 'package:face_attendance/views/pages/02_auth/login_screen.dart';
import 'package:face_attendance/views/pages/03_main/main_screen.dart';
import 'package:face_attendance/views/pages/04_attendance/attendance.dart';
import 'package:face_attendance/views/pages/05_verifier/verifier.dart';
import 'package:face_attendance/views/pages/06_members/members.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NavigationController extends GetxController {
  Future<bool> onAppStart() async {
    try {
      // STARTING THE APP
      await Firebase.initializeApp();
      await Hive.initFlutter();
      // This is for reducing the time on start app
      await Hive.openBox(_APPS_BOOL_BOX);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /* <---- Main App Navigation ----> */
  Widget appRootNavigation() {
    // Temporary Value
    bool userloggedIn = false;

    if (isIntroDone() == false) {
      return IntroScreen();
    } else if (userloggedIn == true) {
      return MainScreenUI();
    } else {
      return LoginScreenAlt();
    }
  }

  /* <---- Home Navigation ----> */
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
  bool isIntroDone() {
    var box = Hive.box(_APPS_BOOL_BOX);
    bool _isDone = box.get(_BOX_KEY_INTRO) ?? false;
    return _isDone;
  }
}
