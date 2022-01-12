import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../core/controllers/app_member_user.dart';
import 'change_address.dart';
import 'change_name.dart';
import 'change_number.dart';

class UserSettingsSection extends StatelessWidget {
  const UserSettingsSection({
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
