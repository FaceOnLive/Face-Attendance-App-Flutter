import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../05_members/views/dialogs/camera_or_gallery.dart';
import '../../../../core/native_bridge/native_functions.dart';

/* <-----------------------> 
    This page was used for testing the sdk 1:1 verification, 
    it is no longer used now, but you can use it for your testing    
 <-----------------------> */

class VerifierCheckPage extends StatefulWidget {
  /// This page was used for testing the SDK
  const VerifierCheckPage({Key? key}) : super(key: key);

  @override
  State<VerifierCheckPage> createState() => _VerifierCheckPageState();
}

class _VerifierCheckPageState extends State<VerifierCheckPage> {
  final Rxn<File> _image1 = Rxn<File>();
  final Rxn<File> _image2 = Rxn<File>();
  final RxString _message = 'Not Initiated'.obs;
  final RxBool _isVerifying = false.obs;

  /// When the compare button is clicked
  Future<void> _compareImage() async {
    _isVerifying.trigger(true);
    try {
      bool isVerifed = await NativeSDKFunctions.verifyPerson(
        capturedImage: _image1.value!,
        personImage: _image2.value!,
      );
      if (isVerifed) {
        _message.value = 'Both Person are same';
      } else {
        _message.value = 'Both person not same';
      }
    } on PlatformException catch (e) {
      _message.value = 'Something Error Happened';
      print(e.code);
    }
    _isVerifying.trigger(false);
  }

  @override
  void dispose() {
    _image1.close();
    _image2.close();
    _message.close();
    _isVerifying.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifier Image'),
      ),
      body: Obx(
        () => Column(
          children: [
            Text(
              "Result: ${_message.value}",
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const Divider(),

            /// Image 1
            if (_image1.value != null)
              Expanded(
                child: Image.file(_image1.value!),
              ),
            if (_image1.value == null)
              Column(
                children: [
                  const Text('No Image 1 Selected'),
                  ElevatedButton.icon(
                    onPressed: () async {
                      _image1.value =
                          await Get.dialog(const CameraGallerySelectDialog());
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image 1'),
                  ),
                ],
              ),

            /// Image 2
            const Divider(),
            if (_image2.value != null)
              Expanded(
                child: Image.file(_image2.value!),
              ),
            if (_image2.value == null)
              Column(
                children: [
                  const Text('No Image 2 Selected'),
                  ElevatedButton.icon(
                    onPressed: () async {
                      _image2.value =
                          await Get.dialog(const CameraGallerySelectDialog());
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Pick Image 2'),
                  ),
                ],
              ),
            const Divider(),

            _isVerifying.isTrue
                ? Column(
                    children: const [
                      CircularProgressIndicator(),
                      AppSizes.hGap15,
                      Text('Verifying'),
                    ],
                  )
                : const Spacer(),

            /// Compare Button
            const Divider(),
            if (_image1.value != null && _image2.value != null)
              Column(
                children: [
                  AppButton(
                    label: 'Compare Image',
                    onTap: _compareImage,
                  ),
                  AppSizes.hGap15,
                  AppButton(
                    label: 'Reset',
                    onTap: () {
                      _image1.value = null;
                      _image2.value = null;
                      _isVerifying.trigger(false);
                      _message.value = 'Not Initiated';
                    },
                  )
                ],
              ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
