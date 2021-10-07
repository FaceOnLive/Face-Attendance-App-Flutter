import 'package:cached_network_image/cached_network_image.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/user/user_controller.dart';
import 'package:shimmer/shimmer.dart';
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
      color: context.theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            /* <---- Header ----> */
            _HeaderMainPage(),
            /* <---- Attendance List -----> */
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (controller.isFetchingSpaces) {
                  return LoadingMembers();
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

class _HeaderMainPage extends StatelessWidget {
  const _HeaderMainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: Get.height * 0.1,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
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
          _UserProfilePicture(),
        ],
      ),
    );
  }
}

class _UserProfilePicture extends StatelessWidget {
  const _UserProfilePicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUserController>(
      builder: (controller) {
        if (controller.isUserInitialized == false) {
          return Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: CircleAvatar(
                backgroundImage: AssetImage(
                  AppImages.DEFAULT_USER,
                ),
                radius: Get.width * 0.07),
          );
        } else if (controller.isUserInitialized == true) {
          return InkWell(
            onTap: () {
              Get.to(() => AdminSettingScreen());
            },
            child: Hero(
              tag: controller.currentUser.userID!,
              child: controller.currentUser.userProfilePicture != null
                  ? CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        controller.currentUser.userProfilePicture!,
                      ),
                      radius: Get.width * 0.07,
                    )
                  : CircleAvatar(
                      backgroundImage: AssetImage(AppImages.DEFAULT_USER),
                      radius: Get.width * 0.07),
            ),
          );
        } else {
          return SizedBox();
        }
      },
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
      child: Container(
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
    );
  }
}
