import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/core/auth/controllers/login_controller.dart';
import 'package:face_attendance/core/models/log_message.dart';
import 'package:face_attendance/core/models/member.dart';
import 'package:face_attendance/core/models/space.dart';
import 'package:face_attendance/data/services/space_services.dart';
import 'package:face_attendance/features/02_entrypoint/entrypoint.dart';
import 'package:face_attendance/features/05_members/views/controllers/member_controller.dart';
import 'package:face_attendance/features/05_members/views/controllers/member_repository.dart';

import 'space_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';

/// Used in the main home screen
enum MemberFilterList { all, attended, unattended }

class SpaceController extends GetxController {
  /* <---- Dependency ----> */
  late final CollectionReference _collectionReference = FirebaseFirestore
      .instance
      .collection('spaces')
      .doc(_currentUserID)
      .collection('space_collection');

  /// User ID of Current Logged In user
  late String _currentUserID;
  void _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().getCurrentUserID();
  }

  /// Space Options
  /// [Important] At least one Icon is required for this to work correctly
  /// These icons are used for Adding, Modifying, Removing space screen.
  List<IconData> allIconsOptions = Space.availableIcons;

  /// IS Everything Ready for UI
  bool isEverythingFetched = false;

  /// Space List
  List<Space> allSpaces = [];

  /// Currently Selected Space
  Space? currentSpace;

  /// Select A Space at startup
  ///
  /// [ We can save this in local database later ]
  // _spaceSelectionInitially() {
  //   currentSpace = allSpaces[0];
  // }

  /// When user tap on a space in dropdown
  onSpaceChangeDropDown(String? value) {
    if (value != null) {
      Space? _space = allSpaces
          .singleWhere((element) => element.name.toLowerCase() == value);
      currentSpace = _space;
      _addCurrentSpaceMemberToList();
      _onBothButtonSelection();
      selectedOption = MemberFilterList.all;
      SpaceServices.saveSpaceToDevice(space: _space, userID: _currentUserID);
      update();
    }
  }

  /// Contains all the Current Spaces Members
  List<Member> _allMembersSpace = [];
  List<Member> get allMembersSpace => _allMembersSpace;

  /// Add Current Space Members To List
  void _addCurrentSpaceMemberToList() {
    _allMembersSpace = [];
    List<Member> _allMembers = Get.find<MembersController>().allMember;
    Space _currentSpace = currentSpace!;
    for (var element in _allMembers) {
      if (_currentSpace.memberList.contains(element.memberID)) {
        _allMembersSpace.add(element);
      } else {
        // print('Member does not belong to ${currentSpace!.name}');
      }
    }
    update();
  }

  /// Get Member List By Space
  List<Member> getMembersBySpaceID({required String spaceID}) {
    List<Member> _allSpaceMembers = [];
    // Check if the space exist
    Space? _space = getSpaceByIdLocal(spaceID: spaceID);

    // if the space exist
    if (_space != null) {
      List<Member> _allFetchedMembers = Get.find<MembersController>().allMember;
      for (var element in _allFetchedMembers) {
        if (_space.memberList.contains(element.memberID)) {
          _allSpaceMembers.add(element);
        } else {
          // print('Member does not belong to ${currentSpace!.name}');
        }
      }
    }

    // return list
    return _allSpaceMembers;
  }

  /// To show progress indicator
  bool isFetchingSpaces = false;

  /// Fetch All Spaces of This User ID
  Future<void> _fetchAllSpaces() async {
    isFetchingSpaces = true;
    allSpaces.clear();
    await _collectionReference.get().then((value) {
      for (var element in value.docs) {
        Space _fetchedSpace = Space.fromDocumentSnap(element);
        allSpaces.add(_fetchedSpace);
      }
      print('Total Space fetched: ${value.docs.length}');
      if (currentSpace == null && value.docs.isNotEmpty) {
        currentSpace = SpaceRepository.setSpaceID(
          fetchedSpaces: allSpaces,
          userID: _currentUserID,
        );
      }
    });

    isFetchingSpaces = false;
    update();
  }

  /// Add Space
  Future<void> addSpace({required Space space}) async {
    try {
      await _collectionReference.add(space.toMap());
      await _fetchAllSpaces();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Modify The Space Data
  Future<void> editSpace({required Space space}) async {
    try {
      await _collectionReference.doc(space.spaceID).update(space.toMap());
      await _fetchAllSpaces();
      Get.back();
      Get.rawSnackbar(
        title: 'Update Successfull',
        message: 'Space Info Updated Successfully',
        backgroundColor: AppColors.appGreen,
        snackStyle: SnackStyle.GROUNDED,
      );
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove Space
  Future<void> removeSpace({required String spaceID}) async {
    await SpaceRepository.removeSpace(spaceID, reference: _collectionReference);
    await _fetchAllSpaces();
    Get.offAll(() => const EntryPointUI());
  }

  /// Add Members To A Certain Space
  Future<void> addMembersToSpace({
    required String spaceID,
    required List<Member> members,
  }) async {
    await SpaceRepository.addMultipleMembers(
      spaceID: spaceID,
      members: members,
      reference: _collectionReference,
    );
    await refreshAll();
  }

  /// Remove Members From A Space
  Future<void> removeMembersFromSpace({
    required String spaceID,
    required List<Member> members,
  }) async {
    SpaceRepository.removeMultipleMembers(
      spaceID: spaceID,
      members: members,
      reference: _collectionReference,
    );
    await refreshAll();
  }

  /// Remove A Member from All Space
  /// This is useful if you are deleting a user
  Future<void> removeAmemberFromAllSpace({required String userID}) async {
    await SpaceRepository.removeAmemberFromAllSpace(
        userID: userID, reference: _collectionReference);

    /// Remove locally
    _allMembersSpace.removeWhere((element) => element.memberID == userID);
    await _fetchAllSpaces();
    await _fetchCurrentActiveSpace();
  }

  /// Fetch Current Active SPACE
  Future<void> _fetchCurrentActiveSpace() async {
    await _collectionReference.doc(currentSpace!.spaceID).get().then((value) {
      currentSpace = Space.fromDocumentSnap(value);
    });
  }

  /// Get Space by ID
  Space? getSpaceByIdLocal({required String spaceID}) {
    Space? _space;
    List<String> allSpacesId = [];
    for (var element in allSpaces) {
      allSpacesId.add(element.spaceID!);
    }
    if (allSpacesId.contains(spaceID)) {
      _space = allSpaces.singleWhere((element) => element.spaceID == spaceID);
    } else {
      _space = null;
    }
    return _space;
  }

  /// Member That Attended Today
  List<String> memberAttendedToday = [];
  Future<void> _fetchMemberAttendedToday() async {
    memberAttendedToday = await MemberRepository(_currentUserID)
        .getMemberAttendedList(spaceID: currentSpace!.spaceID!);
  }

  /// List to return based on user interation
  List<Member> spacesMember = [];

  /// When user select attendance button
  void _onAttendedSelection() {
    spacesMember = [];
    for (var member in todayAttended.keys) {
      spacesMember = _allMembersSpace
          .where((element) => element.memberID == member)
          .toList();
    }
    update();
  }

  /// When user select unattendance button
  void _onUnattendedSelection() {
    spacesMember = [];
    for (var member in todayAttended.keys) {
      spacesMember = _allMembersSpace
          .where((element) => element.memberID != member)
          .toList();
    }
    update();
  }

  /// When Both Are Selected
  void _onBothButtonSelection() {
    spacesMember = [];
    spacesMember = _allMembersSpace;
    update();
  }

  /// Switch, used in homescreen
  MemberFilterList selectedOption = MemberFilterList.all;

  void onRadioSelection(MemberFilterList filter) {
    switch (filter) {
      case MemberFilterList.all:
        selectedOption = MemberFilterList.all;
        _onBothButtonSelection();
        break;
      case MemberFilterList.attended:
        selectedOption = MemberFilterList.attended;
        _onAttendedSelection();
        break;
      case MemberFilterList.unattended:
        selectedOption = MemberFilterList.unattended;
        _onUnattendedSelection();
        break;
      default:
        selectedOption = MemberFilterList.all;
        _onBothButtonSelection();
    }
  }

  /* <---- LOG -----> */
  /// Temporary Function
  // Future<void> _addTodaysLogToSpace(
  //     {required String spaceID,
  //     required String userID,
  //     required DateTime time}) async {
  //   await _collectionReference
  //       .doc(spaceID)
  //       .collection('today_log')
  //       .doc(userID)
  //       .set({'attended_at': Timestamp.fromDate(time)});
  //   print('LOG HAS BEEN ADDED');
  // }

  /// Todays Log of Current space
  Map<String, DateTime> todayAttended = {};
  bool fetchingTodaysLog = true;

  /// Todays Log of Current Space
  Future<void> _fetchTodaysLogCurrentSpace() async {
    if (currentSpace != null) {
      fetchingTodaysLog = true;
      todayAttended = {};
      update();
      await _collectionReference
          .doc(currentSpace!.spaceID)
          .collection('log_data')
          .get()
          .then((value) {
        for (var element in value.docs) {
          // Individual doc contains a timestamp
          Timestamp _timeInStamp = element.data()['attended_at'];
          DateTime _timeInDate = _timeInStamp.toDate();
          todayAttended.addAll(
            {element.id: _timeInDate},
          );
        }
        // print(todayAttended.toString());
      });
      fetchingTodaysLog = false;
      update();
    }
  }

  /// Is this member Attended Today
  DateTime? isMemberAttendedToday({required String memberID}) {
    if (todayAttended.containsKey(memberID)) {
      return todayAttended[memberID];
    } else {
      return null;
    }
  }

  /// Fetch Log Messages
  Future<List<LogMessage>> fetchLogMessages({required String spaceID}) async {
    List<LogMessage> _logMessages = [];

    await _collectionReference
        .doc(spaceID)
        .collection('attendance_log_today')
        .get()
        .then((messages) => {
              // ignore: avoid_function_literals_in_foreach_calls
              messages.docs.forEach((aMessage) {
                LogMessage _fetchedMessage =
                    LogMessage.fromDocumentSnap(aMessage);
                _logMessages.add(_fetchedMessage);
              })
            });

    return _logMessages;
  }

  /// Refreshes Everything from Start
  /// Everything goes in order
  Future<void> refreshAll() async {
    isEverythingFetched = false;
    _getCurrentUserID();
    await _fetchAllSpaces();
    await _fetchCurrentActiveSpace();
    _addCurrentSpaceMemberToList();
    await _fetchMemberAttendedToday();
    spacesMember = _allMembersSpace;
    isEverythingFetched = true;
    update();
    await _fetchTodaysLogCurrentSpace();
  }

  @override
  void onInit() async {
    super.onInit();
    await refreshAll();
  }
}
