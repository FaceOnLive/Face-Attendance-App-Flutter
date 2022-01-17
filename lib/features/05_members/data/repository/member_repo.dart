import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/data/services/member_services.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/member.dart';

abstract class MemberRepository {
  /// Get All The Custom Member That is Created by this User |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, List<Member>>> getCustomMembersALL();

  /// Get All The App Member |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, List<Member>>> getAppMembersALL(
      {required String adminID});

  /// Get All The Members (Custom+AppMember) together |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, List<Member>>> getAllMembers(
      {required String adminID});

  /// Add The Member To The Repo |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, String>> addCustomMember(
      {required Member member});

  /// Update The Member |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, void>> updateCustomMember({
    required Member oldData,
    required Member newData,
    required String adminID,
  });

  /// Delete Member |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, void>> deleteCustomMember({
    required String memberID,
    required String adminID,
  });

  /// Add App Member From QR Code, or Manually |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, void>> addAppMember(
      {required String userID, required String adminID});

  /// Remove App Member |
  /// Will Return ServerFailure on Exceptions
  Future<Either<ServerFailure, void>> removeAppMember(
      {required String userID, required String adminID});

  /// Get A Single Custom Member |
  /// Will Return ServerFailure on Exceptions
  Future<Either<NotFoundFailure, Member>> getCustomMember(
      {required String userID});

  /// Get A Single App Member |
  /// Will Return ServerFailure on Exceptions
  Future<Either<NotFoundFailure, Member>> getAppMember(
      {required String userID});
}

class MemberRepositoryImpl extends MemberRepository {
  // final String adminID;
  final CollectionReference appMemberCollection;
  final CollectionReference customMemberCollection;

  MemberRepositoryImpl({
    // required this.adminID,
    required this.appMemberCollection,
    required this.customMemberCollection,
  });

  @override
  Future<Either<ServerFailure, String>> addCustomMember(
      {required Member member}) async {
    String _memberID;
    try {
      DocumentReference _doc = await customMemberCollection.add(member.toMap());
      _memberID = _doc.id;
      return Right(_memberID);
    } on FirebaseException catch (_) {
      return Left(ServerFailure(errorMessage: 'Failed To Add Custom Member'));
    }
  }

  @override
  Future<Either<ServerFailure, void>> deleteCustomMember(
      {required String memberID, required String adminID}) async {
    try {
      await customMemberCollection.doc(memberID).delete();
      return const Right(null);
    } on FirebaseException catch (_) {
      return Left(ServerFailure(
        errorMessage: 'Failed To Delete Custom Member',
      ));
    }
  }

  @override
  Future<Either<ServerFailure, List<Member>>> getAppMembersALL(
      {required String adminID}) async {
    List<Member> _memberCollection = [];
    try {
      // Get Admin Doc
      DocumentSnapshot _docSnapShot =
          await appMemberCollection.doc(adminID).get();

      if (_docSnapShot.exists) {
        // Convert it
        Map<String, dynamic> _allMemberIDs =
            _docSnapShot.data() as Map<String, dynamic>;

        /// Member ID in String
        List<String> _memberIDs =
            List<String>.from(_allMemberIDs['appMembers']);

        // Convert it
        await Future.forEach<String>(_memberIDs, (singleMember) async {
          // Fetch Member
          Member? _member =
              await UserServices.getMemberByID(userID: singleMember);
          // Check null
          if (_member != null) {
            _memberCollection.add(_member);
          }
        });
      }

      /// Return The Data
      return Right(_memberCollection);
    } on Exception catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, List<Member>>> getCustomMembersALL() async {
    List<Member> _memberCollection = [];
    try {
      await customMemberCollection.get().then((queryDoc) {
        for (var memberQ in queryDoc.docs) {
          Member _member = Member.fromDocumentSnap(memberQ);
          _memberCollection.add(_member);
        }
      });
      return Right(_memberCollection);
    } on Exception catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, List<Member>>> getAllMembers(
      {required String adminID}) async {
    List<Member> _fetchedAllMember = [];
    try {
      // Get The Data
      final _allAppMember = await getAppMembersALL(adminID: adminID);
      final _allCustomMember = await getCustomMembersALL();

      // Extract
      _allAppMember.fold(
        (l) => throw Exception(),
        (r) => {_fetchedAllMember.addAll(r)},
      );

      _allCustomMember.fold(
        (l) => throw Exception(),
        (r) => {_fetchedAllMember.addAll(r)},
      );
      // Return
      return Right(_fetchedAllMember);
    } on Exception catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, void>> updateCustomMember({
    required Member oldData,
    required Member newData,
    required String adminID,
  }) async {
    if (oldData == newData) {
      return const Right(null);
    } else {
      try {
        Member _updated = newData;
        await customMemberCollection
            .doc(oldData.memberID)
            .update(_updated.toMap());

        return const Right(null);
      } on FirebaseException catch (_) {
        return Left(ServerFailure(errorMessage: 'Failed To Add Custom Member'));
      }
    }
  }

  @override
  Future<Either<ServerFailure, void>> addAppMember(
      {required String userID, required String adminID}) async {
    try {
      final _docRef = await appMemberCollection.doc(adminID).get();
      if (_docRef.exists) {
        _docRef.reference.update({});
      } else {
        _docRef.reference.set({
          'appMembers': FieldValue.arrayUnion([userID])
        });
      }
      return const Right(null);
    } on FirebaseException catch (_) {
      return Left(ServerFailure(errorMessage: 'Failed To Add App Member'));
    }
  }

  @override
  Future<Either<ServerFailure, void>> removeAppMember(
      {required String userID, required String adminID}) async {
    try {
      await appMemberCollection.doc(adminID).update({
        'appMembers': FieldValue.arrayRemove([userID])
      });
      return const Right(null);
    } on FirebaseException catch (_) {
      return Left(ServerFailure(errorMessage: 'Failed To Delete App Member'));
    }
  }

  @override
  Future<Either<NotFoundFailure, Member>> getAppMember(
      {required String userID}) async {
    Member? _fetchedMember = await UserServices.getMemberByID(userID: userID);
    if (_fetchedMember != null) {
      return Right(_fetchedMember);
    } else {
      return Left(NotFoundFailure(errorMessage: 'Member Not Found'));
    }
  }

  @override
  Future<Either<NotFoundFailure, Member>> getCustomMember(
      {required String userID}) async {
    try {
      final docSnap = await customMemberCollection.doc(userID).get();
      if (docSnap.data() == null) {
        throw ServerExeption();
      }
      Member? _fetchedMember = Member.fromDocumentSnap(docSnap);
      return Right(_fetchedMember);
    } on ServerExeption catch (_) {
      return Left(NotFoundFailure(errorMessage: 'Member Not Found'));
    }
  }
}
