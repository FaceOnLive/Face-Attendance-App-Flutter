import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../services/form_verify.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({Key? key}) : super(key: key);

  @override
  _ChangePasswordSheetState createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  /// Dependency
  AppUserController _controller = Get.find();

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
  RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  /* <---- Form Related -----> */
  RxnString errorMessage = RxnString();
  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Progress BOOL
  RxBool _isChanginPass = false.obs;

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
        errorMessage.value = 'Your old password is invalid';
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
    errorMessage.close();
    _showPass.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.defaultBottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change Password',
            style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.PRIMARY_COLOR),
          ),
          Divider(),
          AppSizes.hGap20,
          Obx(
            () => Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: [
                    // Password Field
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        prefixIcon: Icon(Icons.vpn_key_rounded),
                        hintText: '***********',
                        errorText: errorMessage.value,
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
                      decoration: InputDecoration(
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
                      decoration: InputDecoration(
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
