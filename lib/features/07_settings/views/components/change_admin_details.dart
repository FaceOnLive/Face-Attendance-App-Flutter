import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/form_verify.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../controllers/app_admin_controller.dart';

class AdminDetailsSheet extends StatefulWidget {
  const AdminDetailsSheet({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  _AdminDetailsSheetState createState() => _AdminDetailsSheetState();
}

class _AdminDetailsSheetState extends State<AdminDetailsSheet> {
  /* <---- Dependency -----> */
  final AppAdminController _controller = Get.find();

  // Text
  late TextEditingController _nameController;

  // Progress
  final RxBool _isUpdating = false.obs;

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        AppToast.show(e.code);
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
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: Get.theme.canvasColor,
        borderRadius: AppDefaults.bottomSheetRadius,
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
          const Divider(),
          AppSizes.hGap20,
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              controller: _nameController,
              autofocus: true,
              validator: (name) {
                return AppFormVerify.name(fullName: name);
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
