import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../core/utils/app_toast.dart';
import '../../../core/utils/form_verify.dart';
import '../../core/controllers/app_member_user.dart';

class ChangeAddressSheet extends StatefulWidget {
  const ChangeAddressSheet({Key? key}) : super(key: key);

  @override
  _ChangeAddressSheetState createState() => _ChangeAddressSheetState();
}

class _ChangeAddressSheetState extends State<ChangeAddressSheet> {
  /// Dependency
  final AppMemberUserController _controller = Get.find();

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Text
  late TextEditingController _address;

  /// Progress
  final RxBool _isUpdating = false.obs;

  /// on update
  Future<void> _onAddressUpdate() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      try {
        _isUpdating.trigger(true);
        await _controller.changeUserAddress(address: _address.text);
        _isUpdating.trigger(false);
        Get.back();
      } on FirebaseException catch (e) {
        AppToast.show(e.message ?? "Something error happened");
        _isUpdating.trigger(false);
        Get.back();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _address = TextEditingController();
    _address.text = _controller.currentUser.address == null
        ? ''
        : _controller.currentUser.address!;
  }

  @override
  void dispose() {
    _address.dispose();
    _isUpdating.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: AppDefaults.bottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Text(
            'Update Address',
            style: AppText.h6,
          ),

          /// DIVIDER
          AppSizes.hGap10,
          const Divider(),
          AppSizes.hGap20,

          /// FORM
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Ocean City, B-Block',
              ),
              validator: (text) {
                return AppFormVerify.address(address: text);
              },
              onFieldSubmitted: (v) {
                _onAddressUpdate();
              },
            ),
          ),
          AppSizes.hGap20,

          /// BUTTON
          Obx(
            () => AppButton(
              label: 'Update',
              isLoading: _isUpdating.value,
              onTap: _onAddressUpdate,
            ),
          ),
        ],
      ),
    );
  }
}
