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
    List<DateTime> _allUnattendedDates = [];
    if (isCustom) {
      _allUnattendedDates = await getAttendanceCustom(
        spaceID: spaceID,
        memberID: memberID,
      );
    } else {
      _allUnattendedDates = await getAttendanceAppMember(
        spaceID: spaceID,
        memberID: memberID,
      );
    }

    return _allUnattendedDates;
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
    final _spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _attendancReference =
        _spaceReference.collection('data').doc(date.year.toString());

    final docSnap = await _attendancReference.get();

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
    final _spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _attendancReference =
        _spaceReference.collection('data').doc(date.year.toString());

    final docSnap = await _attendancReference.get();

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

    final _attendancReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data')
        .doc(time == null ? date.year.toString() : time.year.toString());

    final docSnap = await _attendancReference.get();

    /// Where the firebase firestore value will be stored
    List<Timestamp> _unAttendedDate = [];

    /// Get the data
    if (docSnap.exists) {
      Map<String, dynamic>? _theDates = docSnap.data();
      _unAttendedDate = List.from(_theDates!['unattended_date']);
    } else {}

    /// Return Type
    List<DateTime> _unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in _unAttendedDate) {
      _unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return _unattendedDateInDateTime;
  }

  /// Remove Multiple Attendance
  Future<void> multipleAttendanceDeleteCustom({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> _dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      _dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String _thisYear = DateTime.now().year.toString();

    final _spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _documentReference =
        _spaceReference.collection('data').doc(_thisYear);

    final attendanceDoc = await _documentReference.get();

    if (attendanceDoc.exists) {
      attendanceDoc.reference
          .update({'unattended_date': FieldValue.arrayUnion(_dateInTimeStamp)});
    } else {
      _documentReference
          .set({'unattended_date': FieldValue.arrayUnion(_dateInTimeStamp)});
    }
  }

  /// ADD Multiple Attendance
  Future<void> multipleAttendanceAddCustom({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> _dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      _dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String _thisYear = DateTime.now().year.toString();

    final _spaceReference = _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _documentReference =
        _spaceReference.collection('data').doc(_thisYear);

    final attendanceDoc = await _documentReference.get();

    if (attendanceDoc.exists) {
      attendanceDoc.reference.update(
          {'unattended_date': FieldValue.arrayRemove(_dateInTimeStamp)});
    } else {
      _documentReference
          .set({'unattended_date': FieldValue.arrayRemove(_dateInTimeStamp)});
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
    final _spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _reference = _spaceReference.collection('data');

    final _attendenceDoc = await _reference.doc(date.year.toString()).get();
    if (_attendenceDoc.exists) {
      _attendenceDoc.reference.update({
        'unattended_date': FieldValue.arrayRemove([DateUtil.convertDate(date)])
      });
    } else {
      _reference.doc(date.year.toString()).set({
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
    final _spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _reference = _spaceReference.collection('data');

    final _attendenceDoc = await _reference.doc(date.year.toString()).get();
    if (_attendenceDoc.exists) {
      _attendenceDoc.reference.update({
        'unattended_date': FieldValue.arrayUnion([DateUtil.convertDate(date)])
      });
    } else {
      _reference.doc(date.year.toString()).set({
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
    final _reference = _userCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data');

    final String _thisYear = DateTime.now().year.toString();

    final _attendenceDoc = await _reference
        .doc(userDate == null ? _thisYear : userDate.year.toString())
        .get();

    /// Where the firebase data will be stored
    List<Timestamp> _unAttendedDate = [];

    if (_attendenceDoc.exists) {
      Map<String, dynamic>? _theDates = _attendenceDoc.data();
      _unAttendedDate = List.from(_theDates!['unattended_date']);
    } else {}

    /// Return Type
    List<DateTime> _unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in _unAttendedDate) {
      _unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return _unattendedDateInDateTime;
  }

  /// Multiple Attendance Add [APP_MEMBER]
  Future<void> multipleAttendanceAddAppMember({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> _dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      _dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String _thisYear = DateTime.now().year.toString();

    final _spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _reference = _spaceReference.collection('data');

    final _attendenceDoc = await _reference.doc(_thisYear).get();
    if (_attendenceDoc.exists) {
      _attendenceDoc.reference.update(
          {'unattended_date': FieldValue.arrayRemove(_dateInTimeStamp)});
    } else {
      _reference.doc(_thisYear).set(
        {'unattended_date': FieldValue.arrayRemove(_dateInTimeStamp)},
      );
    }
  }

  /// Multiple Attendance Remove [APP_MEMBER]
  Future<void> multipleAttendanceDeleteAppMember({
    required String memberID,
    required String spaceID,
    required List<DateTime> dates,
  }) async {
    List<Timestamp> _dateInTimeStamp = [];

    await Future.forEach<DateTime>(dates, (element) {
      _dateInTimeStamp.add(DateUtil.convertDate(element));
    });

    final String _thisYear = DateTime.now().year.toString();

    final _spaceReference =
        _userCollection.doc(memberID).collection('attendance').doc(spaceID);

    await _spaceReference.set({'lastUpdated': FieldValue.serverTimestamp()});

    final _reference = _spaceReference.collection('data');

    final _attendenceDoc = await _reference.doc(_thisYear).get();
    if (_attendenceDoc.exists) {
      _attendenceDoc.reference.update(
        {'unattended_date': FieldValue.arrayUnion(_dateInTimeStamp)},
      );
    } else {
      _reference.doc(_thisYear).set(
        {'unattended_date': FieldValue.arrayUnion(_dateInTimeStamp)},
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
    List<DateTime> _unatttendedDates = [];
    await _customMemberCollection
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data')
        .doc(thisYear)
        .get()
        .then(
      (value) {
        Map<String, dynamic>? _allDateMonth = value.data();
        List<dynamic> _unattendedDateInTimeStamp = [];
        if (_allDateMonth != null && _allDateMonth['unattended_date'] != null) {
          _unattendedDateInTimeStamp = _allDateMonth['unattended_date'];
          for (var element in _unattendedDateInTimeStamp) {
            DateTime _date = element.toDate();
            _unatttendedDates.add(_date);
          }
        }
      },
    );

    return _unatttendedDates;
  }

  /// Is Member Present Today
  static bool isMemberAttendedTodayLocal(
      {required List<DateTime> unattendedDate}) {
    // We should format this accoroding to this one
    DateFormat _dateFormat = DateFormat.yMMMMd();

    /// To compare if the date exist in the list
    List<String> _allDateString = [];
    for (var element in unattendedDate) {
      String date = _dateFormat.format(element);
      _allDateString.add(date);
    }

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

  /// If the member attended today
  Future<bool> isMemberAttendedToday({
    required String memberID,
    required String spaceID,
  }) async {
    bool _isAttended = false;

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
            List<Timestamp> _unattendedList =
                List<Timestamp>.from(map['unattended_date']);

            bool _doesContain = DateUtil.doesContainThisDateInTimeStamp(
              date: todayDate,
              allDates: _unattendedList,
            );

            _isAttended = !_doesContain;
          }
        });
      } else {
        _isAttended = false;
      }
    });

    return _isAttended;
  }
}
