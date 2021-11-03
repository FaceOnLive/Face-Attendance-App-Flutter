/* <-----------------------> 
    This is where the user will come most of the time when he is logged in,
    This works as a like foundation of all main screen. Other Screen will act like a tab;
 <-----------------------> */

import 'package:animations/animations.dart';
import 'package:face_attendance/controllers/members/member_controller.dart';
import 'package:face_attendance/controllers/settings/settings_controller.dart';

import 'package:face_attendance/controllers/spaces/space_controller.dart';
import 'package:face_attendance/controllers/user/user_controller.dart';
import 'package:face_attendance/controllers/verifier/verify_controller.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryPointUI extends StatelessWidget {
  /// Works as a foundation of all the other screen
  const EntryPointUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /* <---- Main Part ----> */
          Expanded(
            child: GetBuilder<SettingsController>(
              initState: (val) {
                Get.put(AppUserController());
                Get.put(MembersController());
                Get.put(SpaceController());
                Get.put(VerifyController());
              },
              builder: (controller) => PageTransitionSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (child, animation, secondAnimation) {
                  return SharedAxisTransition(
                    child: child,
                    animation: animation,
                    secondaryAnimation: secondAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                  );
                },
                child: controller.currentSelectedPage(),
              ),
            ),
          ),

          /* <---- Bottom Navigation Bar ----> */
          GetBuilder<SettingsController>(
            builder: (controller) => BottomNavigationBar(
              onTap: controller.onNavTap,
              currentIndex: controller.currentIndex,
              backgroundColor: context.theme.cardColor,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppText.b1.fontSize,
              ),
              unselectedIconTheme: IconThemeData(
                color: context.theme.unselectedWidgetColor.withOpacity(0.4),
                size: 25,
              ),
              selectedIconTheme: IconThemeData(
                color: context.theme.primaryColor,
              ),
              iconSize: 32,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.assignment_ind_rounded),
                  label: 'Attendance',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_outlined),
                  label: 'Verifier',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_rounded),
                  label: 'Members',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
