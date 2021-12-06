import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/auth/controllers/login_controller.dart';
import '../../../../core/data/providers/app_toast.dart';
import '../../../../core/data/providers/date_helper.dart';
import '../../../../core/data/services/delete_picture.dart';
import '../../../../core/data/services/upload_picture.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/models/member.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';
import '../../data/repository/attendance_repo.dart';
import '../../data/repository/member_repo.dart';

class MembersController extends GetxController {
  /* <---- Dependency ----> */
  /// All Members Collection
  late final CollectionReference _customMembersCollections = FirebaseFirestore
      .instance
      .collection('members')
      .doc(_currentAdminID)
      .collection('members_collection');

  final CollectionReference _appMembersCollection =
      FirebaseFirestore.instance.collection('members');

  /// User ID of Current Logged In user
  late String _currentAdminID;
  void _getCurrentUserID() {
    _currentAdminID = Get.find<LoginController>().user!.uid;
  }

  late final MemberRepositoryImpl _repository;

  void _initializeRepositroy() {
    _getCurrentUserID();
    _repository = MemberRepositoryImpl(
      appMemberCollection: _appMembersCollection,
      customMemberCollection: _customMembersCollections,
    );
  }

  /* <---- Members ----> */
  /// List Of All the fetched Members
  List<Member> allMembers = [];
  late ScrollController scrollController;
  bool isFetchingUser = false;

  /// Fetch All Members from _collectionReference
  Future<void> fetchMembersList() async {
    isFetchingUser = true;
    // We are going to fetch multiple times, this is to avoid duplication
    final _fetchedData =
        await _repository.getAllMembers(adminID: _currentAdminID);

    _fetchedData.fold(
      (l) => {
        AppToast.showDefaultToast('There is an error with fetching Members'),
      },
      (fetchedList) => allMembers = fetchedList,
    );

    isFetchingUser = false;
    update();
  }

  /// Add Member to Database
  Future<void> addMember({
    required String name,
    required File memberPictureFile,
    required int phoneNumber,
    required String fullAddress,
  }) async {
    try {
      Member _member = Member(
        memberName: name,
        memberPicture: '',
        memberNumber: phoneNumber,
        memberFullAdress: fullAddress,
        isCustom: true,
      );
      // We should add the member first so that we can get a user Id
      final documentRef = await _repository.addCustomMember(member: _member);

      String _id = 'null';

      documentRef.fold(
          (l) => throw ServerExeption(), (_docRef) => {_id = _docRef});

      String? _downloadUrl = await UploadPicture.ofMember(
        memberID: _id,
        imageFile: memberPictureFile,
        userID: _currentAdminID,
      );

      await _customMembersCollections.doc(_id).update({
        'memberPicture': _downloadUrl,
      });

      print("Member Added $_id");
      fetchMembersList();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  /// Edit or Update Member Data
  Future<void> updateMember({
    required String name,
    required File? memberPicture,
    required int phoneNumber,
    required String fullAddress,
    required Member member,
    required bool isCustom,
  }) async {
    try {
      String? _downloadUrl;
      // If user has picked an image
      if (memberPicture != null) {
        _downloadUrl = await UploadPicture.ofMember(
          memberID: member.memberID!,
          imageFile: memberPicture,
          userID: _currentAdminID,
        );
      } else {
        _downloadUrl = member.memberPicture;
      }

      await _customMembersCollections.doc(member.memberID!).get().then(
        (value) {
          value.reference.update(
            Member(
              memberName: name,
              memberPicture: _downloadUrl!,
              memberNumber: phoneNumber,
              memberFullAdress: fullAddress,
              isCustom: isCustom,
            ).toMap(),
          );
        },
      );
    } on Exception catch (e) {
      print(e);
    }
    fetchMembersList();
    Get.back();
  }

  /// Remove or Delete A Member
  Future<void> removeMember({required String memberID}) async {
    /// NEED TO DELETE THE USER PICTURE AS WELL WHEN REMOVING USER
    await _customMembersCollections.doc(memberID).delete();
    await Get.find<SpaceController>()
        .removeAmemberFromAllSpace(userID: memberID);
    await DeletePicture.ofMember(userID: _currentAdminID, memberID: memberID);
    await fetchMembersList();
    update();
  }

  /// Add Members by QR Code
  Future<void> addAppMembersFromQRCode({required String userID}) async {
    final _response = await _repository.addAppMember(
        userID: userID, adminID: _currentAdminID);
    _response.fold(
        (l) =>
            AppToast.showDefaultToast('There is an error Adding This Member'),
        (r) =>
            {Get.back(), AppToast.showDefaultToast('Member has been added')});
  }

  /// Delete App Member by QR Code
  Future<void> deleteAppMember({required String userID}) async {
    final _response = await _repository.removeAppMember(
      userID: userID,
      adminID: _currentAdminID,
    );
    _response.fold(
        (l) =>
            AppToast.showDefaultToast('There is an error Removing This Member'),
        (r) =>
            {Get.back(), AppToast.showDefaultToast('Member has been removed')});
  }

  /// Get Member by ID.
  ///
  /// If no member is present in the list then [null] will be returned,
  /// So always check for null;
  Member? getMemberByIDLocal({required String memberID}) {
    // Check If Member EXISTS
    List<String> _allMemberID = [];
    for (var element in allMembers) {
      _allMemberID.add(element.memberID!);
    }

    Member? member;
    // if the member exist
    if (_allMemberID.contains(memberID)) {
      member =
          allMembers.singleWhere((element) => element.memberID == memberID);
    } else {
      member = null;
    }
    return member;
  }

  /* <-----------------------> 
    **** Attendance Related ****
   -----------------------> */

  Future<List<DateTime>> fetchThisYearAttendnce({
    required String memberID,
    required String spaceID,
    required int year,
  }) async {
    String thisYear = year.toString();
    List<DateTime> _unatttendedDate = [];
    await _customMembersCollections
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data')
        .doc(thisYear)
        .get()
        .then((value) {
      Map<String, dynamic>? _allDateMonth = value.data();
      print(_allDateMonth ?? 'No Record Found');
      List<dynamic> _unattendedDateInTimeStamp = [];
      if (_allDateMonth != null && _allDateMonth['unattended_date'] != null) {
        _unattendedDateInTimeStamp = _allDateMonth['unattended_date'];
        for (var element in _unattendedDateInTimeStamp) {
          DateTime _date = element.toDate();
          _unatttendedDate.add(_date);
        }
      }
    });

    /// Dubugging Purpose
    // _unatttendedDate.forEach((element) {
    //   print("Unattended Dates are: [${DateFormat.MMMMd().format(element)}]");
    //   print(element.day);
    // });

    return _unatttendedDate;
  }

  bool isMemberAttendedToday({required List<DateTime> unattendedDate}) {
    // We should format this accoroding to this one
    DateFormat _dateFormat = DateFormat.yMMMMd();

    /// To compare if the date exist in the list
    List<String> _allDateString = [];
    for (var element in unattendedDate) {
      String date = _dateFormat.format(element);
      _allDateString.add(date);
    }

    String _todayDateInFormat = _dateFormat.format(DateTime.now());

    bool _isMemberAttended = false;

    if (_allDateString.contains(_todayDateInFormat)) {
      print('Member is unattended today');
      _isMemberAttended = false;
    } else {
      print('Member is attended today');
      _isMemberAttended = true;
    }

    return _isMemberAttended;
  }

  //// ATTENDANCE GIVE
  Future<void> attendanceAddMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    await MemberAttendanceRepository(adminID: _currentAdminID).addAttendance(
      memberID: memberID,
      spaceID: spaceID,
      date: date,
    );
  }

  //// ATTENDANCE REMOVE
  Future<void> attendanceRemoveMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    await MemberAttendanceRepository(adminID: _currentAdminID).attendanceRemove(
      memberID: memberID,
      spaceID: spaceID,
      date: date,
    );
  }

  /// Remove Multiple Attendance
  Future<void> attendanceRemoveMultiple({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    await MemberAttendanceRepository(adminID: _currentAdminID)
        .multipleAttendanceDelete(
      memberID: memberID,
      spaceID: spaceID,
      dates: dates,
    );
  }

  /// ADD Multiple Attendance
  Future<void> attendanceAddMultiple({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    await MemberAttendanceRepository(adminID: _currentAdminID)
        .multipleAttendanceAdd(
      memberID: memberID,
      spaceID: spaceID,
      dates: dates,
    );
  }

  // Search Member Attendence
  Future<bool> searchMemberAttendance({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    List<DateTime> _unattendedDate = [];
    _unattendedDate = await fetchThisYearAttendnce(
      memberID: memberID,
      spaceID: spaceID,
      year: date.year,
    );

    bool _isMemberWasAttended = false;
    _isMemberWasAttended = !DateHelper.doesContainThisDate(
      date: date,
      allDates: _unattendedDate,
    );
    return _isMemberWasAttended;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeRepositroy();
    fetchMembersList();
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }
}
