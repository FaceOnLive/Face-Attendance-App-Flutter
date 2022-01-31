import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/models/space.dart';
import '../../../../core/utils/app_toast.dart';
import 'space_repository.dart';

class SpaceRepositoryImpl extends SpaceRepository {
  CollectionReference spaceCollection;

  SpaceRepositoryImpl({
    required this.spaceCollection,
  });

  @override
  Future<void> addAppMembersSpace(
      {required List<String> userIDs, required String spaceID}) async {
    try {
      await spaceCollection.doc(spaceID).get().then((value) {
        value.reference.update({
          'appMembers': FieldValue.arrayUnion(userIDs),
        });
      });
    } on FirebaseException catch (e) {
      AppToast.show(e.message.toString());
    }
  }

  @override
  Future<void> addCustomMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  }) async {
    try {
      await spaceCollection.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayUnion(userIDs),
        });
      });
    } on FirebaseException catch (e) {
      AppToast.show(e.message.toString());
    }
  }

  @override
  Future<Either<ServerFailure, String>> createSpace(
      {required Space space}) async {
    try {
      final docRef = await spaceCollection.add(space.toMap());
      String _id = docRef.id;
      return Right(_id);
    } on Exception catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> deleteSpace({required String spaceID}) async {
    try {
      await spaceCollection.doc(spaceID).delete();
    } on Exception catch (_) {
      AppToast.show('Something error happened');
    }
  }

  @override
  Future<Either<ServerFailure, List<Space>>> getAllSpaces(
      String ownerUID) async {
    try {
      List<Space> _fethcedSpaces = [];

      // Get All Spaces
      await spaceCollection
          .where(
            "ownerUID",
            isEqualTo: ownerUID,
          )
          .get()
          .then((spaces) => {
                for (var space in spaces.docs)
                  {_fethcedSpaces.add(Space.fromDocumentSnap(space))}
              });

      return Right(_fethcedSpaces);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, Space>> getSpace(
      {required String spaceID}) async {
    try {
      final documentSnap = await spaceCollection.doc(spaceID).get();
      if (documentSnap.data() == null) {
        throw Exception();
      }
      Space _fethcedSpace = Space.fromDocumentSnap(documentSnap);
      return Right(_fethcedSpace);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> removeAppMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  }) async {
    try {
      await spaceCollection.doc(spaceID).get().then((value) {
        value.reference.update({
          'appMembers': FieldValue.arrayRemove(userIDs),
        });
      });
    } on FirebaseException catch (e) {
      AppToast.show(e.message.toString());
    }
  }

  @override
  Future<void> removeCustomMembersSpace({
    required List<String> userIDs,
    required String spaceID,
  }) async {
    try {
      await spaceCollection.doc(spaceID).get().then((value) {
        value.reference.update({
          'memberList': FieldValue.arrayRemove(userIDs),
        });
      });
    } on FirebaseException catch (e) {
      AppToast.show(e.message.toString());
    }
  }

  @override
  Future<void> removeThisMemberFromAll(
      {required String userID, required bool isCustom}) async {
    if (isCustom) {
      await spaceCollection
          .where('memberList', arrayContains: userID)
          .get()
          .then((value) async {
        await Future.forEach<DocumentSnapshot>(value.docs, (element) async {
          await element.reference.update({
            'memberList': FieldValue.arrayRemove([userID])
          });
        });
      });
    } else {
      await spaceCollection
          .where('appMembers', arrayContains: userID)
          .get()
          .then((value) async {
        await Future.forEach<DocumentSnapshot>(value.docs, (element) async {
          await element.reference.update({
            'appMembers': FieldValue.arrayRemove([userID])
          });
        });
      });
    }
  }

  @override
  Future<void> updateSpace({required Space space}) async {
    try {
      await spaceCollection.doc(space.spaceID).get().then((value) => {
            value.reference.update(space.toMap()),
          });
    } on Exception catch (_) {
      AppToast.show('Something error happened');
    }
  }
}
