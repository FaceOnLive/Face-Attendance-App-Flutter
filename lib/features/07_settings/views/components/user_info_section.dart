import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/picture_display.dart';
import '../../../05_members/views/dialogs/camera_or_gallery.dart';
import '../controllers/app_admin_controller.dart';

class UserInfoSection extends GetView<AppAdminController> {
  const UserInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<AppAdminController>(
          builder: (_) {
            return ProfilePictureWidget(
              heroTag: controller.currentUser.userID,
              profileLink: controller.currentUser.userProfilePicture,
              isUpdating: controller.isUpdatingPicture,
              onTap: () async {
                File? userImage =
                    await Get.dialog(const CameraGallerySelectDialog());
                if (userImage != null) {
                  await controller.updateUserProfilePicture(userImage);
                }
              },
            );
          },
        ),
        AppSizes.hGap10,
        Text(
          controller.currentUser.name,
          style: context.textTheme.headlineSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          controller.currentUser.email,
          style: context.textTheme.bodySmall,
        ),
        AppSizes.hGap10,
      ],
    );
  }
}
