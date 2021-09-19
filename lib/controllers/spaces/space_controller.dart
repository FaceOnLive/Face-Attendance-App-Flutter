import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<IconData> allIcons = [
    Icons.home_rounded,
    Icons.business_rounded,
    Icons.food_bank_rounded,
    Icons.tour,
  ];

  /// Space List
  List<Space> allSpaces = [];

  /// Currently Selected Space
  // Space currentSpace;

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

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchAllSpaces();
  }
}
