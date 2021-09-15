import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:retry/retry.dart';

class UploadPicture {
  /// Upload Images to Member directory  and gives download links
  static Future<String?> ofMember({
    required String memberID,
    required File imageFile,
  }) async {
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    // uploadingProfilePicture.value = true;
    /* <---- Delete Exisiting profile picture ----> */
    Reference _existingImage = _firebaseStorage.ref('members/$memberID');

    if (_existingImage.fullPath != '') {
      _existingImage.delete();
    }

    /* <---- Download Url ----> */
    String? _downloadUrl;

    Reference _storageReference = _firebaseStorage.ref('members/$memberID');

    UploadTask _uploadImage = _storageReference.putFile(imageFile);

    String _fullPath = _uploadImage.snapshot.ref.fullPath;

    await _uploadImage.whenComplete(() async {
      // String newFileName = '${_fullPath}_600x600';
      String newFileName = '$_fullPath';
      /* <---- This will retry until it gets the download link ----> */
      await retry(
        () async {
          _downloadUrl =
              await _firebaseStorage.ref().child(newFileName).getDownloadURL();
        },
        retryIf: (e) => _downloadUrl == null,
        maxAttempts: 20,
        delayFactor: Duration(seconds: 2),
      );
    });
    return _downloadUrl;
  }

  /// Upload Images to the user directory and gives download link
  static Future<String?> ofUser({
    required String userID,
    required File imageFile,
  }) async {
    FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    // uploadingProfilePicture.value = true;
    /* <---- Delete Exisiting profile picture ----> */
    Reference _existingImage = _firebaseStorage.ref('users/$userID');

    if (_existingImage.fullPath != '') {
      _existingImage.delete();
    }

    /* <---- Download Url ----> */
    String? _downloadUrl;

    Reference _storageReference = _firebaseStorage.ref('users/$userID');

    UploadTask _uploadImage = _storageReference.putFile(imageFile);

    String _fullPath = _uploadImage.snapshot.ref.fullPath;

    await _uploadImage.whenComplete(() async {
      // String newFileName = '${_fullPath}_600x600';
      String newFileName = '$_fullPath';
      /* <---- This will retry until it gets the download link ----> */
      await retry(
        () async {
          _downloadUrl =
              await _firebaseStorage.ref().child(newFileName).getDownloadURL();
        },
        retryIf: (e) => _downloadUrl == null,
        maxAttempts: 20,
        delayFactor: Duration(seconds: 2),
      );
    });
    return _downloadUrl;
  }
}
