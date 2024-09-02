import 'package:face_attendance/core/auth/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app/views/dialogs/error_dialog.dart';
import '../../../core/app/views/dialogs/generated_qr.dart';
import '../../../core/auth/controllers/login_controller.dart';
import '../../../core/constants/constants.dart';
import '../../../core/utils/encrypt_decrypt.dart';
import '../../../core/widgets/app_button.dart';
import '../../core/controllers/app_member_user.dart';

class UserActionButtonSection extends GetView<AppMemberUserController> {
  const UserActionButtonSection({
    super.key,
  });

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
              bool isValidForShare = controller.isUserDataAvailable();
              if (isValidForShare) {
                Get.dialog(
                  /// Returns an encrypted USER ID
                  GenerateQRDialog(
                    data: AppAlgorithmUtil.encrypt(userId),
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
              Get.offAll(() => const LoginPage());
            },
          ),
        ],
      ),
    );
  }
}
