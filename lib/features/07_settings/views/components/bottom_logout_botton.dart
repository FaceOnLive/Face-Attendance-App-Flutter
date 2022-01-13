import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/auth/views/pages/login_page.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';

class BottomLogoutButton extends StatelessWidget {
  const BottomLogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
