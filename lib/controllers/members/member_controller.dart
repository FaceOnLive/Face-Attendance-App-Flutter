import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/controllers/auth/login_controller.dart';
import 'package:face_attendance/models/member.dart';
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

  /// Fetch All Members
  _fetchMembers() async {
    await _collectionReference.get().then((value) {
      print('Document Length is ${value.docs.length}');
    });
  }

  /// Add Member to Database
  Future<void> addMember({
    required String name,
    required String memberPicture,
    required int phoneNumber,
    required String fullAddress,
  }) async {
    try {
      await _collectionReference.add(
        Member(
                memberName: name,
                memberPicture: memberPicture,
                memberNumber: phoneNumber,
                memberFullAdress: fullAddress)
            .toMap(),
      );
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  /// Edit or Update Member Data
  Future<void> updateMember({
    required String name,
    required String memberPicture,
    required int phoneNumber,
    required String fullAddress,
    required String memberID,
  }) async {
    await _collectionReference.doc(memberID).get().then(
      (value) {
        value.reference.update(
          Member(
                  memberName: name,
                  memberPicture: memberPicture,
                  memberNumber: phoneNumber,
                  memberFullAdress: fullAddress)
              .toMap(),
        );
      },
    );
  }

  /// Remove or Delete A Member
  Future<void> removeMember({required String memberID}) async {
    /// NEED TO DELETE THE USER PICTURE AS WELL WHEN REMOVING USER
    await _collectionReference.doc(memberID).delete();
  }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    _fetchMembers();
  }
}
