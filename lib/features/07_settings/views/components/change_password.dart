import 'package:face_attendance/core/widgets/bottom_sheet_top_divider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/form_verify.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/app_admin_controller.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({Key? key}) : super(key: key);

  @override
  _ChangePasswordSheetState createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  /// Dependency
  final AppAdminController _controller = Get.find();

  /* <---- Text Editing Controller -----> */
  late TextEditingController _oldPassword;
  late TextEditingController _newPassword;
  late TextEditingController _confirmNewPassword;

  /// Initialize Controller
  void _initializeTextController() {
    _oldPassword = TextEditingController();
    _newPassword = TextEditingController();
    _confirmNewPassword = TextEditingController();
  }

  /// Dispose Controller
  void _disposeTextController() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmNewPassword.dispose();
  }

  /* <---- Show Password ----> */
  final RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  /* <---- Form Related -----> */
  final RxnString _errorMessage = RxnString();
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Progress BOOL
  final RxBool _isChanginPass = false.obs;

  /// On Change Pass Click
  Future<void> _onChangePass() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      try {
        _isChanginPass.trigger(true);
        await _controller.changePassword(
          oldPassword: _oldPassword.text,
          newPassword: _newPassword.text,
        );
        Get.back();
        _isChanginPass.trigger(false);
      } on FirebaseException catch (e) {
        print(e);
        _isChanginPass.trigger(false);
        _errorMessage.value = 'Your old password is invalid';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTextController();
  }

  @override
  void dispose() {
    _disposeTextController();
    _isChanginPass.close();
    _errorMessage.close();
    _showPass.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Get.theme.canvasColor,
        borderRadius: AppDefaults.bottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetTopDivider(),
          Text(
            'Change Password',
            style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),
          const Divider(),
          AppSizes.hGap20,
          Obx(
            () => Form(
              key: _formKey,
              child: Column(
                children: [
                  // Password Field
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Old Password',
                      prefixIcon: const Icon(Icons.vpn_key_rounded),
                      hintText: '***********',
                      errorText: _errorMessage.value,
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
                    controller: _oldPassword,
                    obscureText: !_showPass.value,
                    validator: (value) {
                      return AppFormVerify.password(
                        password: value,
                      );
                    },
                    onFieldSubmitted: (v) {},
                    textInputAction: TextInputAction.next,
                  ),
                  AppSizes.hGap20,
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: Icon(Icons.vpn_key_rounded),
                      hintText: '***********',
                    ),
                    controller: _newPassword,
                    obscureText: !_showPass.value,
                    validator: (value) {
                      return AppFormVerify.password(
                        password: value,
                        confirmPassword: _confirmNewPassword.text,
                      );
                    },
                    // onFieldSubmitted: (v) {},
                    // textInputAction: TextInputAction.next,
                  ),
                  AppSizes.hGap20,
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.vpn_key_rounded),
                      hintText: '***********',
                    ),
                    controller: _confirmNewPassword,
                    obscureText: !_showPass.value,
                    validator: (value) {
                      return AppFormVerify.password(
                        password: value,
                        confirmPassword: _newPassword.text,
                      );
                    },
                    // onFieldSubmitted: (v) {},
                    // textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          AppSizes.hGap30,
          Obx(
            () => AppButton(
              label: 'Change Password',
              onTap: _onChangePass,
              isLoading: _isChanginPass.value,
            ),
          ),
        ],
      ),
    );
  }
}
