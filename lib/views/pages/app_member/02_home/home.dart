import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'verifier.dart';
import '../../../../controllers/settings/app_member_settings.dart';
import 'drop_down.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_images.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../controllers/user/app_member_user.dart';
import '../../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class AppMemberHomeScreen extends StatelessWidget {
  const AppMemberHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _HeaderMainPage(),
          _DateRow(),
          // DropDown
          AppMemberDropDown(),
          Expanded(
            child: AppMemberVerifierWidget(),
          )
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.EEEE().format(DateTime.now()),
            style: AppText.caption,
          ),
          Text(' | '),
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}

class _HeaderMainPage extends GetView<AppMemberUserController> {
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
    return GetBuilder<AppMemberUserController>(
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
              Get.find<AppMemberSettingsController>().onNavTap(1);
            },
            child: Hero(
              tag: controller.currentUser.userID ?? 'picture',
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
