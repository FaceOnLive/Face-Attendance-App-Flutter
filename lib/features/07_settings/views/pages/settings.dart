
import 'package:face_attendance/features/07_settings/views/components/add_user_face.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/controllers/core_controller.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_custom_list_tile.dart';
import '../../../06_spaces/views/pages/spaces.dart';
import '../components/bottom_logout_botton.dart';
import '../components/change_holiday.dart';
import '../components/change_password.dart';
import '../components/user_info_section.dart';
import '../controllers/app_admin_controller.dart';
import '../components/change_admin_details.dart';

class AdminSettingScreen extends StatelessWidget {
  const AdminSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Setting', style: context.textTheme.bodySmall),
      ),
      body: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            /* <---- All Setting ----> */
            GetBuilder<AppAdminController>(
              builder: (controller) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AppSizes.hGap10,
                        // ADMIN PROFILE PICTURE
                        const UserInfoSection(),
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
                          leading: const Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        AppCustomListTile(
                          label: 'Change Password',
                          onTap: () {
                            Get.bottomSheet(
                              const ChangePasswordSheet(),
                              isScrollControlled: true,
                            );
                          },
                          leading: const Icon(
                            Icons.lock,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        AppCustomListTile(
                          label: 'Spaces',
                          onTap: () {
                            Get.to(() => const SpacesScreen());
                          },
                          leading: const Icon(
                            Icons.group_work,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        AppCustomListTile(
                          label: 'Notfications',
                          onTap: () {},
                          leading: const Icon(
                            Icons.notifications_rounded,
                            color: AppColors.primaryColor,
                          ),
                          trailing: CupertinoSwitch(
                            onChanged: (val) {
                              controller.updateNotificationSetting(val);
                            },
                            value: controller.currentUser.notification,
                            activeColor: AppColors.primaryColor,
                          ),
                          isUpdating: controller.isNotificationUpdating,
                        ),
                        // Dark Mode
                        GetBuilder<CoreController>(
                          builder: (controller) {
                            return AppCustomListTile(
                              onTap: () {},
                              label: 'Dark Mode',
                              leading: const Icon(
                                Icons.dark_mode_rounded,
                                color: AppColors.primaryColor,
                              ),
                              trailing: CupertinoSwitch(
                                value: controller.isAppInDarkMode,
                                onChanged: (v) {
                                  controller.switchTheme(v);
                                },
                              ),
                            );
                          },
                        ),
                        // Face ID
                        AppCustomListTile(
                            label: 'Update Face Data',
                            onTap: () async {
                              Get.bottomSheet(
                                const AddUserFaceDialog(),
                                isScrollControlled: true,
                              );
                            },
                            leading: const Icon(
                              Icons.face_rounded,
                              color: AppColors.primaryColor,
                            ),
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
                          leading: const Icon(
                            Icons.emoji_food_beverage,
                            color: AppColors.primaryColor,
                          ),
                          subtitle: controller.getCurrentHoliday(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            /* <---- Bottom Logout Button ----> */
            const BottomLogoutButton(),
          ],
        ),
      ),
    );
  }
}
