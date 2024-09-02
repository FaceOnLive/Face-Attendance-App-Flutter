import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';

import '../app/controllers/core_controller.dart';
import '../utils/app_toast.dart';

class NativeSDKFunctions {
  static const MethodChannel _channel = MethodChannel('turingtech');

  /// Initiate Database of Users to letter verify
  static Future<bool> setSdkDatabase(Map<int, Uint8List> userLists) async {
    Get.find<CoreController>().settingSDK();
    bool isDone =
        await _channel.invokeMethod('setDatabase', {'membersList': userLists});
    Get.find<CoreController>().settingSdkDone();
    AppToast.show('Face Data Updated');
    return isDone;
  }

  /// Verify Single Person
  static Future<bool> verifyPerson({
    required File capturedImage,
    required File personImage,
  }) async {
    bool isTheSamePerson = false;

    /// Convert Data
    // Uint8List? _capturedImageBytes = await getFaceData(image: capturedImage);
    // Uint8List? _personImageBytes = await getFaceData(image: personImage);

    Uint8List? capturedImageBytes = await capturedImage.readAsBytes();
    Uint8List? personImageBytes = await personImage.readAsBytes();

    // Invoke Method
    isTheSamePerson = await _channel.invokeMethod('verifySinglePerson', {
      'capturedImage': capturedImageBytes,
      'personImage': personImageBytes,
    });

    return isTheSamePerson;
  }

  /// Get Feature or Uin8List
  /// [MODE] 1 -> enroll mode, 0 -> verify mode
  static Future<Uint8List?> getFaceData({
    required File image,
    int mode = 0,
  }) async {
    //convert
    Uint8List unExtractedImage = await image.readAsBytes();

    // initiate
    Uint8List? file;

    file = await _channel.invokeMethod(
      'getFeature',
      {
        'image': unExtractedImage,
        'mode': mode //1 -> enroll mode, 0 -> verify mode
      },
    );

    return file;
  }
}
