import '../../../constants/app_sizes.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../services/app_toast.dart';
import '../../../services/form_verify.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../../../constants/app_defaults.dart';
import 'package:flutter/material.dart';

class AdminDetailsSheet extends StatefulWidget {
  const AdminDetailsSheet({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  _AdminDetailsSheetState createState() => _AdminDetailsSheetState();
}

class _AdminDetailsSheetState extends State<AdminDetailsSheet> {
  /* <---- Dependency -----> */
  AppUserController _controller = Get.find();

  // Text
  late TextEditingController _nameController;

  // Progress
  RxBool _isUpdating = false.obs;

  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // on name update
  Future<void> _onNameUpdate() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      try {
        _isUpdating.trigger(true);
        await _controller.changeAdminName(
          newName: _nameController.text,
        );
        _isUpdating.trigger(false);
        Get.back();
      } on FirebaseException catch (e) {
        AppToast.showDefaultToast(e.code);
        _isUpdating.trigger(false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _isUpdating.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
      decoration: BoxDecoration(
        color: Get.theme.canvasColor,
        borderRadius: AppDefaults.defaultBottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Change Admin Details',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          AppSizes.hGap20,
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              controller: _nameController,
              autofocus: true,
              validator: (v) {
                return AppFormVerify.name(fullName: v);
              },
            ),
          ),
          AppSizes.hGap20,
          Obx(
            () => AppButton(
              label: 'Update',
              onTap: _onNameUpdate,
              isLoading: _isUpdating.value,
            ),
          ),
        ],
      ),
    );
  }
}
