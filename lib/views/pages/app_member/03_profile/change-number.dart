import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/services/app_toast.dart';
import 'package:face_attendance/services/form_verify.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:face_attendance/views/widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

import '../../../../constants/app_defaults.dart';
import '../../../../controllers/user/app_member_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNumberSheet extends StatefulWidget {
  const ChangeNumberSheet({Key? key}) : super(key: key);

  @override
  _ChangeNumberSheetState createState() => _ChangeNumberSheetState();
}

class _ChangeNumberSheetState extends State<ChangeNumberSheet> {
  /// Dependency
  AppMemberUserController _controller = Get.find();

  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Text
  late TextEditingController _number;

  /// Progress
  RxBool _isUpdating = false.obs;

  /// on update
  Future<void> _onNumberUpdate() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      try {
        _isUpdating.trigger(true);
        await _controller.changeUserNumber(phone: int.parse(_number.text));
        _isUpdating.trigger(false);
        Get.back();
      } on FirebaseException catch (e) {
        AppToast.showDefaultToast(e.message ?? "Something error happened");
        _isUpdating.trigger(false);
        Get.back();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _number = TextEditingController();
    _number.text = _controller.currentUser.phone == null
        ? ''
        : _controller.currentUser.phone.toString();
  }

  @override
  void dispose() {
    _number.dispose();
    _isUpdating.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: AppDefaults.defaultBottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADLINE
          Text(
            'Update Your Name',
            style: AppText.h6,
          ),

          /// DIVIDER
          AppSizes.hGap10,
          Divider(),
          AppSizes.hGap20,

          /// FORM
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _number,
              decoration: InputDecoration(
                labelText: 'Number',
                hintText: '+244555058000',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (text) {
                return AppFormVerify.phoneNumber(phone: text);
              },
              onFieldSubmitted: (v) {
                _onNumberUpdate();
              },
            ),
          ),
          AppSizes.hGap20,

          /// UPDATE
          Obx(
            () => AppButton(
              label: 'Update',
              isLoading: _isUpdating.value,
              onTap: _onNumberUpdate,
            ),
          ),
        ],
      ),
    );
  }
}
