import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/core/data/helpers/date_helper.dart';
import 'package:intl/intl.dart';

class MemberAttendanceRepository {
  String adminID;
  MemberAttendanceRepository({
    required this.adminID,
  });

  /// All Members Collection
  late final CollectionReference _collectionReference = FirebaseFirestore
      .instance
      .collection('members')
      .doc(adminID)
      .collection('members_collection');

  //// ATTENDANCE GIVE
  Future<void> addAttendance({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    await _collectionReference.doc(memberID).get().then((memberDoc) async {
      final docSnap =
          await memberDoc.reference.collection('attendance').doc(spaceID).get();

      if (docSnap.exists) {
        docSnap.reference
            .collection('data')
            .doc(date.year.toString())
            .get()
            .then((attendanceDoc) {
          attendanceDoc.reference.update({
            'unattended_date':
                FieldValue.arrayRemove([Timestamp.fromDate(date)])
          });
        });
      } else {
        memberDoc.reference
            .collection('attendance')
            .doc(spaceID)
            .get()
            .then((value) {
          value.reference.collection('data').doc(date.year.toString()).set({
            'unattended_date':
                FieldValue.arrayRemove([Timestamp.fromDate(date)])
          });
        });
      }
    });
  }

  //// ATTENDANCE REMOVE
  Future<void> attendanceRemove({
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
          //IF there is already a attendance doc
          if (value.data() != null) {
            value.reference.update({
              'unattended_date':
                  FieldValue.arrayUnion([Timestamp.fromDate(date)])
            });
          } else {
            value.reference.set({
              'unattended_date':
                  FieldValue.arrayUnion([Timestamp.fromDate(date)])
            });
          }
        });
      });
    });
  }

  /// Remove Multiple Attendance
  Future<void> multipleAttendanceDelete({
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
  Future<void> multipleAttendanceAdd({
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

  /// Get Attenance of A year
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
        for (var element in _unattendedDateInTimeStamp) {
          DateTime _date = element.toDate();
          _unatttendedDate.add(_date);
        }
      }
    });

    return _unatttendedDate;
  }

  /// Is Member Present Today
  bool isMemberAttendedTodayLocal({required List<DateTime> unattendedDate}) {
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

    await _collectionReference.doc(memberID).get().then((memberDoc) async {
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

            bool _doesContain = DateHelper.doesContainThisDateInTimeStamp(
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
