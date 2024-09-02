import 'package:flutter/material.dart';

import '../constants/constants.dart';

class BottomSheetTopDivider extends StatelessWidget {
  const BottomSheetTopDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.only(bottom: 8.0),
      height: 3,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: AppDefaults.borderRadius,
      ),
    );
  }
}
