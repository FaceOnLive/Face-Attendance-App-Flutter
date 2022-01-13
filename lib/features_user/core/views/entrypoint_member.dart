import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/themes/text.dart';
import '../controllers/app_member_settings.dart';
import '../controllers/app_member_space.dart';
import '../controllers/app_member_user.dart';
import '../controllers/app_member_verify.dart';

/* <-----------------------> 
    This is kind of another app which is completely seperated from the main
    admin version of this app, if in future you need to separate this thing
    from here then you need to also duplicate the utils and helpers functions
    that are used in here.    
 <-----------------------> */

class AppMemberMainUi extends StatelessWidget {
  const AppMemberMainUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /* <---- Main Part ----> */
            Expanded(
              child: GetBuilder<AppMemberSettingsController>(
                init: AppMemberSettingsController(),
                initState: (val) {
                  Get.put(AppMemberUserController());
                  Get.put(AppMemberSpaceController());
                  Get.put(AppMemberVerifyController());
                },
                builder: (controller) => PageTransitionSwitcher(
                  duration: AppDefaults.duration,
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
            GetBuilder<AppMemberSettingsController>(
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
                selectedItemColor: AppColors.primaryColor,
                iconSize: 32,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
