import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../core/constants/constants.dart';
import '../../../core/themes/text.dart';
import '../../../core/widgets/app_button.dart';
import '../views/join_qr_code_page.dart';

class NoSpaceFoundSection extends StatelessWidget {
  const NoSpaceFoundSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AppImages.illustrationSpaceEmpty,
          width: Get.width * 0.5,
        ),
        Padding(
          padding: const EdgeInsets.all(AppDefaults.padding),
          child: Column(
            children: [
              Text(
                'No Space found please join one',
                textAlign: TextAlign.center,
                style: AppText.caption,
              ),
              AppSizes.hGap15,
              AppButton(
                label: 'Join New Space +',
                onTap: () => Get.to(() => const AppMemberJoinQRCODEPage()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
