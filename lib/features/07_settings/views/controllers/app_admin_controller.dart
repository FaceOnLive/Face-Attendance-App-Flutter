import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/data/helpers/app_toast.dart';
import '../../../../core/data/services/upload_picture.dart';
import '../../../../core/models/user.dart';

class AppAdminController extends GetxController {
  /* <---- Dependency ----> */
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

  /* <---- Notification -----> */
  /// For Progress
  bool isNotificationUpdating = false;

  /// Updates The Notification Setting of the user
  updateNotificationSetting(bool newValue) async {
    isNotificationUpdating = true;
    // This will make thing look faster
    currentUser.notification = newValue;
    update();
    // it will toggle the oposite of the current user setting
    await _collectionReference.doc(_currentUserID).update({
      'notification': newValue,
    });
    isNotificationUpdating = false;
    _fetchUserData();
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

  /* <---- Face Data -----> */
  /// Progress
  bool isUpdatingFaceID = false;

  /// This is used for face verification on Unlock
  Future<void> updateUserFaceID({required File imageFile}) async {
    try {
      isUpdatingFaceID = true;
      update();
      String? _downloadURL = await UploadPicture.ofUserFaceID(
        userID: currentUser.userID!,
        imageFile: imageFile,
      );
      await _collectionReference.doc(_currentUserID).update({
        'userFace': _downloadURL,
      });
      await _fetchUserData();
      isUpdatingFaceID = false;
      update();
    } on FirebaseException catch (e) {
      print(e);
      isUpdatingFaceID = false;
      update();
    }
  }

  /// Change Password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    String email = currentUser.email;
    // Need to authenticate the user again to refresh token
    AuthCredential _credential = EmailAuthProvider.credential(
      email: email,
      password: oldPassword,
    );
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(_credential);
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
  }

  /* <---- Holiday -----> */
  /// List of days to show in option
  List<String> allWeekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  /// Update Holiday
  Future<void> updateHoliday({required int selectedDay}) async {
    if (selectedDay >= 1 && selectedDay <= 7) {
      try {
        currentUser.holiday = selectedDay;
        update();
        await _collectionReference.doc(currentUser.userID!).update({
          'holiday': selectedDay,
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {
      print('Date is out of range');
    }
  }

  /// Get current holiday
  String getCurrentHoliday() {
    int currentDayInt = currentUser.holiday;
    return allWeekDays[currentDayInt - 1];
  }

  Future<void> changeAdminName({required String newName}) async {
    await _collectionReference.doc(currentUser.userID).get().then(
      (value) async {
        await value.reference.update(
          {"name": newName},
        );
        _fetchUserData();
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchUserData();
  }
}
