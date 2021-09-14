import '../../../controllers/navigation/nav_controller.dart';
import '../03_main/main_screen.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import 'static_verifier.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* <---- This is a bottom sheet ----> */

class StaticVerifierLockUnlock extends StatefulWidget {
  const StaticVerifierLockUnlock({Key? key, this.isLockMode = false})
      : super(key: key);

  final bool isLockMode;

  @override
  _StaticVerifierLockUnlockState createState() =>
      _StaticVerifierLockUnlockState();
}

class _StaticVerifierLockUnlockState extends State<StaticVerifierLockUnlock> {
  /* <---- Text Editing Controllers ----> */
  late TextEditingController passController;

  /* <---- Show Password ----> */
  RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppDefaults.defaultBoxShadow,
        borderRadius: AppDefaults.defaultBottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* <---- Head Divider ----> */
          Container(
            width: Get.width * 0.25,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.PLACEHOLDER_COLOR,
            ),
          ),
          AppSizes.hGap10,
          /* <---- HeadLine ----> */
          Text(
            'Enter Password',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),
          AppSizes.hGap20,
          /* <---- Password Form ----> */
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(
              () => TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key_rounded),
                  hintText: '***********',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _onEyeClick();
                    },
                    child: Icon(
                      _showPass.isFalse
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                ),
                controller: passController,
                obscureText: !_showPass.value,
              ),
            ),
          ),

          /* <---- Submit Button ----> */
          AppButton(
            width: Get.width * 0.6,
            label: widget.isLockMode ? 'Lock' : 'Unlock',
            onTap: () {
              // LOCK
              if (widget.isLockMode) {
                Get.find<NavigationController>().setAppInVerifyMode();
                Get.offAll(() => StaticVerifierScreen());
              } else {
                // UNLOCK
                Get.find<NavigationController>().setAppInUnverifyMode();
                Get.offAll(() => MainScreenUI());
              }
            },
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: AppText.b1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
