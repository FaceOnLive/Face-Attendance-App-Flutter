import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../core/auth/controllers/login_controller.dart';
import '../../../core/data/providers/app_toast.dart';
import '../../../core/data/services/upload_picture.dart';
import '../../../core/models/user.dart';

/// A User which is a member of this app.
///
/// This is not AppUserController
class AppMemberUserController extends GetxController {
  // Dependency
  final CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /// Currently Logged in User
  late AppUser currentUser;
  bool isUserInitialized = false;

  /// Fetch Current Logged In User
  Future<void> _fetchUserData() async {
    try {
      await _collectionReference.doc(_currentUserID).get().then((value) {
        currentUser = AppUser.fromDocumentSnap(value);
        isUserInitialized = true;
        update();
      });
    } catch (e) {
      AppToast.showDefaultToast(e.toString());
    }
  }

  /* <---- User Picture -----> */
  /// Is the updating picture function running
  bool isUpdatingPicture = false;

  /// Update User Profile Picture
  Future<void> updateUserProfilePicture(File image) async {
    try {
      isUpdatingPicture = true;
      update();
      String? _downloadURL = await UploadPicture.ofUser(
        userID: currentUser.userID!,
        imageFile: image,
      );
      await _collectionReference.doc(_currentUserID).update({
        'userProfilePicture': _downloadURL,
      });
      await _fetchUserData();
      isUpdatingPicture = false;
      update();
    } on FirebaseException catch (e) {
      print(e);
      isUpdatingPicture = false;
      update();
    }
  }

  // Check if the current user added phone number and address
  bool isPhoneAndAddressFound() {
    bool isValid = false;
    if (currentUser.phone == null && currentUser.address == null) {
      isValid = false;
    } else {
      isValid = true;
    }
    return isValid;
  }

  /// Change User Name
  Future<void> changeUserName({required String newName}) async {
    await _collectionReference.doc(currentUser.userID).get().then(
      (value) async {
        await value.reference.update(
          {"name": newName},
        );
        await _fetchUserData();
      },
    );
  }

  /// Change User number
  Future<void> changeUserNumber({required int phone}) async {
    await _collectionReference.doc(currentUser.userID).get().then(
      (value) async {
        Map<String, dynamic>? data = value.data() as Map<String, dynamic>?;
        if (data!['phone'] == null) {
          data.addAll({'phone': phone});
          await value.reference.set(data);
        } else {
          await value.reference.update(
            {
              "phone": phone,
            },
          );
        }

        await _fetchUserData();
      },
    );
  }

  /// Change User Address
  Future<void> changeUserAddress({required String address}) async {
    await _collectionReference.doc(currentUser.userID).get().then(
      (value) async {
        Map<String, dynamic>? data = value.data() as Map<String, dynamic>?;
        if (data!['address'] == null) {
          data.addAll({'address': address});
          await value.reference.set(data);
        } else {
          await value.reference.update(
            {
              "address": address,
            },
          );
        }
        await _fetchUserData();
      },
    );
  }

  @override
  void onInit() async {
    super.onInit();
    _getCurrentUserID();
    await _fetchUserData();
  }
}
