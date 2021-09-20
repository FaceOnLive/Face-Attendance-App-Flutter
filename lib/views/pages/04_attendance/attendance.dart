import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../08_spaces/space_add.dart';
import '../../widgets/app_button.dart';
import 'user_list.dart';
import '../07_settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../themes/text.dart';
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
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (controller.isFetchingSpaces) {
                  return Expanded(
                      child: Center(child: CircularProgressIndicator()));
                } else if (controller.allSpaces.length <= 0) {
                  return _NoSpaceFound();
                } else {
                  return Expanded(
                    child: Column(
                      children: [
                        /* <---- DropDown and Date----> */
                        DropDownRow(),

                        /* <---- User List ----> */
                        AttendedUserList()
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NoSpaceFound extends StatelessWidget {
  const _NoSpaceFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width * 0.5,
                child: Image.asset(AppImages.ILLUSTRATION_SPACE_EMPTY),
              ),
              AppSizes.hGap20,
              Text('No space found..'),
              AppButton(
                width: Get.width * 0.5,
                prefixIcon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: 'Create Space',
                onTap: () {
                  Get.to(() => SpaceCreateScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
