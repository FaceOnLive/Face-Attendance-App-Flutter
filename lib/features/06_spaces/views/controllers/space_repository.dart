import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/core/models/member.dart';
import 'package:face_attendance/core/models/space.dart';
import 'package:face_attendance/data/providers/app_toast.dart';
import 'package:face_attendance/data/services/space_services.dart';

class SpaceRepository {
  /// Set Space ID to a Default Value or The one the user setted earlier
  static Space setSpaceID(
      {required List<Space> fetchedSpaces, required String userID}) {
    Space? space;
    String? savedSpaceID = SpaceServices.getCurrentSavedSpaceID(userID: userID);
    if (savedSpaceID != null) {
      Space _space = fetchedSpaces.singleWhere(
        (element) => element.spaceID == savedSpaceID,
      );
      space = _space;
    } else {
      space = fetchedSpaces[0];
    }
    return space;
  }

  /// Remove Space
  static Future<void> removeSpace(String spaceID,
      {required CollectionReference reference}) async {
    try {
      await reference.doc(spaceID).delete();
    } on FirebaseException catch (e) {
      AppToast.showDefaultToast(e.code);
    }
  }

  /// Add Members To A Certain Space
  static Future<void> addMultipleMembers({
    required String spaceID,
    required List<Member> members,
    required CollectionReference reference,
  }) async {
    List<String> membersIDs = [];
    await Future.forEach<Member>(members, (element) {
      membersIDs.add(element.memberID!);
    });
    try {
      await reference.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayUnion(membersIDs),
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove Members From A Space
  static Future<void> removeMultipleMembers({
    required String spaceID,
    required List<Member> members,
    required CollectionReference reference,
  }) async {
    List<String> membersIDs = [];
    await Future.forEach<Member>(members, (element) {
      membersIDs.add(element.memberID!);
    });
    try {
      await reference.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayRemove(membersIDs),
        });
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  /// Remove a member from multiple space
  /// Usefull when Deleting
  static Future<void> removeAmemberFromAllSpace(
      {required String userID, required CollectionReference reference}) async {
    return await reference
        .where('memberList', arrayContains: userID)
        .get()
        .then((value) async {
      await Future.forEach<DocumentSnapshot>(value.docs, (element) async {
        await element.reference.update({
          'memberList': FieldValue.arrayRemove([userID])
        });
      });
    });
  }
}
