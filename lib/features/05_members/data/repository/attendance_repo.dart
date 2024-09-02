import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/date_util.dart';

class MemberAttendanceRepository {
  String adminID;
  MemberAttendanceRepository({
    required this.adminID,
  });

  /* <-----------------------> 
      1: Top Level Functions (MAIN)    
      2: Custom Member Functions (Low Level)
      3: App Member Functions (Low Level)
   <-----------------------> */

  /// All Members Collection
  late final CollectionReference _customMemberCollection = FirebaseFirestore
      .instance
      .collection('members')
      .doc(adminID)
      .collection('members_collection');

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  /* <-----------------------> 
      1: MAIN FUNCTIONS [Works with app member and custom members]    
   <-----------------------> */

  /// Add attendance of a Member
  Future<void> addAttendance({
    required String memberID,
    required String spaceID,
    required DateTime date,
    required bool isCustomMember,
  }) async {
    if (isCustomMember) {
      await addAttendanceCustom(
        memberID: memberID,
        spaceID: spaceID,
        date: date,
      );
    } else {
      await addAttendanceAppMember(
        memberID: memberID,
        spaceID: spaceID,
        date: date,
      );
    }
  }

  /// Attendance Remove of A Member
  Future<void> removeAttendance({
    required String memberID,
    required String spaceID,
    required DateTime date,
    required bool isCustom,
  }) async {
    if (isCustom) {
      await attendanceRemoveCustom(
        memberID: memberID,
        spaceID: spaceID,
        date: date,
      );
    } else {
      await attendanceRemoveAppMember(
        memberID: memberID,
        spaceID: spaceID,
        date: date,
      );
    }
  }

  Future<List<DateTime>> getAttendance({
    required String spaceID,
    required String memberID,
    required bool isCustom,
  }) async {
    List<DateTime> allUnattendedDates = [];
    if (isCustom) {
      allUnattendedDates = await getAttendanceCustom(
        spaceID: spaceID,
        memberID: memberID,
      );
    } else {
      allUnattendedDates = await getAttendanceAppMember(
        spaceID: spaceID,
        memberID: memberID,
      );
    }

    return allUnattendedDates;
  }

  /// Multiple Date Add
  Future<void> multipleAttendanceAdd({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
    required bool isCustom,
  }) async {
    if (isCustom) {
      await multipleAttendanceAddCustom(
        memberID: memberID,
        spaceID: spaceID,
        dates: dates,
      );
    } else {
      await multipleAttendanceAddAppMember(
        memberID: memberID,
        spaceID: spaceID,
        dates: dates,
      );
    }
  }

  /// Multiple Attendance delete at once
  Future<void> multipleAttendanceDelete({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
    required bool isCustom,
  }) async {
    if (isCustom) {
      await multipleAttendanceDeleteCustom(
        memberID: memberID,
        spaceID: spaceID,
        dates: dates,
      );
    } else {
      await multipleAttendanceDeleteAppMember(
        memberID: memberID,
        spaceID: spaceID,
        dates: dates,
      );
    }
  }

  /* <-----------------------> 
      2: Custom Member Functions    
   <-----------------------> */

  /// ATTENDANCE GIVE [Custom_Member]
  Future<void> addAttendanceCustom({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final attendancReference =
        spaceReference.collection('data').doc(date.year.toString());

    final docSnap = await attendancReference.get();

    if (docSnap.exists) {
      await docSnap.reference.update({
        'unattended_date': FieldValue.arrayRemove([DateUtil.convertDate(date)])
      });
    } else {
      await docSnap.reference.set({
        'unattended_date': FieldValue.arrayRemove([DateUtil.convertDate(date)])
      });
    }
  }

  //// ATTENDANCE REMOVE [Custom_Member]
  Future<void> attendanceRemoveCustom({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final attendancReference =
        spaceReference.collection('data').doc(date.year.toString());

    final docSnap = await attendancReference.get();

    if (docSnap.exists) {
      await docSnap.reference.update({
        'unattended_date': FieldValue.arrayUnion([DateUtil.convertDate(date)])
      });
    } else {
      await docSnap.reference.set({
        'unattended_date': FieldValue.arrayUnion([DateUtil.convertDate(date)])
      });
    }
  }

  /// Get Attendance of Custom Member
  Future<List<DateTime>> getAttendanceCustom({
    required String memberID,
    required String spaceID,
    DateTime? time,
  }) async {
    // the date
    DateTime date = DateTime.now();

    final attendancReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data')
        .doc(time == null ? date.year.toString() : time.year.toString());

    final docSnap = await attendancReference.get();

    /// Where the firebase firestore value will be stored
    List<Timestamp> unAttendedDate = [];

    /// Get the data
    if (docSnap.exists) {
      Map<String, dynamic>? theDates = docSnap.data();
      unAttendedDate = List.from(theDates!['unattended_date']);
    } else {}

    /// Return Type
    List<DateTime> unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in unAttendedDate) {
      unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return unattendedDateInDateTime;
  }

  /// Remove Multiple Attendance
  Future<void> multipleAttendanceDeleteCustom({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String thisYear = DateTime.now().year.toString();

    final spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final documentReference =
        spaceReference.collection('data').doc(thisYear);

    final attendanceDoc = await documentReference.get();

    if (attendanceDoc.exists) {
      attendanceDoc.reference
          .update({'unattended_date': FieldValue.arrayUnion(dateInTimeStamp)});
    } else {
      documentReference
          .set({'unattended_date': FieldValue.arrayUnion(dateInTimeStamp)});
    }
  }

  /// ADD Multiple Attendance
  Future<void> multipleAttendanceAddCustom({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String thisYear = DateTime.now().year.toString();

    final spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final documentReference =
        spaceReference.collection('data').doc(thisYear);

    final attendanceDoc = await documentReference.get();

    if (attendanceDoc.exists) {
      attendanceDoc.reference.update(
          {'unattended_date': FieldValue.arrayRemove(dateInTimeStamp)});
    } else {
      documentReference
          .set({'unattended_date': FieldValue.arrayRemove(dateInTimeStamp)});
    }
  }

  /* <-----------------------> 
      APP MEMBER FUNCTIONS    
   <-----------------------> */

  /// Attendance Give [App_Member]
  Future<void> addAttendanceAppMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final reference = spaceReference.collection('data');

    final attendenceDoc = await reference.doc(date.year.toString()).get();
    if (attendenceDoc.exists) {
      attendenceDoc.reference.update({
        'unattended_date': FieldValue.arrayRemove([DateUtil.convertDate(date)])
      });
    } else {
      reference.doc(date.year.toString()).set({
        'unattended_date': FieldValue.arrayRemove([DateUtil.convertDate(date)])
      });
    }
  }

  /// Attendance Remove [APP_MEMBER]
  Future<void> attendanceRemoveAppMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final reference = spaceReference.collection('data');

    final attendenceDoc = await reference.doc(date.year.toString()).get();
    if (attendenceDoc.exists) {
      attendenceDoc.reference.update({
        'unattended_date': FieldValue.arrayUnion([DateUtil.convertDate(date)])
      });
    } else {
      reference.doc(date.year.toString()).set({
        'unattended_date': FieldValue.arrayUnion([DateUtil.convertDate(date)])
      });
    }
  }

  /// Get Attendance [App_Member]
  Future<List<DateTime>> getAttendanceAppMember({
    required String memberID,
    required String spaceID,
    DateTime? userDate,
  }) async {
    final reference = _userCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data');

    final String thisYear = DateTime.now().year.toString();

    final attendenceDoc = await reference
        .doc(userDate == null ? thisYear : userDate.year.toString())
        .get();

    /// Where the firebase data will be stored
    List<Timestamp> unAttendedDate = [];

    if (attendenceDoc.exists) {
      Map<String, dynamic>? theDates = attendenceDoc.data();
      unAttendedDate = List.from(theDates!['unattended_date']);
    } else {}

    /// Return Type
    List<DateTime> unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in unAttendedDate) {
      unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return unattendedDateInDateTime;
  }

  /// Multiple Attendance Add [APP_MEMBER]
  Future<void> multipleAttendanceAddAppMember({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String thisYear = DateTime.now().year.toString();

    final spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final reference = spaceReference.collection('data');

    final attendenceDoc = await reference.doc(thisYear).get();
    if (attendenceDoc.exists) {
      attendenceDoc.reference.update(
          {'unattended_date': FieldValue.arrayRemove(dateInTimeStamp)});
    } else {
      reference.doc(thisYear).set(
        {'unattended_date': FieldValue.arrayRemove(dateInTimeStamp)},
      );
    }
  }

  /// Multiple Attendance Remove [APP_MEMBER]
  Future<void> multipleAttendanceDeleteAppMember({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String thisYear = DateTime.now().year.toString();

    final spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final reference = spaceReference.collection('data');

    final attendenceDoc = await reference.doc(thisYear).get();
    if (attendenceDoc.exists) {
      attendenceDoc.reference.update(
        {'unattended_date': FieldValue.arrayUnion(dateInTimeStamp)},
      );
    } else {
      reference.doc(thisYear).set(
        {'unattended_date': FieldValue.arrayUnion(dateInTimeStamp)},
      );
    }
  }

  /* <-----------------------> 
      4 : Other Functions    
   <-----------------------> */

  /// Get Attenance of A year
  Future<List<DateTime>> fetchThisYearAttendnce({
    required String memberID,
    required String spaceID,
    required int year,
    required bool isCustom,
  }) async {
    String thisYear = year.toString();
    List<DateTime> unatttendedDates = [];
    await _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data')
        .doc(thisYear)
        .get()
        .then(
      (value) {
        Map<String, dynamic>? allDateMonth = value.data();
        List<dynamic> unattendedDateInTimeStamp = [];
        if (allDateMonth != null && allDateMonth['unattended_date'] != null) {
          unattendedDateInTimeStamp = allDateMonth['unattended_date'];
          for (var element in unattendedDateInTimeStamp) {
            DateTime date = element.toDate();
            unatttendedDates.add(date);
          }
        }
      },
    );

    return unatttendedDates;
  }

  /// Is Member Present Today
  static bool isMemberAttendedTodayLocal(
      {required List<DateTime> unattendedDate}) {
    // We should format this accoroding to this one
    DateFormat dateFormat = DateFormat.yMMMMd();

    /// To compare if the date exist in the list
    List<String> allDateString = [];
    for (var element in unattendedDate) {
      String date = dateFormat.format(element);
      allDateString.add(date);
    }

    String todayDateInFormat = dateFormat.format(DateTime.now());

    bool isMemberAttended = false;

    if (allDateString.contains(todayDateInFormat)) {
      print('Member is unattended today');
      isMemberAttended = false;
    } else {
      print('Member is attended today');
      isMemberAttended = true;
    }

    return isMemberAttended;
  }

  /// If the member attended today
  Future<bool> isMemberAttendedToday({
    required String memberID,
    required String spaceID,
  }) async {
    bool isAttended = false;

    DateTime todayDate = DateTime.now();

    await _customMemberCollection.doc(memberID).get().then((memberDoc) async {
      final docSnap =
          await memberDoc.reference.collection('attendance').doc(spaceID).get();

      if (docSnap.exists) {
        docSnap.reference
            .collection('data')
            .doc(todayDate.year.toString())
            .get()
            .then((attendanceDoc) {
          Map<String, dynamic>? map = attendanceDoc.data();
          if (map != null) {
            List<Timestamp> unattendedList =
                List<Timestamp>.from(map['unattended_date']);

            bool doesContain = DateUtil.doesContainThisDateInTimeStamp(
              date: todayDate,
              allDates: unattendedList,
            );

            isAttended = !doesContain;
          }
        });
      } else {
        isAttended = false;
      }
    });

    return isAttended;
  }
}
