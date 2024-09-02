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
    String memberID;
    try {
      DocumentReference doc = await customMemberCollection.add(member.toMap());
      memberID = doc.id;
      return Right(memberID);
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
    List<Member> memberCollection = [];
    try {
      // Get Admin Doc
      DocumentSnapshot docSnapShot =
          await appMemberCollection.doc(adminID).get();

      if (docSnapShot.exists) {
        // Convert it
        Map<String, dynamic> allMemberIDs =
            docSnapShot.data() as Map<String, dynamic>;

        /// Member ID in String
        List<String> memberIDs =
            List<String>.from(allMemberIDs['appMembers']);

        // Convert it
        await Future.forEach<String>(memberIDs, (singleMember) async {
          // Fetch Member
          Member? member =
              await UserServices.getMemberByID(userID: singleMember);
          // Check null
          if (member != null) {
            memberCollection.add(member);
          }
        });
      }

      /// Return The Data
      return Right(memberCollection);
    } on Exception catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, List<Member>>> getCustomMembersALL() async {
    List<Member> memberCollection = [];
    try {
      await customMemberCollection.get().then((queryDoc) {
        for (var memberQ in queryDoc.docs) {
          Member member = Member.fromDocumentSnap(memberQ);
          memberCollection.add(member);
        }
      });
      return Right(memberCollection);
    } on Exception catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<ServerFailure, List<Member>>> getAllMembers(
      {required String adminID}) async {
    List<Member> fetchedAllMember = [];
    try {
      // Get The Data
      final allAppMember = await getAppMembersALL(adminID: adminID);
      final allCustomMember = await getCustomMembersALL();

      // Extract
      allAppMember.fold(
        (l) => throw Exception(),
        (r) => {fetchedAllMember.addAll(r)},
      );

      allCustomMember.fold(
        (l) => throw Exception(),
        (r) => {fetchedAllMember.addAll(r)},
      );
      // Return
      return Right(fetchedAllMember);
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
        Member updated = newData;
        await customMemberCollection
            .doc(oldData.memberID)
            .update(updated.toMap());

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
      final docRef = await appMemberCollection.doc(adminID).get();
      if (docRef.exists) {
        docRef.reference.update({});
      } else {
        docRef.reference.set({
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
    Member? fetchedMember = await UserServices.getMemberByID(userID: userID);
    if (fetchedMember != null) {
      return Right(fetchedMember);
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
      Member? fetchedMember = Member.fromDocumentSnap(docSnap);
      return Right(fetchedMember);
    } on ServerExeption catch (_) {
      return Left(NotFoundFailure(errorMessage: 'Member Not Found'));
    }
  }
}
