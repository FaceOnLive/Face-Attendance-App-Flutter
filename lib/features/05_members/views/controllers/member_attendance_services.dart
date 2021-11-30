import 'package:cloud_firestore/cloud_firestore.dart';

class MemberAttendanceServices {
  String adminID;
  MemberAttendanceServices({
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
}
