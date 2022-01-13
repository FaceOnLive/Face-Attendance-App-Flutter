import 'package:face_attendance/core/auth/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../themes/text.dart';
import '../../../widgets/app_button.dart';
import '../../controllers/login_controller.dart';

class EmailNotVerifiedPage extends StatelessWidget {
  const EmailNotVerifiedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const CircleAvatar(
          backgroundImage: AssetImage(AppImages.logo2),
          backgroundColor: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<LoginController>().logOut();
              Get.offAll(() => const LoginPage());
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.red),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              const Divider(),
              const Spacer(),
              Image.asset(AppImages.illustrationNoAttend),
              AppSizes.hGap15,
              Text(
                'Please verify your email',
                style: AppText.h6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              AppSizes.hGap15,
              Text(
                'Check your email inbox or spam folder',
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
