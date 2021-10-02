import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../spaces/space_controller.dart';
import '../../services/deletePicture.dart';
import '../../services/uploadPicture.dart';
import '../auth/login_controller.dart';
import '../../models/member.dart';
import 'package:get/get.dart';

class MembersController extends GetxController {
  /* <---- Dependency ----> */
  /// All Members Collection
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
  /// List Of All the fetched Members
  List<Member> allMember = [];
  bool isFetchingUser = false;

  /// Fetch All Members from _collectionReference
  Future<void> fetchMembersList() async {
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
        userID: _currentUserID,
      );

      await _newlyAddedMember.update({
        'memberPicture': _downloadUrl,
      });

      print("Member Added ${_newlyAddedMember.id}");
      fetchMembersList();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  /// Edit or Update Member Data
  Future<void> updateMember({
    required String name,
    required File? memberPicture,
    required int phoneNumber,
    required String fullAddress,
    required Member member,
  }) async {
    try {
      String? _downloadUrl;
      // If user has picked an image
      if (memberPicture != null) {
        _downloadUrl = await UploadPicture.ofMember(
          memberID: member.memberID!,
          imageFile: memberPicture,
          userID: _currentUserID,
        );
      } else {
        _downloadUrl = member.memberPicture;
      }

      await _collectionReference.doc(member.memberID!).get().then(
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
    fetchMembersList();
    Get.back();
  }

  /// Remove or Delete A Member
  Future<void> removeMember({required String memberID}) async {
    /// NEED TO DELETE THE USER PICTURE AS WELL WHEN REMOVING USER
    await _collectionReference.doc(memberID).delete();
    await Get.find<SpaceController>()
        .removeAmemberFromAllSpace(userID: memberID);
    await DeletePicture.ofMember(userID: _currentUserID, memberID: memberID);
    await fetchMembersList();
    update();
  }

  /// Get Member by ID.
  ///
  /// If no member is present in the list then [null] will be returned,
  /// So always check for null; For Example:
  /// ```dart
  ///  Member? _fetchMember = MemberController()
  /// .getMemberByID(memberID: 'hBKuNPs1bJOzmTlJhsm3');
  /// if (_fetchMember != null) {
  /// verifiedMember = _fetchMember;
  /// print(_fetchMember.memberName);
  /// }
  /// ```
  Member? getMemberByID({required String memberID}) {
    // Check If Member EXISTS
    List<String> _allMemberID = [];
    allMember.forEach((element) {
      _allMemberID.add(element.memberID!);
    });

    Member? member;
    // if the member exist
    if (_allMemberID.contains(memberID)) {
      member = allMember.singleWhere((element) => element.memberID == memberID);
    } else {
      member = null;
    }
    return member;
  }

  /* <-----------------------> 
    **** Attendance Related ****
   -----------------------> */

  Future<List<DateTime>> fetchThisYearAttendnce({
    required String memberID,
    required String spaceID,
    required int year,
  }) async {
    String thisYear = year.toString();
    List<DateTime> _unatttendedDate = [];
    await _collectionReference
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data')
        .doc(thisYear)
        .get()
        .then((value) {
      Map<String, dynamic>? _allDateMonth = value.data();
      print(_allDateMonth ?? 'No Record Found');
      List<dynamic> _unattendedDateInTimeStamp = [];
      if (_allDateMonth != null && _allDateMonth['unattended_date'] != null) {
        _unattendedDateInTimeStamp = _allDateMonth['unattended_date'];
        _unattendedDateInTimeStamp.forEach((element) {
          DateTime _date = element.toDate();
          _unatttendedDate.add(_date);
        });
      }
    });
    // _unatttendedDate.forEach((element) {
    //   print("Unattended Dates are: [${DateFormat.MMMMd().format(element)}]");
    //   print(element.day);
    // });

    return _unatttendedDate;
  }

  /* <---- MEMBER ATTENDANCE CHECK -----> */
  ////  VERSION 0.1
  ///
  /// Is the member Attended Today
  // Future<bool> isMemberAttendedToday(
  //     {required String memberID, required String spaceID}) async {
  //   List<DateTime> _unattendedData = await fetchThisYearAttendnce(
  //     memberID: memberID,
  //     spaceID: spaceID,
  //     year: DateTime.now().year,
  //   );
  //   // We should format this accoroding to this one
  //   DateFormat _dateFormat = DateFormat.yMMMMd();

  //   /// To compare if the date exist in the list
  //   List<String> _allDateString = [];
  //   await Future.forEach<DateTime>(_unattendedData, (element) {
  //     String date = _dateFormat.format(element);
  //     _allDateString.add(date);
  //   });

  //   String _todayDateInFormat = _dateFormat.format(DateTime.now());

  //   bool _isMemberAttended = false;

  //   if (_allDateString.contains(_todayDateInFormat)) {
  //     print('Member is unattended today');
  //     _isMemberAttended = false;
  //   } else {
  //     print('Member is attended today');
  //     _isMemberAttended = true;
  //   }

  //   return _isMemberAttended;
  // }

  bool isMemberAttendedToday({required List<DateTime> unattendedDate}) {
    // We should format this accoroding to this one
    DateFormat _dateFormat = DateFormat.yMMMMd();

    /// To compare if the date exist in the list
    List<String> _allDateString = [];
    unattendedDate.forEach((element) {
      String date = _dateFormat.format(element);
      _allDateString.add(date);
    });

    String _todayDateInFormat = _dateFormat.format(DateTime.now());

    bool _isMemberAttended = false;

    if (_allDateString.contains(_todayDateInFormat)) {
      print('Member is unattended today');
      _isMemberAttended = false;
    } else {
      print('Member is attended today');
      _isMemberAttended = true;
    }

    return _isMemberAttended;
  }

  //// ATTENDANCE GIVE
  Future<void> attendanceAddMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    await _collectionReference.doc(memberID).get().then((value) {
      value.reference.collection('attendance').doc(spaceID).get().then((value) {
        value.reference
            .collection('data')
            .doc(date.year.toString())
            .get()
            .then((value) {
          value.reference.update({
            'unattended_date':
                FieldValue.arrayRemove([Timestamp.fromDate(date)])
          });
        });
      });
    });
  }

  //// ATTENDANCE REMOVE
  Future<void> attendanceRemoveMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    await _collectionReference.doc(memberID).get().then((value) {
      value.reference.collection('attendance').doc(spaceID).get().then((value) {
        value.reference
            .collection('data')
            .doc(date.year.toString())
            .get()
            .then((value) {
          value.reference.update({
            'unattended_date': FieldValue.arrayUnion([Timestamp.fromDate(date)])
          });
        });
      });
    });
  }

  /// Remove Multiple Attendance
  Future<void> attendanceRemoveMultiple({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> _dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      _dateInTimeStamp.add(Timestamp.fromDate(element));
    });

    await _collectionReference.doc(memberID).get().then((value) {
      value.reference.collection('attendance').doc(spaceID).get().then((value) {
        value.reference
            .collection('data')
            .doc(DateTime.now().year.toString())
            .get()
            .then((value) {
          value.reference.update(
              {'unattended_date': FieldValue.arrayUnion(_dateInTimeStamp)});
        });
      });
    });
  }

  /// ADD Multiple Attendance
  Future<void> attendanceAddMultiple({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> _dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      _dateInTimeStamp.add(Timestamp.fromDate(element));
    });

    await _collectionReference.doc(memberID).get().then((value) {
      value.reference.collection('attendance').doc(spaceID).get().then((value) {
        value.reference
            .collection('data')
            .doc(DateTime.now().year.toString())
            .get()
            .then((value) {
          value.reference.update(
              {'unattended_date': FieldValue.arrayRemove(_dateInTimeStamp)});
        });
      });
    });
  }

  /// Temporary Function To Add Attendance to all member
  // _addAttendance(String spaceID) async {
  //   _collectionReference.get().then((value) async {
  //     await Future.forEach<QueryDocumentSnapshot>(value.docs, (element) async {
  //       await element.reference
  //           .collection('attendance')
  //           .doc(spaceID)
  //           .collection('data')
  //           .doc('2021')
  //           .set({
  //         'unattended_date': [],
  //       });
  //       print('Added Attendance to ${element.id}');
  //     });
  //   });
  // }

  @override
  void onInit() {
    super.onInit();
    _getCurrentUserID();
    fetchMembersList();
    // _addAttendance('hHwgUrdKKnXfpdrgJnbR');
  }
}
