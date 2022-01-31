import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/space.dart';
import '../../../core/utils/app_toast.dart';

abstract class AppMemberSpaceRepository {
  /// Get all the spaces details the user is in
  Future<List<Space>> getAllSpaces({required String userID});

  /// Get Space by ID
  Future<Space?> getSpacebyID({required String spaceID});
}

class AppMemberSpaceRepostitoryImpl implements AppMemberSpaceRepository {
  final CollectionReference spaceCollection;
  AppMemberSpaceRepostitoryImpl(this.spaceCollection);

  @override
  Future<List<Space>> getAllSpaces({required String userID}) async {
    List<Space> _fetchedSpace = [];

    try {
      await spaceCollection
          .where("appMembers", arrayContains: userID)
          .get()
          .then((spaceList) => {
                for (var item in spaceList.docs)
                  {_fetchedSpace.add(Space.fromDocumentSnap(item))}
              });
    } on FirebaseException catch (e) {
      AppToast.show(e.message ?? "Something Error happened");
    }

    return _fetchedSpace;
  }

  @override
  Future<Space?> getSpacebyID({required String spaceID}) async {
    Space? _theSpace;
    final doc = await spaceCollection.doc(spaceID).get();
    if (doc.exists) {
      _theSpace = Space.fromDocumentSnap(doc);
    }
    return _theSpace;
  }
}
