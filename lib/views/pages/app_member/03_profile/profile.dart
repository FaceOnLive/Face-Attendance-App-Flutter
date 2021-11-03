import 'dart:io';
import 'package:face_attendance/controllers/settings/settings_controller.dart';
import 'package:face_attendance/views/pages/app_member/03_profile/change-address.dart';
import 'package:face_attendance/views/pages/app_member/03_profile/change-name.dart';
import 'package:face_attendance/views/pages/app_member/03_profile/change-number.dart';
import 'package:flutter/cupertino.dart';

import '../../../../constants/app_sizes.dart';
import '../../../dialogs/camera_or_gallery.dart';
import '../../../dialogs/error_dialog.dart';
import '../../../dialogs/generated_qr.dart';
import '../../../themes/text.dart';
import '../../../widgets/picture_display.dart';

import '../../../../constants/app_colors.dart';
import '../../../../controllers/auth/login_controller.dart';
import '../../../../controllers/user/app_member_user.dart';
import '../../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AppMemberProfileScreen extends GetView<AppMemberUserController> {
  const AppMemberProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dark Mode
            GetBuilder<SettingsController>(
              builder: (_controller) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoSwitch(
                        value: _controller.isAppInDarkMode,
                        onChanged: (v) {
                          _controller.switchTheme(v);
                        },
                      ),
                      Icon(Icons.dark_mode_rounded),
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
                        File? _userImage =
                            await Get.dialog(CameraGallerySelectDialog());
                        if (_userImage != null) {
                          await controller.updateUserProfilePicture(_userImage);
                        }
                      },
                    );
                  },
                ),
                AppSizes.hGap20,
                _UserInfo(),
                _UserSettings(),
              ],
            ),
            _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _UserSettings extends GetView<AppMemberUserController> {
  const _UserSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      child: Column(
        children: [
          AppSizes.hGap10,
          AppButton(
            label: 'Change Name',
            onTap: () {
              Get.bottomSheet(
                ChangeNameSheet(),
                isScrollControlled: true,
              );
            },
            prefixIcon: Icon(Icons.edit_rounded, color: Colors.white),
          ),
          AppButton(
            label: 'Add/Edit Address',
            onTap: () {
              Get.bottomSheet(
                ChangeAddressSheet(),
                isScrollControlled: true,
              );
            },
            prefixIcon: Icon(
              controller.currentUser.address == null
                  ? Icons.warning_rounded
                  : Icons.edit_location_rounded,
              color: Colors.white,
            ),
            backgroundColor: controller.currentUser.address == null
                ? AppColors.APP_RED
                : null,
          ),
          AppButton(
            label: 'Add/Edit Number',
            onTap: () {
              Get.bottomSheet(
                ChangeNumberSheet(),
                isScrollControlled: true,
              );
            },
            prefixIcon: Icon(
                controller.currentUser.phone == null
                    ? Icons.warning_rounded
                    : Icons.phone_rounded,
                color: Colors.white),
            backgroundColor:
                controller.currentUser.phone == null ? AppColors.APP_RED : null,
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends GetView<AppMemberUserController> {
  const _ActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.7,
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Divider(),
          AppSizes.hGap10,
          AppButtonOutline(
            label: 'Share Info',
            suffixIcon: Icon(Icons.qr_code_2_rounded),
            onTap: () {
              String userId = controller.currentUser.userID ?? 'no-user-id';
              bool _isValidForShare = controller.isPhoneAndAddressValid();
              if (_isValidForShare) {
                Get.dialog(
                  GenerateQRDialog(
                    data: 'User: $userId',
                    title: 'Share User',
                  ),
                );
              } else {
                Get.dialog(
                  ErrorDialog(message: 'Please Add Phone & Address'),
                );
              }
            },
          ),
          // Logout button
          AppButton(
            label: 'Logout',
            suffixIcon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            backgroundColor: AppColors.APP_RED,
            onTap: () {
              Get.find<LoginController>().logOut();
            },
          ),
        ],
      ),
    );
  }
}

class _UserInfo extends GetView<AppMemberUserController> {
  const _UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppMemberUserController>(
      initState: (_) {},
      builder: (_) {
        return Column(
          children: [
            Text(
              controller.currentUser.name,
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
            AppSizes.hGap10,
            Text(
              controller.currentUser.phone != null
                  ? controller.currentUser.phone.toString()
                  : "No Phone Found",
            ),
            Text(controller.currentUser.address ?? 'No Address Found'),
          ],
        );
      },
    );
  }
}
