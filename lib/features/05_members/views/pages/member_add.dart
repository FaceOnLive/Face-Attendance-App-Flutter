import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/utils/form_verify.dart';
import '../../../../core/utils/ui_helper.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/picture_display.dart';
import '../controllers/member_controller.dart';
import '../dialogs/camera_or_gallery.dart';

class MemberAddScreen extends StatefulWidget {
  const MemberAddScreen({Key? key}) : super(key: key);

  @override
  _MemberAddScreenState createState() => _MemberAddScreenState();
}

class _MemberAddScreenState extends State<MemberAddScreen> {
  /* <---- Dependency ----> */
  final MembersController _controller = Get.find();

  /* <---- Input Fields ----> */
  late TextEditingController _name;
  late TextEditingController _phoneNumber;
  late TextEditingController _fullAddress;
  // Initailize
  void _initializeTextController() {
    _name = TextEditingController();
    _phoneNumber = TextEditingController();
    _fullAddress = TextEditingController();
  }

  // Dispose
  void _disposeTextController() {
    _name.dispose();
    _phoneNumber.dispose();
    _fullAddress.dispose();
  }

  // Other
  final RxBool _addingMember = false.obs;

  // Image
  File? _userImage;
  final RxBool _userPickedImage = false.obs;

  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// When user clicks the add button
  Future<void> _onCreateUserButton() async {
    _addingMember.value = true;
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      AppUiUtil.dismissKeyboard(context: Get.context!);
      if (_userImage != null) {
        await _controller.addMember(
          name: _name.text,
          memberPictureFile: _userImage!,
          phoneNumber: int.parse(_phoneNumber.text),
          fullAddress: _fullAddress.text,
        );
        Get.back();
        _addingMember.value = false;
      } else {
        AppToast.show("Please add a picture");
        _addingMember.value = false;
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
    _addingMember.close();
    _userPickedImage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Member',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDefaults.padding),
            width: Get.width,
            child: Column(
              children: [
                Obx(
                  () => ProfilePictureWidget(
                    onTap: () async {
                      _userImage =
                          await Get.dialog(const CameraGallerySelectDialog());
                      // If the user has picked an image then we will show
                      // the file user has picked
                      if (_userImage != null) {
                        _userPickedImage.trigger(true);
                      }
                    },
                    isLocal: _userPickedImage.value,
                    localImage: _userImage,
                  ),
                ),
                /* <---- Form INFO ----> */
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_rounded),
                            hintText: 'Person Name',
                          ),
                          controller: _name,
                          autofocus: true,
                          validator: (value) {
                            return AppFormVerify.name(fullName: value);
                          },
                        ),
                        AppSizes.hGap20,
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            prefixIcon: Icon(Icons.phone_rounded),
                            hintText: '+854 000 0000',
                          ),
                          controller: _phoneNumber,
                          validator: (value) {
                            return AppFormVerify.phoneNumber(phone: value);
                          },
                        ),
                        AppSizes.hGap20,
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Full Address',
                            prefixIcon: Icon(Icons.location_on_rounded),
                            hintText: 'Ocean Centre, Tsim Sha Tsui, Hong Kong',
                          ),
                          controller: _fullAddress,
                          validator: (value) {
                            return AppFormVerify.address(address: value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                AppSizes.hGap10,
                Obx(
                  () => AppButton(
                    width: Get.width * 0.6,
                    label: 'Add',
                    isLoading: _addingMember.value,
                    onTap: _onCreateUserButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
