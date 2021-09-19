/* <-----------------------> 
    This is where the user will come most of the time when he is logged in,
    This works as a like foundation of all main screen. Other Screen will act like a tab;
 <-----------------------> */

import 'package:animations/animations.dart';
import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/controllers/members/member_controller.dart';
import 'package:face_attendance/controllers/navigation/nav_controller.dart';
import 'package:face_attendance/controllers/spaces/space_controller.dart';
import 'package:face_attendance/controllers/user/user_controller.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreenUI extends StatelessWidget {
  /// Works as a foundation of all the other screen
  const MainScreenUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /* <---- Main Part ----> */
          Expanded(
            child: GetBuilder<NavigationController>(
              initState: (val) {
                Get.put(AppUserController());
                Get.put(MembersController());
                Get.put(SpaceController());
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
          GetBuilder<NavigationController>(
            builder: (controller) => BottomNavigationBar(
              onTap: controller.onNavTap,
              currentIndex: controller.currentIndex,
              backgroundColor: Colors.white,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppText.b1.fontSize,
              ),
              unselectedIconTheme: IconThemeData(
                color: AppColors.DARK_COLOR.withOpacity(0.5),
                size: 25,
              ),
              selectedIconTheme: IconThemeData(
                color: AppColors.PRIMARY_COLOR,
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
