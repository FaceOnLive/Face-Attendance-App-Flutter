import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import '../../../../config/config.dart';
import '../../../../core/constants/constants.dart';
import 'user_profile_picture.dart';

class HeaderMainPage extends StatelessWidget {
  const HeaderMainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const UserProfilePicture(),
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
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AppConfig.appSubtitle,
            style: context.textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
