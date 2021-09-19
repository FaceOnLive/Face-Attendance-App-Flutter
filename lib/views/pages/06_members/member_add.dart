import 'dart:io';

import '../../../controllers/members/member_controller.dart';

import '../../../constants/app_sizes.dart';
import '../../dialogs/camera_or_gallery.dart';
import '../../widgets/app_button.dart';
import '../../widgets/picture_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberAddScreen extends StatefulWidget {
  const MemberAddScreen({Key? key}) : super(key: key);

  @override
  _MemberAddScreenState createState() => _MemberAddScreenState();
}

class _MemberAddScreenState extends State<MemberAddScreen> {
  /* <---- Dependency ----> */
  MembersController _controller = Get.find();

  /* <---- Input Fields ----> */
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _phoneNumber;
  late TextEditingController _fullAddress;
  // Initailize
  void _initializeTextController() {
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phoneNumber = TextEditingController();
    _fullAddress = TextEditingController();
  }

  // Dispose
  void _disposeTextController() {
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    _fullAddress.dispose();
  }

  // Other
  RxBool _addingMember = false.obs;

  // Image
  File? _userImage;
  RxBool _userPickedImage = false.obs;

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
        title: Text(
          'Add Member',
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.DEFAULT_PADDING),
            width: Get.width,
            child: Column(
              children: [
                Obx(
                  () => PictureWidget(
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
                    localImage: _userImage,
                  ),
                ),
                /* <---- Form INFO ----> */
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          prefixIcon: Icon(Icons.person_rounded),
                          hintText: 'John',
                        ),
                        controller: _firstName,
                        autofocus: true,
                      ),
                      AppSizes.hGap20,
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          prefixIcon: Icon(Icons.person_rounded),
                          hintText: 'Doe',
                        ),
                        controller: _lastName,
                      ),
                      AppSizes.hGap20,
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone_rounded),
                          hintText: 'John Doe',
                        ),
                        controller: _phoneNumber,
                      ),
                      AppSizes.hGap20,
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Full Address',
                          prefixIcon: Icon(Icons.location_on_rounded),
                          hintText: 'Ocean Centre, Tsim Sha Tsui, Hong Kong',
                        ),
                        controller: _fullAddress,
                      ),
                    ],
                  ),
                ),
                AppSizes.hGap10,
                Obx(
                  () => AppButton(
                    width: Get.width * 0.6,
                    label: 'Add',
                    isLoading: _addingMember.value,
                    onTap: () async {
                      _addingMember.value = true;
                      await _controller.addMember(
                        name: _firstName.text + ' ' + _lastName.text,
                        memberPictureFile: _userImage!,
                        phoneNumber: int.parse(_phoneNumber.text),
                        fullAddress: _fullAddress.text,
                      );
                      _addingMember.value = false;
                      Get.back();
                    },
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
