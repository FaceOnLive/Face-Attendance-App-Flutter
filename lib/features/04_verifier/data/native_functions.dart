import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class NativeSDKFunctions {
  static const MethodChannel _channel = MethodChannel('turingtech');

  /// Initiate Database of Users to letter verify
  static Future<void> setSdkDatabase(Map<int, Uint8List> userLists) async {
    print('Initialzing setSDK function');

    print("All The Setted Database Are: ${userLists.length}");

    await _channel.invokeMethod('setDatabase', {'membersList': userLists});

    print('Database Set Done');
  }

  /// Verify Single Person
  static Future<bool> verifyPerson({
    required File capturedImage,
    required File personImage,
  }) async {
    bool _isTheSamePerson = false;

    /// Convert Data
    Uint8List _capturedImageBytes = capturedImage.readAsBytesSync();
    Uint8List _personImageBytes = personImage.readAsBytesSync();

    // Invoke Method
    _isTheSamePerson = await _channel.invokeMethod('verifySinglePerson', {
      'capturedImage': _capturedImageBytes,
      'personImage': _personImageBytes,
    });

    return _isTheSamePerson;
  }

  /// Get Feature or Uin8List
  static Future<Uint8List?> getFaceData({required File image}) async {
    //convert
    Uint8List _unExtractedImage = await image.readAsBytes();

    // initiate
    Uint8List? _file;

    _file = await _channel.invokeMethod(
      'getFeature',
      {
        'image': _unExtractedImage,
        'mode': 0 //1 -> enroll mode, 0 -> verify mode
      },
    );

    return _file;
  }
}
