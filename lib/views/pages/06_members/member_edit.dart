import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../services/form_verify.dart';
import '../../../models/member.dart';
import '../../dialogs/delete_user.dart';
import '../../../controllers/members/member_controller.dart';
import '../../../constants/app_sizes.dart';
import '../../dialogs/camera_or_gallery.dart';
import '../../widgets/app_button.dart';
import '../../widgets/picture_display.dart';

class MemberEditScreen extends StatefulWidget {
  const MemberEditScreen({Key? key, required this.member}) : super(key: key);

  final Member member;

  @override
  _MemberEditScreenState createState() => _MemberEditScreenState();
}

class _MemberEditScreenState extends State<MemberEditScreen> {
  /* <---- Dependency ----> */
  MembersController _controller = Get.find();
  _addDataToFields() {
    _name.text = widget.member.memberName;
    _phoneNumber.text = widget.member.memberNumber.toString();
    _fullAddress.text = widget.member.memberFullAdress;
  }

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
  RxBool _updatingMember = false.obs;

  // Image
  File? _userImage;
  RxBool _userPickedImage = false.obs;

  // Form Key
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// When user clicks update button
  Future<void> _onUserUpdate() async {
    bool _isFormOkay = _formKey.currentState!.validate();
    if (_isFormOkay) {
      _updatingMember.value = true;
      await _controller.updateMember(
        name: _name.text,
        memberPicture: _userImage,
        phoneNumber: int.parse(_phoneNumber.text),
        fullAddress: _fullAddress.text,
        member: widget.member,
        isCustom: true,
      );
      _updatingMember.value = false;
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeTextController();
    _addDataToFields();
  }

  @override
  void dispose() {
    _disposeTextController();
    _updatingMember.close();
    _userPickedImage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Member',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Get.dialog(DeleteUserDialog(
                memberID: widget.member.memberID!,
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.DEFAULT_PADDING),
            width: Get.width,
            child: Column(
              children: [
                Obx(
                  () => ProfilePictureWidget(
                    onTap: () async {
                      _userImage =
                          await Get.dialog(CameraGallerySelectDialog());
                      // If the user has picked an image then we will show
                      // the file user has picked
                      if (_userImage != null) {
                        _userPickedImage.trigger(true);
                      }
                    },
                    isLocal: _userPickedImage.value,
                    profileLink: widget.member.memberPicture,
                    localImage: _userImage,
                  ),
                ),
                /* <---- Form INFO ----> */
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_rounded),
                            hintText: 'John Doe',
                          ),
                          controller: _name,
                          autofocus: true,
                          validator: (fullName) {
                            return AppFormVerify.name(fullName: fullName);
                          },
                        ),
                        AppSizes.hGap20,
                        TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              prefixIcon: Icon(Icons.phone_rounded),
                              hintText: '+852 XXX-XXX',
                            ),
                            controller: _phoneNumber,
                            validator: (phone) {
                              return AppFormVerify.phoneNumber(phone: phone);
                            }),
                        AppSizes.hGap20,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Full Address',
                            prefixIcon: Icon(Icons.location_on_rounded),
                            hintText: 'Ocean Centre, Tsim Sha Tsui, Hong Kong',
                          ),
                          controller: _fullAddress,
                          validator: (address) {
                            return AppFormVerify.address(address: address);
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
                    label: 'Update',
                    isLoading: _updatingMember.value,
                    onTap: _onUserUpdate,
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
