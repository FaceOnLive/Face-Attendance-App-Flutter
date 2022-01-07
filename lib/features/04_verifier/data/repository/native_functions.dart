import 'dart:io';
import 'dart:typed_data';

import 'package:face_attendance/core/app/controllers/core_controller.dart';
import 'package:face_attendance/core/data/helpers/app_toast.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';

class NativeSDKFunctions {
  static const MethodChannel _channel = MethodChannel('turingtech');

  /// Initiate Database of Users to letter verify
  static Future<bool> setSdkDatabase(Map<int, Uint8List> userLists) async {
    Get.find<CoreController>().updatingSDKinitiated();
    bool isDone =
        await _channel.invokeMethod('setDatabase', {'membersList': userLists});
    Get.find<CoreController>().updateSdkDone();
    AppToast.showDefaultToast('Setting SDK Done');
    return isDone;
  }

  /// Verify Single Person
  static Future<bool> verifyPerson({
    required File capturedImage,
    required File personImage,
  }) async {
    bool _isTheSamePerson = false;

    /// Convert Data
    // Uint8List? _capturedImageBytes = await getFaceData(image: capturedImage);
    // Uint8List? _personImageBytes = await getFaceData(image: personImage);

    Uint8List? _capturedImageBytes = await capturedImage.readAsBytes();
    Uint8List? _personImageBytes = await personImage.readAsBytes();

    // Invoke Method
    _isTheSamePerson = await _channel.invokeMethod('verifySinglePerson', {
      'capturedImage': _capturedImageBytes,
      'personImage': _personImageBytes,
    });

    return _isTheSamePerson;
  }

  /// Get Feature or Uin8List
  /// [MODE] 1 -> enroll mode, 0 -> verify mode
  static Future<Uint8List?> getFaceData({
    required File image,
    int mode = 0,
  }) async {
    //convert
    Uint8List _unExtractedImage = await image.readAsBytes();

    // initiate
    Uint8List? _file;

    _file = await _channel.invokeMethod(
      'getFeature',
      {
        'image': _unExtractedImage,
        'mode': mode //1 -> enroll mode, 0 -> verify mode
      },
    );

    return _file;
  }
}
