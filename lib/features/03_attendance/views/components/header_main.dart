import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import 'user_profile_picture.dart';

class HeaderMainPage extends StatelessWidget {
  const HeaderMainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                tag: AppImages.mainLogo,
                child: Image.asset(
                  AppImages.mainLogo2,
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
          const UserProfilePicture(),
        ],
      ),
    );
  }
}
