import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/picture_display.dart';
import '../../../core/app/controllers/core_controller.dart';
import '../../../features/05_members/views/dialogs/camera_or_gallery.dart';
import '../../core/controllers/app_member_user.dart';
import '../components/user_action_button_section.dart';
import '../components/user_info_section.dart';
import '../components/user_setting_section.dart';

class AppMemberProfileScreen extends GetView<AppMemberUserController> {
  const AppMemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dark Mode
            GetBuilder<CoreController>(
              builder: (controller) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoSwitch(
                        value: controller.isAppInDarkMode,
                        onChanged: (v) {
                          controller.switchTheme(v);
                        },
                      ),
                      const Icon(Icons.dark_mode_rounded),
                    ],
                  ),
                );
              },
            ),
            /* <---- User Info -----> */
            Column(
              children: [
                GetBuilder<AppMemberUserController>(
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
                AppSizes.hGap20,
                const UserInfoSection(),
                const UserSettingsSection(),
              ],
            ),
            const UserActionButtonSection(),
          ],
        ),
      ),
    );
  }
}
