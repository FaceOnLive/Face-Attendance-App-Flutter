import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/services/date_helper.dart';
import '../../views/pages/03_entrypoint/entrypoint.dart';
import '../members/member_controller.dart';
import '../../services/space_services.dart';
import '../../constants/app_colors.dart';
import '../../models/member.dart';
import '../auth/login_controller.dart';
import '../../models/space.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpaceController extends GetxController {
  /* <---- Dependency ----> */
  late CollectionReference _collectionReference = FirebaseFirestore.instance
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
  List<IconData> allIconsOptions = [
    Icons.home_rounded,
    Icons.business_rounded,
    Icons.food_bank_rounded,
    Icons.tour,
  ];

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
      radioOption = 0;
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
    _allMembers.forEach((element) {
      if (_currentSpace.memberList.contains(element.memberID)) {
        _allMembersSpace.add(element);
      } else {
        // print('Member does not belong to ${currentSpace!.name}');
      }
    });
    update();
  }

  /// Get Member List By Space
  List<Member> getMembersBySpaceID({required String spaceID}) {
    List<Member> _allSpaceMembers = [];
    // Check if the space exist
    Space? _space = getSpaceById(spaceID: spaceID);

    // if the space exist
    if (_space != null) {
      List<Member> _allFetchedMembers = Get.find<MembersController>().allMember;
      _allFetchedMembers.forEach((element) {
        if (_space.memberList.contains(element.memberID)) {
          _allSpaceMembers.add(element);
        } else {
          // print('Member does not belong to ${currentSpace!.name}');
        }
      });
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
      value.docs.forEach((element) {
        Space _fetchedSpace = Space.fromDocumentSnap(element);
        allSpaces.add(_fetchedSpace);
      });
      print('Total Space fetched: ${value.docs.length}');
      if (currentSpace == null && value.docs.length > 0) {
        _setSpaceID(allSpaces);
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
        backgroundColor: AppColors.APP_GREEN,
        snackStyle: SnackStyle.GROUNDED,
      );
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove Space
  Future<void> removeSpace({required String spaceID}) async {
    try {
      await _collectionReference.doc(spaceID).delete();
      await _fetchAllSpaces();
      Get.offAll(() => EntryPointUI());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Add Members To A Certain Space
  Future<void> addMembersToSpace({
    required String spaceID,
    required List<Member> members,
  }) async {
    List<String> membersIDs = [];
    await Future.forEach<Member>(members, (element) {
      membersIDs.add(element.memberID!);
    });
    try {
      await _collectionReference.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayUnion(membersIDs),
        });
      });
      await refreshAll();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove Members From A Space
  Future<void> removeMembersFromSpace({
    required String spaceID,
    required List<Member> members,
  }) async {
    List<String> membersIDs = [];
    await Future.forEach<Member>(members, (element) {
      membersIDs.add(element.memberID!);
    });
    try {
      await _collectionReference.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayRemove(membersIDs),
        });
      });
      await refreshAll();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove A Member from All Space
  /// This is useful if you are deleting a user
  Future<void> removeAmemberFromAllSpace({required String userID}) async {
    await _collectionReference
        .where('memberList', arrayContains: userID)
        .get()
        .then((value) async {
      await Future.forEach<DocumentSnapshot>(value.docs, (element) async {
        await element.reference.update({
          'memberList': FieldValue.arrayRemove([userID])
        });
      });
    });

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

  /// Set Space ID to a Default Value or The one the user setted earlier
  void _setSpaceID(List<Space> fetchedSpaces) {
    String? savedSpaceID =
        SpaceServices.getCurrentSavedSpaceID(userID: _currentUserID);
    if (savedSpaceID != null) {
      Space _space = fetchedSpaces.singleWhere(
        (element) => element.spaceID == savedSpaceID,
      );
      currentSpace = _space;
    } else {
      currentSpace = fetchedSpaces[0];
    }
  }

  /// Get Space by ID
  Space? getSpaceById({required String spaceID}) {
    Space? _space;
    List<String> allSpacesId = [];
    allSpaces.forEach((element) {
      allSpacesId.add(element.spaceID!);
    });
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
    memberAttendedToday = await Get.find<MembersController>()
        .fetchMembersAttendedTodayList(spaceID: currentSpace!.spaceID!);
  }

  /// List to return based on user interation
  List<Member> spacesMember = [];

  /// When user select attendance button
  void _onAttendedSelection() {
    spacesMember = [];
    todayAttended.keys.forEach((member) {
      spacesMember = _allMembersSpace
          .where((element) => element.memberID == member)
          .toList();
    });
    update();
  }

  /// When user select unattendance button
  void _onUnattendedSelection() {
    spacesMember = [];
    todayAttended.keys.forEach((member) {
      spacesMember = _allMembersSpace
          .where((element) => element.memberID != member)
          .toList();
    });
    update();
  }

  /// When Both Are Selected
  void _onBothButtonSelection() {
    spacesMember = [];
    spacesMember = _allMembersSpace;
    update();
  }

  /// Switch, used in homescreen
  int radioOption = 0;

  void onRadioSelection(int selected) {
    if (selected == 0) {
      radioOption = 0;
      _onBothButtonSelection();
    } else if (selected == 1) {
      radioOption = 1;
      _onAttendedSelection();
    } else if (selected == 2) {
      radioOption = 2;
      _onUnattendedSelection();
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
          .collection('today_log')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          // Individual doc contains a timestamp
          Timestamp _timeInStamp = element.data()['attended_at'];
          DateTime _timeInDate = _timeInStamp.toDate();
          todayAttended.addAll(
            {element.id: _timeInDate},
          );
        });
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

  /// Refreshes Everything from Start
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
