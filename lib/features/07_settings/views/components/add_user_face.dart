import 'dart:io';

import 'package:face_attendance/core/auth/controllers/login_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/data/services/app_photo.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/form_verify.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/bottom_sheet_top_divider.dart';
import '../controllers/app_admin_controller.dart';

class AddUserFaceDialog extends StatefulWidget {
  const AddUserFaceDialog({super.key});

  @override
  _AddUserFaceDialogState createState() => _AddUserFaceDialogState();
}

class _AddUserFaceDialogState extends State<AddUserFaceDialog> {
  late TextEditingController _password;

  final RxBool _isCheckingUser = false.obs;
  final RxnString _errorMessage = RxnString();

  late GlobalKey<FormState> _formKey;

  _verifyUser() async {
    _isCheckingUser.trigger(true);
    final controller = Get.find<AppAdminController>();
    bool isFormOkay = _formKey.currentState!.validate();
    if (isFormOkay) {
      try {
        bool isUserValid =
            await controller.reauthenticateUser(password: _password.text);
        if (isUserValid) {
          File? image = await AppPhotoService.getImageFromCamera();
          if (image != null) {
            await controller.updateUserFaceID(
              imageFile: image,
              password: _password.text,
              email: controller.currentUser.email,
            );
            Get.back();
          }
          _isCheckingUser.trigger(false);
        } else {
          _isCheckingUser.trigger(false);
          AppToast.show('Invalid User');
        }
      } on FirebaseException catch (e) {
        _errorMessage.value = e.code;
        _isCheckingUser.trigger(false);
      }
    } else {
      _isCheckingUser.trigger(false);
    }
  }

  @override
  void initState() {
    super.initState();

    _password = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    _password.dispose();
    _isCheckingUser.close();
    _errorMessage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.canvasColor,
        borderRadius: AppDefaults.bottomSheetRadius,
      ),
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BottomSheetTopDivider(),
          AppSizes.hGap15,
          Text(
            'Please Verify',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
          ),
          Text(
            'We need you to verify your identity',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          AppSizes.hGap15,
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.password_rounded),
                    errorText: _errorMessage.value,
                  ),
                  validator: (v) {
                    return AppFormVerify.password(password: v);
                  },
                ),
              ),
            ),
          ),
          Obx(
            () => AppButton(
              label: 'Add Face',
              onTap: _verifyUser,
              isLoading: _isCheckingUser.value,
            ),
          ),
          Get.find<LoginController>().isFaceLoginAvailable
              ? AppButton(
                  label: 'Remove Face ID',
                  onTap: () {},
                  backgroundColor: AppColors.appRed,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
