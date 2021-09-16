import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/services/deletePicture.dart';
import '../../services/uploadPicture.dart';
import '../auth/login_controller.dart';
import '../../models/member.dart';
import 'package:get/get.dart';

class MembersController extends GetxController {
  /* <---- Dependency ----> */
  late CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('members')
      .doc(_currentUserID)
      .collection('members_collection');

  /// User ID of Current Logged In user
  late String _currentUserID;
  _getCurrentUserID() {
    _currentUserID = Get.find<LoginController>().user!.uid;
  }

  /* <---- Members ----> */
  /// List Of Members
  List<Member> allMember = [];
  bool isFetchingUser = false;

  /// Fetch All Members
  _fetchMembers() async {
    isFetchingUser = true;
    // We are going to fetch multiple times, this is to avoid duplication
    allMember = [];
    try {
      await _collectionReference.get().then((value) {
        value.docs.forEach((element) {
          Member _currenMember = Member.fromDocumentSnap(element);
          allMember.add(_currenMember);
        });
      });
    } on Exception catch (e) {
      print(e);
    }
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
      // We should add the member first so that we can get a user Id
      DocumentReference _newlyAddedMember = await _collectionReference.add(
        Member(
                memberName: name,
                memberPicture: '',
                memberNumber: phoneNumber,
                memberFullAdress: fullAddress)
            .toMap(),
      );

      String? _downloadUrl = await UploadPicture.ofMember(
        memberID: _newlyAddedMember.id,
        imageFile: memberPictureFile,
      );

      await _newlyAddedMember.update({
        'memberPicture': _downloadUrl,
      });

      print("Member Added ${_newlyAddedMember.id}");
      _fetchMembers();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  /// Edit or Update Member Data
  Future<void> updateMember({
    required String name,
    required File memberPicture,
    required int phoneNumber,
    required String fullAddress,
    required String memberID,
  }) async {
    try {
      String? _downloadUrl = await UploadPicture.ofMember(
        memberID: memberID,
        imageFile: memberPicture,
      );

      await _collectionReference.doc(memberID).get().then(
        (value) {
          value.reference.update(
            Member(
                    memberName: name,
                    memberPicture: _downloadUrl!,
                    memberNumber: phoneNumber,
                    memberFullAdress: fullAddress)
                .toMap(),
          );
        },
      );
    } on Exception catch (e) {
      print(e);
    }
    _fetchMembers();
    Get.back();
  }

  /// Remove or Delete A Member
  Future<void> removeMember({required String memberID}) async {
    /// NEED TO DELETE THE USER PICTURE AS WELL WHEN REMOVING USER
    await _collectionReference.doc(memberID).delete();
    await DeletePicture.ofMember(memberID: memberID);
    _fetchMembers();
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchMembers();
  }
}
