import 'package:flutter/widgets.dart';

class AttendanceIsClearWidget extends StatelessWidget {
  const AttendanceIsClearWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Text('Attendance is clear'),
      ),
    );
  }
}
