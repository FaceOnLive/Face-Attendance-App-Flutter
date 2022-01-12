import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/constants.dart';
import '../../core/controllers/app_member_settings.dart';
import '../../core/controllers/app_member_user.dart';

class AppMemberUserProfilePicture extends StatelessWidget {
  const AppMemberUserProfilePicture({
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
                backgroundImage: const AssetImage(
                  AppImages.deafaultUser,
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
                      backgroundImage: const AssetImage(AppImages.deafaultUser),
                      radius: Get.width * 0.07),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
