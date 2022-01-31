import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../native_bridge/native_functions.dart';
import '../../utils/app_toast.dart';
import '../../utils/encrypt_decrypt.dart';

/// When the version of the app will release the obfuscation will happen with
/// flutter, so if a hacker reverse engineers this codebase he will be unable
/// to navigate through or understand what is going on, Simple but effective
abstract class FaceRepository {
  /// Saves user data in local device with a medium level encrytption [AppAlgorithmUtil]
  Future<void> saveFaceData(
      {required String userPass, required String email, required File userPic});

  /// Login With Face Data with a given face
  Future<void> loginWithFace({required File capturedImage});

  /// Deletes Users Saved Data
  Future<void> deleteFaceData();

  /// Is Face Data Available
  Future<bool> isFaceDataAvailable();
}

class FaceRepoImpl extends FaceRepository {
  /// Box Name of Image
  static const String _userImageBox = 'image';

  /// Box Name of Data
  static const String _userDataBox = 'data';

  /// Key Name of Image [We are keeping it like this, but data will be obfuscated]
  static const String _imageKey = 'egkegheogohie';

  /// Key Name of Data [We are keeping it like this, but data will be obfuscated]
  static const String _dataKey = '2gg892lkl';

  @override
  Future<void> loginWithFace({required File capturedImage}) async {
    /// convert captured image

    /// initiate the database
    final _imagebox = await Hive.openBox(_userImageBox);

    final _userImage = _imagebox.get(_imageKey) as Uint8List;
    final tempDir = await getTemporaryDirectory();
    File _userImageFile = await File('${tempDir.path}/image.png').create();
    _userImageFile.writeAsBytesSync(_userImage);

    bool _isSameUser = await NativeSDKFunctions.verifyPerson(
      capturedImage: capturedImage,
      personImage: _userImageFile,
    );

    if (_isSameUser) {
      final _dataBox = await Hive.openBox(_userDataBox);
      final _data = await _dataBox.get(_dataKey) as Map;
      String _decryptedEmail = AppAlgorithmUtil.decrypt(_data.values.first);
      String _decryptedPass = AppAlgorithmUtil.decrypt(_data.values.last);
      print("User email is: $_decryptedEmail And User Pass is $_decryptedPass");
    } else {
      AppToast.show('Not the same user');
    }
  }

  @override
  Future<void> saveFaceData({
    required String userPass,
    required String email,
    required File userPic,
  }) async {
    // convert the image into bytes
    Uint8List _userImage = await userPic.readAsBytes();
    // open database
    final _imagebox = await Hive.openBox(_userImageBox);
    final _dataBox = await Hive.openBox(_userDataBox);

    /// Save the image for verification
    await _imagebox.put(_imageKey, _userImage);

    /// Encrypt the user Data
    String _encryptedMail = AppAlgorithmUtil.encrypt(email);
    String _encryptedPass = AppAlgorithmUtil.encrypt(userPass);

    Map<String, dynamic> _data = {'a': _encryptedMail, 'b': _encryptedPass};
    print("Saved Data :${_data.toString()}");
    await _dataBox.put(_dataKey, _data);
    AppToast.show('User Picture Has Been Saved');
  }

  @override
  Future<void> deleteFaceData() async {
    final _imagebox = await Hive.openBox(_userImageBox);
    final _dataBox = await Hive.openBox(_userDataBox);
    await _imagebox.delete(_imageKey);
    await _dataBox.delete(_dataKey);
  }

  @override
  Future<bool> isFaceDataAvailable() async {
    final _imagebox = await Hive.openBox(_userImageBox);
    final _theImage = _imagebox.get(_imageKey);
    if (_theImage != null) {
      return true;
    } else {
      return false;
    }
  }
}
