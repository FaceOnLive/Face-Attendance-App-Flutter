import 'package:intl/intl.dart';

class DateHelper {
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
    allDates.forEach((_date) {
      String _formattedDate = _dateFormat.format(_date);
      _allDateInString.add(_formattedDate);
    });

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
    allDates.forEach((_date) {
      String _formattedDate = _dateFormat.format(_date.toDate());
      _allDateInString.add(_formattedDate);
    });

    // Date
    String _dateInString = _dateFormat.format(date);

    if (_allDateInString.contains(_dateInString)) {
      _isPresent = true;
    } else {
      _isPresent = false;
    }
    return _isPresent;
  }
}
