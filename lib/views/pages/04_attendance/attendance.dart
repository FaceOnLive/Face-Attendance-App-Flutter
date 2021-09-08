import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_attendance/views/pages/04_attendance/user_list.dart';
import 'package:face_attendance/views/pages/07_settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'drop_down_row.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            /* <---- Header ----> */
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppDefaults.defaultBoxShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* <---- Left Side ----> */
                  Row(
                    children: [
                      Hero(
                        tag: AppImages.MAIN_LOGO,
                        child: Image.asset(
                          AppImages.MAIN_LOGO_2,
                          width: Get.width * 0.13,
                        ),
                      ),
                      AppSizes.wGap5,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Turing Tech',
                            style: AppText.b2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Face Attendance App',
                            style: AppText.caption,
                          )
                        ],
                      ),
                    ],
                  ),
                  /* <---- Right Side ----> */
                  // ADMIN PROFILE PICTURE
                  InkWell(
                    onTap: () {
                      Get.to(() => AdminSettingScreen());
                    },
                    child: Hero(
                      tag: AppImages.unsplashPersons[0],
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          AppImages.unsplashPersons[0],
                        ),
                        radius: Get.width * 0.07,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /* <---- DropDown and Date----> */
            DropDownRow(),

            /* <---- User List ----> */
            AttendedUserList()
          ],
        ),
      ),
    );
  }
}
