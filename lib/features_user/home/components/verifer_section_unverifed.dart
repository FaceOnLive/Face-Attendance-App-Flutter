import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../core/themes/text.dart';
import '../../../core/widgets/app_button.dart';
import '../../core/controllers/app_member_verify.dart';

class UnverifiedSection extends StatelessWidget {
  const UnverifiedSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppImages.illustrationFaceID,
          width: Get.width * 0.5,
        ),
        AppSizes.hGap15,
        AppSizes.hGap15,
        AppButton(
          label: 'Verify, it\'s you',
          width: Get.width * 0.5,
          fontSize: AppText.h6.fontSize,
          onTap: Get.find<AppMemberVerifyController>().verifyUser,
        ),
        AppSizes.hGap15,
        Text(
          'Once you are in your space location \n press the verify button',
          textAlign: TextAlign.center,
          style: AppText.caption,
        ),
      ],
    );
  }
}
