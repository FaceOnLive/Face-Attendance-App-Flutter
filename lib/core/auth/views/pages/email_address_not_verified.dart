import 'package:face_attendance/core/auth/controllers/login_controller.dart';
import 'package:face_attendance/core/constants/constants.dart';
import 'package:face_attendance/core/themes/text.dart';
import 'package:face_attendance/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailNotVerifiedScreen extends StatelessWidget {
  const EmailNotVerifiedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              /* <---- Header Logo ----> */
              SizedBox(
                width: Get.width * 0.2,
                child: Hero(
                  tag: AppImages.mainLogo,
                  child: Image.asset(
                    AppImages.mainLogo,
                  ),
                ),
              ),
              const Divider(),
              const Spacer(),
              Image.asset(AppImages.illustrationNoAttend),
              AppSizes.hGap15,
              Text(
                'Your email has not been verified',
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              AppSizes.hGap15,
              Text(
                'Please check your email inbox or spam folder',
                style: AppText.caption,
              ),
              const Spacer(),
              const Divider(),
              const _ActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Obx(
      () {
        return Column(
          children: [
            AppButton(
              label: 'Send Email Again',
              onTap: controller.sendEmailAgain,
              isLoading: controller.isSendingEmail.value,
            ),
            AppButtonOutline(
              label: 'Email has been verified',
              onTap: controller.emailHasBeenVerified,
              isLoading: controller.isVerifiyingEmail.value,
            ),
            AppSizes.hGap15,
          ],
        );
      },
    );
  }
}
