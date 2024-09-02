import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:retry/retry.dart';

class UploadPicture {
  /// Upload Images to Member directory  and gives download links
  static Future<String?> ofMember({
    required String memberID,
    required File imageFile,
    required String userID,
  }) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    // uploadingProfilePicture.value = true;
    /* <---- Delete Exisiting profile picture ----> */
    try {
      Reference existingImage =
          firebaseStorage.ref('members/$userID/$memberID');
      if (existingImage.fullPath != '') {
        await existingImage.delete();
      }
    } catch (e) {
      print("There is no old picture found of this user");
    }

    /* <---- Download Url ----> */
    String? downloadUrl;

    Reference storageReference =
        firebaseStorage.ref('members/$userID/$memberID');

    UploadTask uploadImage = storageReference.putFile(imageFile);

    String fullPath = uploadImage.snapshot.ref.fullPath;

    await uploadImage.whenComplete(() async {
      // String newFileName = '${_fullPath}_600x600';
      String newFileName = fullPath;
      /* <---- This will retry until it gets the download link ----> */
      await retry(
        () async {
          downloadUrl =
              await firebaseStorage.ref().child(newFileName).getDownloadURL();
        },
        retryIf: (e) => downloadUrl == null,
        maxAttempts: 20,
        delayFactor: const Duration(seconds: 2),
      );
    });
    return downloadUrl;
  }

  /// Upload Images to the user directory and gives download link
  static Future<String?> ofUser({
    required String userID,
    required File imageFile,
  }) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    // uploadingProfilePicture.value = true;
    /* <---- Delete Exisiting profile picture ----> */
    Reference existingImage = firebaseStorage.ref('users/$userID');

    try {
      if (existingImage.fullPath != '') {
        await existingImage.delete();
      }
    } catch (e) {
      print(e);
    }

    /* <---- Download Url ----> */
    String? downloadUrl;

    Reference storageReference = firebaseStorage.ref('users/$userID');

    UploadTask uploadImage = storageReference.putFile(imageFile);

    String fullPath = uploadImage.snapshot.ref.fullPath;

    await uploadImage.whenComplete(() async {
      // String newFileName = '${_fullPath}_600x600';
      String newFileName = fullPath;
      /* <---- This will retry until it gets the download link ----> */
      await retry(
        () async {
          downloadUrl =
              await firebaseStorage.ref().child(newFileName).getDownloadURL();
        },
        retryIf: (e) => downloadUrl == null,
        maxAttempts: 20,
        delayFactor: const Duration(seconds: 2),
      );
    });
    return downloadUrl;
  }

  /// Upload Images to the user directory and gives download link
  static Future<String?> ofUserFaceID({
    required String userID,
    required File imageFile,
  }) async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    // uploadingProfilePicture.value = true;
    /* <---- Delete Exisiting profile picture ----> */
    Reference existingImage = firebaseStorage.ref('usersFaceID/$userID');

    if (existingImage.fullPath != '') {
      existingImage.delete();
    }

    /* <---- Download Url ----> */
    String? downloadUrl;

    Reference storageReference = firebaseStorage.ref('usersFaceID/$userID');

    UploadTask uploadImage = storageReference.putFile(imageFile);

    String fullPath = uploadImage.snapshot.ref.fullPath;

    await uploadImage.whenComplete(() async {
      // String newFileName = '${_fullPath}_600x600';
      String newFileName = fullPath;
      /* <---- This will retry until it gets the download link ----> */
      await retry(
        () async {
          downloadUrl =
              await firebaseStorage.ref().child(newFileName).getDownloadURL();
        },
        retryIf: (e) => downloadUrl == null,
        maxAttempts: 20,
        delayFactor: const Duration(seconds: 2),
      );
    });
    return downloadUrl;
  }
}
