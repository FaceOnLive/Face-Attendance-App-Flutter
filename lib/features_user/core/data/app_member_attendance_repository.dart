import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/core/utils/app_toast.dart';

class AppMemberAttendanceRepository {
  final CollectionReference collectionReference;

  AppMemberAttendanceRepository(this.collectionReference);

  /// Get Attendance [App_Member]
  Future<List<DateTime>> getAttendanceAppMember({
    required String memberID,
    required String spaceID,
    DateTime? userDate,
  }) async {
    final _reference = collectionReference
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
    } else {
      await _attendenceDoc.reference.set({
        'unattended_date': [],
      });
    }

    /// Return Type
    List<DateTime> _unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in _unAttendedDate) {
      _unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return _unattendedDateInDateTime;
  }

  /// Attendance Give [App_Member]
  Future<void> addAttendanceAppMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final _reference = collectionReference
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data');

    Timestamp theDate = Timestamp.fromDate(
        DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0));

    print("The date is $theDate");

    try {
      final _attendenceDoc = await _reference.doc(date.year.toString()).get();
      if (_attendenceDoc.exists) {
        await _attendenceDoc.reference.update({
          'unattended_date': FieldValue.arrayRemove([theDate])
        });
      } else {
        await _reference.doc(date.year.toString()).set({
          'unattended_date': [],
        });
      }
    } on FirebaseException catch (e) {
      AppToast.showDefaultToast(e.code);
    }
  }
}
