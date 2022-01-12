import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../core/app/views/dialogs/error_dialog.dart';
import '../../../core/data/services/app_photo.dart';
import '../../../core/native_bridge/native_functions.dart';
import 'app_member_user.dart';

enum VerifyState {
  verifying,
  verified,
  unverified,
  cameraOpen,
  attended,
  noSpaceFound,
  initializing,
}

class AppMemberVerifyController extends GetxController {
  /// SET SDK of the user picture so we can verify user later
  Future<void> setSDK() async {
    // Get user picture
    String? userPictureUrl =
        Get.find<AppMemberUserController>().currentUser.userProfilePicture;

    // check if it is not null
    if (userPictureUrl != null) {
      // get the image from url or cached
      File userPicture = await AppPhotoService.fileFromImageUrl(userPictureUrl);

      // get face data
      Uint8List? _userPictureBytes =
          await NativeSDKFunctions.getFaceData(image: userPicture);

      // set it
      if (_userPictureBytes != null) {
        NativeSDKFunctions.setSdkDatabase({1: _userPictureBytes});
      }
    }
  }

  /// Our Verfier State
  VerifyState verifyingState = VerifyState.initializing;

  /// Verify User
  Future<void> verifyUser() async {
    /// Open Camera Preview
    startCameraVerifying();
  }

  /// Start Camera Verifying to close the camera
  Future<void> startCameraVerifying() async {
    verifyingState = VerifyState.verifying;
    update();
    Timer(const Duration(seconds: 10), () {
      // If we are still verifying
      if (verifyingState == VerifyState.verifying) {
        Get.dialog(const ErrorDialog(
          title: 'Unverified',
          message: 'User Coudn\'t be verified',
        ));
        verifyingState = VerifyState.unverified;
        update();
      }
    });
  }

  final RxBool _isAddingAttendance = false.obs;

  /// When the user will be recognized
  void onRecognizedUser() async {
    if (_isAddingAttendance.isFalse) {
      _isAddingAttendance.value = true;
      verifyingState = VerifyState.verified;
      update();

      /// Add Attendance here
      await Get.find<AppMemberUserController>().addAttendanceToday();

      verifyingState = VerifyState.attended;
      update();
      _isAddingAttendance.value = false;
    } else {}
  }

  @override
  void onClose() {
    super.onClose();
    _isAddingAttendance.close();
  }
}
