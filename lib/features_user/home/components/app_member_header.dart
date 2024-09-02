import 'package:face_attendance/config/config.dart';
import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import '../../../core/constants/constants.dart';
import '../../../core/themes/text.dart';
import '../../core/controllers/app_member_user.dart';
import 'app_member_user_profile.dart';

class AppMemberHeaderHome extends GetView<AppMemberUserController> {
  const AppMemberHeaderHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: Get.height * 0.1,
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: AppDefaults.boxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* <---- Left Side ----> */
          Row(
            children: [
              Hero(
                tag: AppImages.logo,
                child: Image.asset(
                  AppImages.logo2,
                  width: Get.width * 0.13,
                ),
              ),
              AppSizes.wGap10,
              const TitleAndSubtitle(),
            ],
          ),
          /* <---- Right Side ----> */
          // ADMIN PROFILE PICTURE
          const AppMemberUserProfilePicture(),
        ],
      ),
    );
  }
}

class TitleAndSubtitle extends StatelessWidget {
  const TitleAndSubtitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String websiteURL = "http://www.faceonlive.com";
        bool canLaunch = await url.canLaunch(websiteURL);
        if (canLaunch) {
          await url.launch(websiteURL);
        } else {
          AppToast.show(
            "Oops! Faceonlive is not available",
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConfig.appName,
            style: AppText.b2.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppConfig.appSubtitle,
            style: AppText.caption,
          )
        ],
      ),
    );
  }
}
