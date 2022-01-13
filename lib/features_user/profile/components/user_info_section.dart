import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../core/themes/text.dart';
import '../../core/controllers/app_member_user.dart';

class UserInfoSection extends GetView<AppMemberUserController> {
  const UserInfoSection({Key? key}) : super(key: key);

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
