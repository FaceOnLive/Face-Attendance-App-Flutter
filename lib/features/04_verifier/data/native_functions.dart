import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class NativeSDKFunctions {
  static const MethodChannel _channel = MethodChannel('turingtech');

  /// Initiate Database
  static Future<void> setSdkDatabase(Map<String, File> userLists) async {
    ///
    print('Starting set SDK Functions');

    Map<dynamic, dynamic> _userImages = {};

    List<File> _userImagesFile = List<File>.from(userLists.values);
    // List<String> _userIDs = List<String>.from(userLists.entries);

    await Future.forEach<File>(_userImagesFile, (element) {
      Uint8List bytes = element.readAsBytesSync();
      int currentIndex = _userImagesFile.indexOf(element);
      _userImages.addAll({currentIndex: bytes});
    });

    print("All The Setted Database Are: ${_userImages.length}");

    await _channel.invokeMethod('setDatabase', {'membersList': _userImages});

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
}
