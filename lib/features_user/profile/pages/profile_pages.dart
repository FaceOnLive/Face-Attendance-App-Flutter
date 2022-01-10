import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/utils/encrypt_decrypt.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/picture_display.dart';
import '../../../core/app/controllers/core_controller.dart';
import '../../../core/app/views/dialogs/error_dialog.dart';
import '../../../core/app/views/dialogs/generated_qr.dart';
import '../../../core/auth/controllers/login_controller.dart';
import '../../../features/05_members/views/dialogs/camera_or_gallery.dart';
import '../../core/controllers/app_member_user.dart';
import '../components/change_address.dart';
import '../components/change_name.dart';
import '../components/change_number.dart';

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
            GetBuilder<CoreController>(
              builder: (_controller) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CupertinoSwitch(
                        value: _controller.isAppInDarkMode,
                        onChanged: (v) {
                          _controller.switchTheme(v);
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
                        File? _userImage =
                            await Get.dialog(const CameraGallerySelectDialog());
                        if (_userImage != null) {
                          await controller.updateUserProfilePicture(_userImage);
                        }
                      },
                    );
                  },
                ),
                AppSizes.hGap20,
                const _UserInfo(),
                const _UserSettings(),
              ],
            ),
            const _ActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _UserSettings extends StatelessWidget {
  const _UserSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppMemberUserController>(builder: (controller) {
      return SizedBox(
        width: Get.width * 0.7,
        child: Column(
          children: [
            AppSizes.hGap10,
            AppButton(
              label: 'Change Name',
              onTap: () {
                Get.bottomSheet(
                  const ChangeNameSheet(),
                  isScrollControlled: true,
                );
              },
              prefixIcon: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
              ),
            ),
            AppButton(
              label: 'Add/Edit Address',
              onTap: () {
                Get.bottomSheet(
                  const ChangeAddressSheet(),
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
                  ? AppColors.appRed
                  : null,
            ),
            AppButton(
              label: 'Add/Edit Number',
              onTap: () {
                Get.bottomSheet(
                  const ChangeNumberSheet(),
                  isScrollControlled: true,
                );
              },
              prefixIcon: Icon(
                  controller.currentUser.phone == null
                      ? Icons.warning_rounded
                      : Icons.phone_rounded,
                  color: Colors.white),
              backgroundColor: controller.currentUser.phone == null
                  ? AppColors.appRed
                  : null,
            ),
          ],
        ),
      );
    });
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
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Divider(),
          AppSizes.hGap10,
          AppButtonOutline(
            label: 'Share Info',
            suffixIcon: const Icon(Icons.qr_code_2_rounded),
            onTap: () {
              String userId = controller.currentUser.userID ?? 'no-user-id';
              bool _isValidForShare = controller.isUserDataAvailable();
              if (_isValidForShare) {
                Get.dialog(
                  /// Returns an encrypted USER ID
                  GenerateQRDialog(
                    data: AppAlgo.encrypt(userId),
                    title: 'Share User',
                  ),
                );
              } else {
                Get.dialog(
                  const ErrorDialog(
                    title: 'Info not found',
                    message: 'Please Add a Picture, Phone, Address',
                  ),
                );
              }
            },
          ),
          // Logout button
          AppButton(
            label: 'Logout',
            suffixIcon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            backgroundColor: AppColors.appRed,
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
                color: AppColors.primaryColor,
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
