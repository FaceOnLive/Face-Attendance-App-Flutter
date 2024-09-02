import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_attendance/core/utils/app_toast.dart';
import 'package:face_attendance/core/utils/date_util.dart';

class AppMemberAttendanceRepository {
  final CollectionReference collectionReference;

  AppMemberAttendanceRepository(this.collectionReference);

  /// Get Attendance [App_Member]
  Future<List<DateTime>> getAttendanceAppMember({
    required String memberID,
    required String spaceID,
    DateTime? userDate,
  }) async {
    final reference = collectionReference
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
    } else {
      await attendenceDoc.reference.set({
        'unattended_date': [],
      });
    }

    /// Return Type
    List<DateTime> unattendedDateInDateTime = [];

    /// Convert the data
    for (Timestamp dateInTimeStamp in unAttendedDate) {
      unattendedDateInDateTime.add(dateInTimeStamp.toDate());
    }

    return unattendedDateInDateTime;
  }

  /// Attendance Give [App_Member]
  Future<void> addAttendanceAppMember({
    required String memberID,
    required String spaceID,
    required DateTime date,
  }) async {
    final reference = collectionReference
        .doc(memberID)
        .collection('attendance')
        .doc(spaceID)
        .collection('data');

    Timestamp theDate = DateUtil.convertDate(date);

    print("The date is $theDate");

    try {
      final attendenceDoc = await reference.doc(date.year.toString()).get();
      if (attendenceDoc.exists) {
        await attendenceDoc.reference.update({
          'unattended_date': FieldValue.arrayRemove([theDate])
        });
      } else {
        await reference.doc(date.year.toString()).set({
          'unattended_date': [],
        });
      }
    } on FirebaseException catch (e) {
      AppToast.show(e.code);
    }
  }
}
