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
    DateFormat _dateFormat = DateFormat.yMEd();
    bool _isSame = false;

    String _firstDateInString = _dateFormat.format(date1);
    String _secondDateInString = _dateFormat.format(date2);

    if (_firstDateInString == _secondDateInString) {
      _isSame = true;
    } else {
      _isSame = false;
    }

    return _isSame;
  }

  /// Compare List of Date Against one
  static bool doesContainThisDate({
    required DateTime date,
    required List<DateTime> allDates,
  }) {
    //Format to match
    DateFormat _dateFormat = DateFormat.yMEd();
    bool _isPresent = false;

    // For comparing
    List<String> _allDateInString = [];
    for (var _date in allDates) {
      String _formattedDate = _dateFormat.format(_date);
      _allDateInString.add(_formattedDate);
    }

    // Date
    String _dateInString = _dateFormat.format(date);

    if (_allDateInString.contains(_dateInString)) {
      _isPresent = true;
    } else {
      _isPresent = false;
    }
    return _isPresent;
  }

  /// Compare List of Date Against one
  static bool doesContainThisDateInTimeStamp({
    required DateTime date,
    required List<dynamic> allDates,
  }) {
    //Format to match
    DateFormat _dateFormat = DateFormat.yMEd();
    bool _isPresent = false;

    // For comparing
    List<String> _allDateInString = [];
    for (var _date in allDates) {
      String _formattedDate = _dateFormat.format(_date.toDate());
      _allDateInString.add(_formattedDate);
    }

    // Date
    String _dateInString = _dateFormat.format(date);

    if (_allDateInString.contains(_dateInString)) {
      _isPresent = true;
    } else {
      _isPresent = false;
    }
    return _isPresent;
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
