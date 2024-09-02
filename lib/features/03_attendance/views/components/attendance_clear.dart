import 'package:flutter/widgets.dart';

class AttendanceIsClearWidget extends StatelessWidget {
  const AttendanceIsClearWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Text('Attendance is clear'),
      ),
    );
  }
}
