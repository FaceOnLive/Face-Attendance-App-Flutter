import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/core/error/exceptions.dart';
import 'package:face_attendance/core/models/member.dart';
import 'package:face_attendance/data/providers/app_toast.dart';
import 'package:face_attendance/data/providers/date_helper.dart';
import 'package:face_attendance/data/services/member_services.dart';

class MemberRepository {
  final String userID;

  MemberRepository(this.userID);

  /// All Members Collection
  late final CollectionReference _collectionReference = FirebaseFirestore
      .instance
      .collection('members')
      .doc(userID)
      .collection('members_collection');

  /// Get All Members
  Future<List<Member>> getAllCustomMember() async {
    List<Member> _allMember = [];
    try {
      await _collectionReference.get().then((value) {
        for (var element in value.docs) {
          Member _currenMember = Member.fromDocumentSnap(element);
          _allMember.add(_currenMember);
        }
      });
    } on ServerExeption catch (e) {
      AppToast.showDefaultToast(e.toString());
    }
    return _allMember;
  }

  /// Get Next 8 Member
  Future<List<Member>> getNext10Member(DocumentSnapshot? doc) async {
    List<Member> _allMember = [];
    try {
      if (doc == null) {
        await _collectionReference.get().then((value) {
          for (var element in value.docs) {
            Member _currenMember = Member.fromDocumentSnap(element);
            _allMember.add(_currenMember);
          }
        });
      } else {
        await _collectionReference.startAfterDocument(doc).get().then(
          (value) {
            for (var element in value.docs) {
              Member _currenMember = Member.fromDocumentSnap(element);
              _allMember.add(_currenMember);
            }
          },
        );
      }
    } on ServerExeption catch (e) {
      AppToast.showDefaultToast(e.toString());
    }
    return _allMember;
  }

  /// Get APP MEMBER
  Future<List<Member>> getAppMember({
    required List<String> memberIDs,
    required String spaceID,
  }) async {
    List<Member> _allFetchedMembers = [];

    try {
      await Future.forEach<String>(memberIDs, (memberID) async {
        Member? _fetchedMember =
            await UserServices.getMemberByID(userID: memberID);
        if (_fetchedMember != null) {
          _allFetchedMembers.add(_fetchedMember);
        }
      });
    } on ServerExeption catch (e) {
      AppToast.showDefaultToast(e.toString());
    }

    return _allFetchedMembers;
  }

  /// All Member That Attended Today
  Future<List<String>> getMemberAttendedList({required String spaceID}) async {
    List<String> _memberAttendedToday = [];
    String _currentYear = DateTime.now().year.toString();

    await _collectionReference.get().then((allMembers) async {
      return await Future.forEach<QueryDocumentSnapshot>(allMembers.docs,
          (member) async {
        /// Current Member attendance
        Map<String, dynamic>? _fetchedData = await member.reference
            .collection('attendance')
            .doc(spaceID)
            .collection('data')
            .doc(_currentYear)
            .get()
            .then((value) => value.data());

        /// Member ID
        String _memberID = member.id;

        /// Check if the data exist
        if (_fetchedData != null) {
          List<dynamic> _unattendedDate = _fetchedData['unattended_date'];
          if (DateHelper.doesContainThisDateInTimeStamp(
            date: DateTime.now(),
            allDates: _unattendedDate,
          )) {
            _memberAttendedToday.add(_memberID);
          }
        }
      });
    });
    return _memberAttendedToday;
  }

  /// Get A Single Member
  Future<Member?> getMember(String id) async {
    Member? _fetchedMember;
    DocumentSnapshot _memberSnap = await _collectionReference.doc(id).get();
    if (_memberSnap.data() != null) {
      _fetchedMember = Member.fromDocumentSnap(_memberSnap);
    }
    return _fetchedMember;
  }

  /// Add Member To Database
  Future<String> addMember(Member member) async {
    DocumentReference _doc = await _collectionReference.add(member.toMap());
    return _doc.id;
  }
}
