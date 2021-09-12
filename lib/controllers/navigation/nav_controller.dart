import 'package:face_attendance/controllers/auth/login_controller.dart';
import 'package:face_attendance/views/pages/01_intro/intro_screen.dart';
import 'package:face_attendance/views/pages/02_auth/login_screen.dart';
import '../../views/pages/04_attendance/attendance.dart';
import '../../views/pages/05_verifier/verifier.dart';
import '../../views/pages/06_members/members.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NavigationController extends GetxController {
  /// If All The Database And Firebase Loaded, so that we can show user something
  bool everyThingLoadedUp = false;
  Future<void> _onAppStart() async {
    try {
      // STARTING THE APP
      await Firebase.initializeApp();
      await Hive.initFlutter();
      // This is for reducing the time on start app
      await Hive.openBox(_APPS_BOOL_BOX);
      Get.put(LoginController());
      everyThingLoadedUp = true;
      update();
    } catch (e) {
      print(e);
    }
  }

  /* <---- Main App Navigation ----> */
  Widget introOrLogin() {
    // Temporary Value
    if (isIntroDone() == false) {
      return IntroScreen();
    } else {
      return LoginScreenAlt();
    }
  }

  bool isUserLoggedIn() {
    LoginController _controller = Get.find();
    return _controller.user != null ? true : false;
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
  void introScreenDone() {
    Box box = Hive.box(_APPS_BOOL_BOX);
    box.put(_BOX_KEY_INTRO, true);
  }

  /// Returns true/false if the intro has been done
  bool isIntroDone() {
    Box box = Hive.box(_APPS_BOOL_BOX);
    bool _isDone = box.get(_BOX_KEY_INTRO) ?? false;
    return _isDone;
  }

  @override
  void onInit() async {
    super.onInit();
    await _onAppStart();
  }
}
