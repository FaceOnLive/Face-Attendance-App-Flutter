import 'package:face_attendance/constants/constants.dart';
import 'package:face_attendance/controllers/verifier/app_member_verify.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:face_attendance/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AppMemberVerifierWidget extends GetView<AppMemberVerifyController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /* <---- Status -----> */
        GetBuilder<AppMemberVerifyController>(
          initState: (_) {},
          builder: (_) {
            if (controller.isAttendedToday) {
              return Image.asset(
                AppImages.ILLUSTRATION_ATTEND_FOUND,
                width: Get.width * 0.8,
              );
            } else if (controller.isVerifyingMember) {
              return _VerifyingAnimation();
            } else {
              return Image.asset(
                AppImages.ILLUSTRATION_FACE_ID,
                width: Get.width * 0.5,
              );
            }
          },
        ),

        /// Verify Button
        GetBuilder<AppMemberVerifyController>(
          initState: (_) {},
          builder: (_) {
            if (controller.isAttendedToday) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You attended today in {Space}'),
                  Icon(
                    Icons.check_box_rounded,
                    color: AppColors.APP_GREEN,
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  AppButton(
                    label: 'Verify, it\'s you',
                    width: Get.width * 0.5,
                    fontSize: AppText.h6.fontSize,
                    onTap: controller.verifyUser,
                  ),
                  Text(
                    'Once you are in your space location \n press the verify button',
                    textAlign: TextAlign.center,
                    style: AppText.caption,
                  )
                ],
              );
            }
          },
        ),
      ],
    );
  }
}

class _VerifyingAnimation extends StatelessWidget {
  const _VerifyingAnimation({
    Key? key,
  }) : super(key: key);

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
