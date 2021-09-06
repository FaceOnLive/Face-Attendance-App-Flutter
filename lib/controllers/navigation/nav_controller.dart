import 'package:face_attendance/views/pages/04_attendance/attendance.dart';
import 'package:face_attendance/views/pages/05_verifier/verifier.dart';
import 'package:face_attendance/views/pages/06_members/members.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


class NavigationController extends GetxController {
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
}