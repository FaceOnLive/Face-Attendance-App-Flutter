import '../../../../data/providers/form_verify.dart';
import '../../../../data/services/app_toast.dart';

import '../../../../constants/app_sizes.dart';

import '../../../themes/text.dart';
import '../../../widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../../constants/app_defaults.dart';
import '../../../../controllers/user/app_member_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNameSheet extends StatefulWidget {
  const ChangeNameSheet({Key? key}) : super(key: key);

  @override
  _ChangeNameSheetState createState() => _ChangeNameSheetState();
}

class _ChangeNameSheetState extends State<ChangeNameSheet> {
  /// Dependency
  AppMemberUserController _controller = Get.find();

  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Text
  late TextEditingController _name;

  /// Progress
  RxBool _isUpdating = false.obs;

  /// on update
  Future<void> _onNameUpdate() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      try {
        _isUpdating.trigger(true);
        await _controller.changeUserName(newName: _name.text);
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
    _name = TextEditingController();
    _name.text = _controller.currentUser.name;
  }

  @override
  void dispose() {
    _name.dispose();
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
          /// HEADER
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
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'John Doe',
              ),
              validator: (text) {
                return AppFormVerify.name(fullName: text);
              },
              onFieldSubmitted: (v) {
                _onNameUpdate();
              },
            ),
          ),
          AppSizes.hGap20,

          /// BUTTON
          Obx(
            () => AppButton(
              label: 'Update',
              isLoading: _isUpdating.value,
              onTap: _onNameUpdate,
            ),
          ),
        ],
      ),
    );
  }
}
