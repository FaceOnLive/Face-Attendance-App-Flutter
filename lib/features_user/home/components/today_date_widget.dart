import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/themes/text.dart';

class TodayDateRowWidget extends StatelessWidget {
  const TodayDateRowWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.EEEE().format(DateTime.now()),
            style: AppText.caption,
          ),
          const Text(' | '),
          Text(
            DateFormat.yMMMMd().format(DateTime.now()),
            style: AppText.caption,
          ),
        ],
      ),
    );
  }
}
