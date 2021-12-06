import 'package:face_attendance/features/06_spaces/data/source/space_local_source.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../features/01_onboarding/views/onboarding_page.dart';
import '../../../features/03_attendance/views/pages/attendance_screen.dart';
import '../../../features/04_verifier/views/pages/verifier.dart';
import '../../../features/05_members/views/pages/members.dart';
import '../../auth/controllers/login_controller.dart';
import '../../auth/views/login_screen.dart';
import '../../utils/check_internet.dart';
import '../views/dialogs/no_internet.dart';

class SettingsController extends GetxController {
  /// If All The Database And Firebase Loaded, so that we can show user something
  bool everyThingLoadedUp = false;
  Future<void> _onAppStart() async {
    try {
      // STARTING THE APP
      await Firebase.initializeApp();
      await Hive.initFlutter();
      // This is for reducing the time on start app
      await Hive.openBox(_appsBoolBox);
      await Hive.openBox(SpaceLocalSource.spaceBoxName);
      Get.put(LoginController(), permanent: true);
      everyThingLoadedUp = true;
      update();
    } catch (e) {
      print(e);
    }
  }

  /* <---- Main App Navigation ----> */
  Widget introOrLogin() {
    if (isOnboardDone() == false) {
      return const OnboardingPage();
    } else {
      return const LoginPage();
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
      return const AttendanceScreen();
    } else if (currentIndex == 1) {
      return const VerifierScreen();
    } else if (currentIndex == 2) {
      return const MembersScreen();
    } else {
      return const AttendanceScreen();
    }
  }

  /* <---- Intro Screen Related ----> */
  /// Used For Storing Data
  static const String _appsBoolBox = 'appsBool';
  static const String _boxKeyOnBoard = 'onboardingDone';
  static const String _inVerifierMode = 'inVerify';

  /// Save a bool that intro screen has already been showed
  void onboardingDone() {
    Box box = Hive.box(_appsBoolBox);
    box.put(_boxKeyOnBoard, true);
  }

  /* <---- HELPER FUNCTIONS ----> */

  /// Returns true/false if the intro has been done
  bool isOnboardDone() {
    Box box = Hive.box(_appsBoolBox);
    bool _isDone = box.get(_boxKeyOnBoard) ?? false;
    return _isDone;
  }

  /// If user logged in
  bool isUserLoggedIn() {
    LoginController _controller = Get.find();
    return _controller.user != null ? true : false;
  }

  /* <---- VERIFIER ----> */
  /// If the app is in verifier mode
  bool isInVerifierMode() {
    Box box = Hive.box(_appsBoolBox);
    bool _isInVerify = box.get(_inVerifierMode) ?? false;
    return _isInVerify;
  }

  /// Set The Apps In Verify Mode
  void setAppInVerifyMode() {
    Box box = Hive.box(_appsBoolBox);
    box.put(_inVerifierMode, true);
    print('SETTED APP IN LOCK MODE');
  }

  /// Set The Apps In Unverify Mode
  void setAppInUnverifyMode() {
    Box box = Hive.box(_appsBoolBox);
    box.put(_inVerifierMode, false);
    print('SETTED APP IN UNLOCK MODE');
  }

  /////////////////////////////
  /* <---- DARK MODE -----> */
  // static const String _THEME_MODE_BOX = 'theme_box';
  static const String _themeModeString = 'isInDarkMode';

  /// Change the theme to dark mode
  void switchTheme(bool? value) {
    if (value == true) {
      Get.changeThemeMode(ThemeMode.dark);
      isAppInDarkMode = true;
      update();
      _writeThemeStateToStorage(ThemeMode.dark);
    } else {
      Get.changeThemeMode(ThemeMode.light);
      isAppInDarkMode = false;
      update();
      _writeThemeStateToStorage(ThemeMode.light);
    }
  }

  /// If the app is in darkmode
  bool isAppInDarkMode = false;

  /// Storage For Dark Mode, This value is used on main.dart file
  bool _isTheAppInDarkMode() {
    final box = GetStorage();
    bool _isAppInDark = false;
    String _data = box.read(_themeModeString) ?? 'light';
    ThemeMode _theme = _convertToThemeMode(_data);
    if (_theme == ThemeMode.dark) {
      _isAppInDark = true;
      isAppInDarkMode = true;
    }
    return _isAppInDark;
  }

  /// Write Theme To Storage (For Saving The Theme Setting on Device)
  void _writeThemeStateToStorage(ThemeMode themeMode) {
    final box = GetStorage();
    if (themeMode == ThemeMode.system) {
      box.write(_themeModeString, 'system');
    } else if (themeMode == ThemeMode.dark) {
      box.write(_themeModeString, 'dark');
    } else if (themeMode == ThemeMode.light) {
      box.write(_themeModeString, 'light');
    }
  }

  /// Gives ThemeMode From String
  ThemeMode _convertToThemeMode(String label) {
    if (label == 'light') {
      return ThemeMode.light;
    } else if (label == 'dark') {
      return ThemeMode.dark;
    } else if (label == 'system') {
      return ThemeMode.system;
    } else {
      return ThemeMode.light;
    }
  }

  /// Gives App Theme Mode
  ThemeMode appThemeMode() {
    ThemeMode _theme = ThemeMode.light;
    final box = GetStorage();
    String _data = box.read(_themeModeString) ?? 'light';
    _theme = _convertToThemeMode(_data);
    return _theme;
  }

  /// Internet Check
  Future<void> _checkInternetOnStart() async {
    bool _isAvailable = await Internet.isAvailable();
    if (_isAvailable) {
      // do nothing
    } else {
      Get.dialog(const NoInternetDialog(), barrierDismissible: false);
    }
  }

  /// When this controller initiates
  @override
  void onInit() async {
    super.onInit();

    /// WHEN THE APP STARTS
    await _onAppStart();
    _isTheAppInDarkMode();
    _checkInternetOnStart();
  }
}
