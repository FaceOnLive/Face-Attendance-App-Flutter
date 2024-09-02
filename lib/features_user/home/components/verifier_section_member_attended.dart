import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../core/constants/constants.dart';

class MemberAttendedSection extends StatelessWidget {
  const MemberAttendedSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppImages.illustrationAttendFound,
          width: Get.width * 0.8,
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You attended today in {Space}'),
            Icon(
              Icons.check_box_rounded,
              color: AppColors.appGreen,
            ),
          ],
        ),
      ],
    );
  }
}
