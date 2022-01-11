import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/features/05_members/data/repository/attendance_repo.dart';
import 'package:face_attendance/features_user/core/controllers/app_member_space.dart';
import 'package:face_attendance/features_user/core/controllers/app_member_verify.dart';
import 'package:get/get.dart';

import '../../../core/auth/controllers/login_controller.dart';
import '../../../core/utils/app_toast.dart';
import '../../../core/data/services/upload_picture.dart';
import '../../../core/models/user.dart';

/// A User which is a member of this app.
///
/// This is not AppUserController [An admin of this app]
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
      Get.find<AppMemberVerifyController>().setSDK();
      isUpdatingPicture = false;
      update();
    } on FirebaseException catch (e) {
      print(e);
      isUpdatingPicture = false;
      update();
    }
  }

  // Check if the current user added phone number and address
  bool isUserDataAvailable() {
    if (currentUser.phone != null &&
        currentUser.address != null &&
        currentUser.userProfilePicture != null) {
      return true;
    } else {
      return false;
    }
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

  /// Add Attendance
  Future<void> addAttendanceToday() async {
    final _spaceController = Get.find<AppMemberSpaceController>();

    String? _currentSpaceID = _spaceController.currentSpace!.spaceID;

    if (_currentSpaceID != null) {
      try {
        await addAttendanceAppMember(
          memberID: currentUser.userID!,
          spaceID: _currentSpaceID,
          date: DateTime.now(),
        );
        AppToast.showDefaultToast('Attendance Added');
      } on FirebaseException catch (e) {
        AppToast.showDefaultToast(e.code);
      }
    }
  }

  /// Attendance Give [App_Member]
  Future<void> addAttendanceAppMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final _reference = _collectionReference
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data');

    final _attendenceDoc = await _reference.doc(date.year.toString()).get();
    if (_attendenceDoc.exists) {
      _attendenceDoc.reference.update({
        'unattended_date': FieldValue.arrayRemove([Timestamp.fromDate(date)])
      });
    } else {
      _reference.doc(date.year.toString()).set({
        'unattended_date': FieldValue.arrayRemove([Timestamp.fromDate(date)])
      });
    }
  }

  /// Unattended Date
  List<DateTime> unAttendedDate = [];
  bool isMemberAttendedToday = false;

  /// Get Attendance [App_Member]
  Future<List<DateTime>> getAttendanceAppMember({
    required String memberID,
    required String spaceID,
    DateTime? userDate,
  }) async {
    final _reference = _collectionReference
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data');

    final String _thisYear = DateTime.now().year.toString();

    final _attendenceDoc = await _reference
        .doc(userDate == null ? _thisYear : userDate.year.toString())
        .get();

    /// Where the firebase data will be stored
    List<Timestamp> _unAttendedDate = [];

    if (_attendenceDoc.exists) {
      Map<String, dynamic>? _theDates = _attendenceDoc.data();
      _unAttendedDate = List.from(_theDates!['unattended_date']);
    } else {}

    /// Return Type
    List<DateTime> _unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in _unAttendedDate) {
      _unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return _unattendedDateInDateTime;
  }

  /// Set Space and SDK when the app starts
  Future<void> setSpaceAndSDK() async {
    final _spaceController = Get.find<AppMemberSpaceController>();
    final _verifyController = Get.find<AppMemberVerifyController>();

    String? currentSpaceID = await _spaceController.fetchUserSpaces();
    if (currentSpaceID != null) {
      unAttendedDate = await getAttendanceAppMember(
          memberID: _currentUserID, spaceID: currentSpaceID);

      _verifyController.setSDK();

      isMemberAttendedToday =
          MemberAttendanceRepository.isMemberAttendedTodayLocal(
              unattendedDate: unAttendedDate);

      if (isMemberAttendedToday) {
        _verifyController.verifyingState = VerifyingState.attended;
        _verifyController.update();
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    _getCurrentUserID();
    await _fetchUserData();
    setSpaceAndSDK();
  }
}
