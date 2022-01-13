import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/form_verify.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/verify_controller.dart';

/* <---- This is a sheet ----> */

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
  final RxnString _errorMessage = RxnString();
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /* <---- Show Password ----> */
  final RxBool _showPass = false.obs;
  _onEyeClick() {
    _showPass.value = !_showPass.value;
  }

  /// Progress
  final RxBool _isInProgress = false.obs;

  /* <---- Dependency -----> */
  final VerifyController _verifyController = Get.find();

  /// On Lock
  Future<void> _onLock() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      _isInProgress.trigger(true);
      String? _error = await _verifyController.startStaticVerifyMode(
        userPass: passController.text,
      );

      if (_error != null && _error == 'wrong-password') {
        _errorMessage.value = 'The password is wrong';
      } else {
        _errorMessage.value = _error;
      }

      _isInProgress.trigger(false);
    }
  }

  /// On Unlock
  Future<void> _onUnlock() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      _isInProgress.trigger(true);
      String? _error = await _verifyController.stopStaticVerifyMode(
        userPass: passController.text,
      );

      if (_error != null && _error == 'wrong-password') {
        _errorMessage.value = 'The password is wrong';
      } else {
        _errorMessage.value = _error;
      }

      _isInProgress.trigger(false);
    }
  }

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
  }

  @override
  void dispose() {
    _isInProgress.close();
    _errorMessage.close();
    _showPass.close();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: AppDefaults.boxShadow,
        borderRadius: AppDefaults.bottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /* <---- Head Divider ----> */
          Container(
            width: Get.width * 0.25,
            height: 3,
            decoration: const BoxDecoration(
              color: AppColors.placeholderColor,
            ),
          ),
          AppSizes.hGap10,
          /* <---- HeadLine ----> */
          Text(
            'Enter Password',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          AppSizes.hGap20,
          /* <---- Password Form ----> */
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Obx(
              () => Form(
                key: _formKey,
                child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                    controller: passController,
                    obscureText: !_showPass.value,
                    validator: (value) {
                      return _errorMessage.value =
                          AppFormVerify.password(password: value);
                    }),
              ),
            ),
          ),

          /* <---- Submit Button ----> */
          Obx(
            () => AppButton(
              width: Get.width * 0.6,
              isLoading: _isInProgress.value,
              label: widget.isLockMode ? 'Lock' : 'Unlock',
              onTap: () {
                // LOCK
                if (widget.isLockMode) {
                  _onLock();
                } else {
                  // UNLOCK
                  _onUnlock();
                }
              },
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: AppText.b1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
