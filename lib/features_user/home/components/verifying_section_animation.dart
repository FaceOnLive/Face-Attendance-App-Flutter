import 'package:face_attendance/core/constants/constants.dart';
import 'package:face_attendance/core/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerifyAnimation extends StatelessWidget {
  const VerifyAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/face_id.json',
          frameRate: FrameRate.max,
          width: Get.width * 0.5,
          repeat: true,
        ),
        AppSizes.hGap10,
        Text(
          'Checking...',
          style: AppText.caption,
        )
      ],
    );
  }
}
