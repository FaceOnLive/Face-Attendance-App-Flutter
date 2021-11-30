/* <-----------------------> 
    This is where the user will come most of the time when he is logged in,
    This works as a like foundation of all main screen. Other Screen will act like a tab;
 <-----------------------> */

import 'package:animations/animations.dart';
import 'package:face_attendance/core/app/controllers/settings_controller.dart';
import 'package:face_attendance/features/07_settings/views/controllers/user_controller.dart';
import 'package:face_attendance/features/04_verifier/views/controllers/verify_controller.dart';
import 'package:face_attendance/core/themes/text.dart';
import 'package:face_attendance/features/05_members/views/controllers/member_controller.dart';
import 'package:face_attendance/features/06_spaces/views/controllers/space_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';

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
                duration: AppDefaults.defaultDuration,
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
              items: const [
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
