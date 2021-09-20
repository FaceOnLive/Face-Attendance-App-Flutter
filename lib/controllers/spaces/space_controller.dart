import 'package:cloud_firestore/cloud_firestore.dart';
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
  _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /// Space Options
  /// [Important] At least one Icon is required for this to work correctly
  /// These icons are used for Adding, Modifying, Removing space screen.
  List<IconData> allIcons = [
    Icons.home_rounded,
    Icons.business_rounded,
    Icons.food_bank_rounded,
    Icons.tour,
  ];

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
  onSpaceChange(String? value) {
    if (value != null) {
      Space? _space = allSpaces
          .singleWhere((element) => element.name.toLowerCase() == value);
      currentSpace = _space;
      update();
    }
  }

  /// To show progress indicator
  bool isFetchingSpaces = false;

  /// Fetch All Spaces of This User ID
  _fetchAllSpaces() async {
    isFetchingSpaces = true;
    allSpaces.clear();
    await _collectionReference.get().then((value) {
      value.docs.forEach((element) {
        Space _currentSpace = Space.fromDocumentSnap(element);
        allSpaces.add(_currentSpace);
      });
      print('Total Space fetched: ${value.docs.length}');
      if (currentSpace == null && value.docs.length > 0) {
        currentSpace = allSpaces[0];
      }
    });

    isFetchingSpaces = false;
    update();
  }

  /// Add Space
  Future<void> addSpace({required Space space}) async {
    try {
      await _collectionReference.add(space.toMap());
      _fetchAllSpaces();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Modify The Space Data
  Future<void> editSpace({required Space space}) async {
    try {
      await _collectionReference.doc(space.spaceID).update(space.toMap());
      _fetchAllSpaces();
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
      _fetchAllSpaces();
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
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove Members From A Space
  Future<void> removeMembersFromSpace({
    required String spaceID,
    required List<String> userIDs,
  }) async {
    try {
      await _collectionReference.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayRemove(userIDs),
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchAllSpaces();
  }
}
