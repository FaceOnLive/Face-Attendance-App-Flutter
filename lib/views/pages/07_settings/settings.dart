import 'dart:io';
import 'package:face_attendance/controllers/navigation/nav_controller.dart';
import 'package:face_attendance/views/pages/07_settings/admin_details.dart';

import 'change_holiday.dart';
import 'change_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/app_photo.dart';
import '../../dialogs/camera_or_gallery.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/auth/login_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/picture_display.dart';
import '../02_auth/login_screen.dart';
import '../08_spaces/spaces.dart';

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
      body: Container(
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
                        _UserInfo(),
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
                          leading: Icon(Icons.person),
                        ),
                        AppCustomListTile(
                          label: 'Change Password',
                          onTap: () {
                            Get.bottomSheet(
                              ChangePasswordSheet(),
                              isScrollControlled: true,
                            );
                          },
                          leading: Icon(Icons.lock),
                        ),
                        AppCustomListTile(
                          label: 'Spaces',
                          onTap: () {
                            Get.to(() => SpacesScreen());
                          },
                          leading: Icon(Icons.group_work),
                        ),
                        AppCustomListTile(
                          label: 'Notfications',
                          onTap: () {},
                          leading: Icon(Icons.notifications_rounded),
                          trailing: CupertinoSwitch(
                            onChanged: (val) {
                              controller.updateNotificationSetting(val);
                            },
                            value: controller.currentUser.notification,
                          ),
                          isUpdating: controller.isNotificationUpdating,
                        ),
                        // Dark Mode
                        GetBuilder<NavigationController>(
                          builder: (_controller) {
                            return AppCustomListTile(
                              onTap: () {},
                              label: 'Dark Mode',
                              leading: Icon(Icons.dark_mode_rounded),
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
                            leading: Icon(Icons.face_rounded),
                            isUpdating: controller.isUpdatingFaceID,
                            updateMessage: 'Adding new face...',
                            subtitle: controller.currentUser.userFace != null
                                ? 'Face is enrolled'
                                : 'No Face Found'),

                        AppCustomListTile(
                          label: 'Change Holiday',
                          onTap: () {
                            Get.bottomSheet(
                              ChangeHolidaySheet(),
                              isScrollControlled: true,
                            );
                          },
                          leading: Icon(Icons.emoji_food_beverage),
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              decoration: BoxDecoration(
                color: context.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
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
                  Get.offAll(() => LoginScreenAlt());
                  Get.find<LoginController>().logOut();
                },
                width: Get.width * 0.5,
                backgroundColor: AppColors.APP_RED,
                suffixIcon: Icon(
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
            return PictureWidget(
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

class AppCustomListTile extends StatelessWidget {
  const AppCustomListTile({
    Key? key,
    required this.onTap,
    this.label,
    this.leading,
    this.trailing,
    this.isUpdating = false,
    this.updateMessage,
    this.subtitle,
  }) : super(key: key);

  final void Function() onTap;
  final String? label;
  final Icon? leading;
  final Widget? trailing;
  final bool isUpdating;
  final String? updateMessage;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
        borderRadius: AppDefaults.defaulBorderRadius,
        splashColor: AppColors.shimmerHighlightColor,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: AppSizes.DEFAULT_MARGIN,
              vertical: AppSizes.DEFAULT_MARGIN / 2),
          decoration: BoxDecoration(
            boxShadow: AppDefaults.defaultBoxShadow,
            color: context.theme.cardColor,
            borderRadius: AppDefaults.defaulBorderRadius,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(AppSizes.DEFAULT_PADDING / 2),
            enabled: true,
            leading: leading ?? Icon(Icons.person_rounded),
            title: Text(
              label ?? 'Add Text Here',
              style: context.textTheme.bodyText1,
            ),
            subtitle: isUpdating
                ? Text(
                    updateMessage ?? 'Updating...',
                    style: AppText.caption,
                  )
                : subtitle == null
                    ? null
                    : Text(subtitle!, style: AppText.caption),
            trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ),
    );
  }
}
