import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// Used for quick helping in datetime class
class DateUtil {
  /// IF a date is same
  static bool compareDays({
    required DateTime date1,
    required DateTime date2,
  }) {
    /// This inlcudes all formating
    DateFormat dateFormat = DateFormat.yMEd();
    bool isSame = false;

    String firstDateInString = dateFormat.format(date1);
    String secondDateInString = dateFormat.format(date2);

    if (firstDateInString == secondDateInString) {
      isSame = true;
    } else {
      isSame = false;
    }

    return isSame;
  }

  /// Compare List of Date Against one
  static bool doesContainThisDate({
    required DateTime date,
    required List<DateTime> allDates,
  }) {
    //Format to match
    DateFormat dateFormat = DateFormat.yMEd();
    bool isPresent = false;

    // For comparing
    List<String> allDateInString = [];
    for (var date in allDates) {
      String formattedDate = dateFormat.format(date);
      allDateInString.add(formattedDate);
    }

    // Date
    String dateInString = dateFormat.format(date);

    if (allDateInString.contains(dateInString)) {
      isPresent = true;
    } else {
      isPresent = false;
    }
    return isPresent;
  }

  /// Compare List of Date Against one
  static bool doesContainThisDateInTimeStamp({
    required DateTime date,
    required List<dynamic> allDates,
  }) {
    //Format to match
    DateFormat dateFormat = DateFormat.yMEd();
    bool isPresent = false;

    // For comparing
    List<String> allDateInString = [];
    for (var date in allDates) {
      String formattedDate = dateFormat.format(date.toDate());
      allDateInString.add(formattedDate);
    }

    // Date
    String dateInString = dateFormat.format(date);

    if (allDateInString.contains(dateInString)) {
      isPresent = true;
    } else {
      isPresent = false;
    }
    return isPresent;
  }

  /// Match the date of server
  /// the server supports 00:00 in date or Timestamp format, so
  /// we need to convert the input and output it to this format
  static Timestamp convertDate(DateTime date) {
    return Timestamp.fromDate(
      DateTime(date.year, date.month, date.day, 0, 0, 0, 0, 0),
    );
  }
}
