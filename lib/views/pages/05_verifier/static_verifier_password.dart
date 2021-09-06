import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/views/pages/05_verifier/static_verifier.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:face_attendance/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/* <---- A Bottom Sheet ----> */

class StaticVerifierPasswordSet extends StatefulWidget {
  const StaticVerifierPasswordSet({Key? key}) : super(key: key);

  @override
  _StaticVerifierPasswordSetState createState() =>
      _StaticVerifierPasswordSetState();
}

class _StaticVerifierPasswordSetState extends State<StaticVerifierPasswordSet> {
  /* <---- Text Editing Controllers ----> */

  late TextEditingController passController;
  late TextEditingController confirmPassController;
  _initializeControllers() {
    passController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  /* <---- Show Password ----> */
  RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
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
            'Set a password',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.PRIMARY_COLOR,
            ),
          ),

          /* <---- Password Form ----> */
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(
              () => Column(
                children: [
                  TextField(
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
                  AppSizes.hGap20,
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.vpn_key_rounded),
                      hintText: '***********',
                    ),
                    controller: confirmPassController,
                    obscureText: !_showPass.value,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Attention! The app will be locked by this password. You can use this as a verifier',
              style: AppText.caption,
              textAlign: TextAlign.center,
            ),
          ),
          /* <---- Submit Button ----> */
          AppButton(
            width: Get.width * 0.6,
            label: 'Lock',
            onTap: () {
              Get.back();
              Get.to(() => StaticVerifierScreen());
            },
          ),
        ],
      ),
    );
  }
}
