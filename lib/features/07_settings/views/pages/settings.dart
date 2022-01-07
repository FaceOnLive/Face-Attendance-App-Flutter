import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/controllers/core_controller.dart';
import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/auth/views/pages/login_page.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/data/services/app_photo.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_custom_list_tile.dart';
import '../../../../core/widgets/picture_display.dart';
import '../../../05_members/views/dialogs/camera_or_gallery.dart';
import '../../../06_spaces/views/pages/spaces.dart';
import '../controllers/user_controller.dart';
import 'admin_details.dart';
import 'change_holiday.dart';
import 'change_password.dart';

class AdminSettingScreen extends StatelessWidget {
  const AdminSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Setting',
          style: AppText.bBOLD,
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            /* <---- All Setting ----> */
            GetBuilder<AppUserController>(
              builder: (controller) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppSizes.hGap10,
                        // ADMIN PROFILE PICTURE
                        const _UserInfo(),
                        /* <---- Settings -----> */
                        AppCustomListTile(
                          label: 'Admin Details',
                          onTap: () {
                            Get.bottomSheet(
                              AdminDetailsSheet(
                                name: controller.currentUser.name,
                              ),
                              isScrollControlled: true,
                            );
                          },
                          leading: const Icon(Icons.person),
                        ),
                        AppCustomListTile(
                          label: 'Change Password',
                          onTap: () {
                            Get.bottomSheet(
                              const ChangePasswordSheet(),
                              isScrollControlled: true,
                            );
                          },
                          leading: const Icon(Icons.lock),
                        ),
                        AppCustomListTile(
                          label: 'Spaces',
                          onTap: () {
                            Get.to(() => const SpacesScreen());
                          },
                          leading: const Icon(Icons.group_work),
                        ),
                        AppCustomListTile(
                          label: 'Notfications',
                          onTap: () {},
                          leading: const Icon(Icons.notifications_rounded),
                          trailing: CupertinoSwitch(
                            onChanged: (val) {
                              controller.updateNotificationSetting(val);
                            },
                            value: controller.currentUser.notification,
                          ),
                          isUpdating: controller.isNotificationUpdating,
                        ),
                        // Dark Mode
                        GetBuilder<CoreController>(
                          builder: (_controller) {
                            return AppCustomListTile(
                              onTap: () {},
                              label: 'Dark Mode',
                              leading: const Icon(Icons.dark_mode_rounded),
                              trailing: CupertinoSwitch(
                                value: _controller.isAppInDarkMode,
                                onChanged: (v) {
                                  _controller.switchTheme(v);
                                },
                              ),
                            );
                          },
                        ),
                        // Face ID
                        AppCustomListTile(
                            label: 'Update Face Data',
                            onTap: () async {
                              File? _image =
                                  await AppPhotoService.getImageFromCamera();
                              if (_image != null) {
                                controller.updateUserFaceID(imageFile: _image);
                              }
                            },
                            leading: const Icon(Icons.face_rounded),
                            isUpdating: controller.isUpdatingFaceID,
                            updateMessage: 'Adding new face...',
                            subtitle: controller.currentUser.userFace != null
                                ? 'Face is enrolled'
                                : 'No Face Found'),

                        AppCustomListTile(
                          label: 'Change Holiday',
                          onTap: () {
                            Get.bottomSheet(
                              const ChangeHolidaySheet(),
                              isScrollControlled: true,
                            );
                          },
                          leading: const Icon(Icons.emoji_food_beverage),
                          subtitle: controller.getCurrentHoliday(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            /* <---- Bottom Logout Button ----> */
            Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(3, 4),
                    color: Colors.black12,
                    spreadRadius: 4,
                    blurRadius: 20,
                  )
                ],
              ),
              child: AppButton(
                label: 'Logout',
                onTap: () {
                  Get.offAll(() => const LoginPage());
                  Get.find<LoginController>().logOut();
                },
                width: Get.width * 0.5,
                backgroundColor: AppColors.appRed,
                suffixIcon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInfo extends GetView<AppUserController> {
  const _UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<AppUserController>(
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
        AppSizes.hGap10,
        Text(
          controller.currentUser.name,
          style: AppText.h6.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          controller.currentUser.email,
          style: AppText.b1,
        ),
        AppSizes.hGap10,
      ],
    );
  }
}
