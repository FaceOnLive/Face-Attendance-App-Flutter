import 'dart:io';

import 'package:face_attendance/core/constants/app_sizes.dart';
import 'package:face_attendance/core/data/repository/face_repo.dart';
import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:face_attendance/core/widgets/app_button.dart';
import 'package:face_attendance/features/05_members/views/dialogs/camera_or_gallery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifierTestFaceLoginPage extends StatefulWidget {
  const VerifierTestFaceLoginPage({super.key});

  @override
  _VerifierTestFaceLoginPageState createState() =>
      _VerifierTestFaceLoginPageState();
}

class _VerifierTestFaceLoginPageState extends State<VerifierTestFaceLoginPage> {
  late TextEditingController _email;
  late TextEditingController _pass;
  final Rxn<File> _userImage = Rxn<File>();

  /// Pick User Image
  _pickUserImage() async {
    File? pickedFile = await Get.dialog(const CameraGallerySelectDialog());
    if (pickedFile != null) {
      _userImage.value = pickedFile;
    } else {
      AppToast.show('No Image has been selected');
    }
  }

  /// Repository
  final FaceRepoImpl _faceRepo = FaceRepoImpl();
  _saveData() async {
    if (_email.text.isNotEmpty &&
        _pass.text.isNotEmpty &&
        _userImage.value != null) {
      await _faceRepo.saveFaceData(
        userPass: _pass.text,
        email: _email.text,
        userPic: _userImage.value!,
      );
    } else {
      AppToast.show('Some Data is missing');
    }
  }

  _verifyUser() async {
    if (_userImage.value != null) {
      await _faceRepo.loginWithFace(capturedImage: _userImage.value!);
    }
  }

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _pass = TextEditingController();
  }

  @override
  void dispose() {
    _userImage.close();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Face Login Feature')),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Spacer(),
          Obx(
            () => _userImage.value != null
                ? Image.file(
                    _userImage.value!,
                    width: MediaQuery.of(context).size.width * 0.4,
                  )
                : const SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Enter Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                AppSizes.hGap10,
                TextField(
                  controller: _pass,
                  decoration: const InputDecoration(
                    labelText: 'Enter Password',
                    prefixIcon: Icon(Icons.vpn_key_rounded),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: _pickUserImage,
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Pick Image'),
          ),
          const Spacer(),
          AppButton(
            label: 'Save Data',
            onTap: _saveData,
          ),
          AppButton(
            label: 'Verify Face',
            onTap: _verifyUser,
            backgroundColor: Colors.green,
          )
        ],
      ),
    );
  }
}
