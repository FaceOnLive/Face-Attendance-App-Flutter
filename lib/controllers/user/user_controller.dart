import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/uploadPicture.dart';
import '../auth/login_controller.dart';
import '../../models/user.dart';
import 'package:get/get.dart';

class AppUserController extends GetxController {
  /* <---- Dependency ----> */
  CollectionReference _collectionReference =
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
    } catch (e) {}
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

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchUserData();
  }
}
