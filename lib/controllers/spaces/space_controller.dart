import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/views/pages/03_entrypoint/entrypoint.dart';
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
      SpaceServices.saveSpaceToDevice(space: _space, userID: _currentUserID);
      update();
    }
  }

  /// Current Spaces Members
  List<Member> _currentSpaceMembers = [];

  /// Add Current Space Members To List
  void _addCurrentSpaceMemberToList() {
    _currentSpaceMembers = [];
    List<Member> _allMembers = Get.find<MembersController>().allMember;
    Space _currentSpace = currentSpace!;
    _allMembers.forEach((element) {
      if (_currentSpace.memberList.contains(element.memberID)) {
        _currentSpaceMembers.add(element);
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
      await _fetchAllSpaces();
      await _fetchCurrentActiveSpace();
      _addCurrentSpaceMemberToList();
      update();
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
      await _fetchAllSpaces();
      await _fetchCurrentActiveSpace();
      _addCurrentSpaceMemberToList();
      update();
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
    _currentSpaceMembers.removeWhere((element) => element.memberID == userID);

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

  /// Get Space Details by ID
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
        .fetchMemberAttendedTodayList(spaceID: currentSpace!.spaceID!);
  }

  /// List to return based on user interation
  List<Member> spacesMember = [];

  /// When user select attendance button
  void onAttendedSelection() {
    spacesMember = [];
    memberAttendedToday.forEach((member) {
      spacesMember = _currentSpaceMembers
          .where((element) => element.memberID == member)
          .toList();
    });
    update();
  }

  /// When user select unattendance button
  void onUnattendedSelection() {
    spacesMember = [];
    memberAttendedToday.forEach((member) {
      spacesMember = _currentSpaceMembers
          .where((element) => element.memberID != member)
          .toList();
    });
    update();
  }

  /// When Both Are Selected
  void onBothButtonSelection() {
    spacesMember = [];
    spacesMember = _currentSpaceMembers;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    isEverythingFetched = false;
    _getCurrentUserID();
    await _fetchAllSpaces();
    await _fetchCurrentActiveSpace();
    _addCurrentSpaceMemberToList();
    await _fetchMemberAttendedToday();
    spacesMember = _currentSpaceMembers;
    isEverythingFetched = true;
    update();
  }
}
