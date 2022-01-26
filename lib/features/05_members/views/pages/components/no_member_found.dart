import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/constants.dart';

class NoMemberFoundSection extends StatelessWidget {
  const NoMemberFoundSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.7,
            child: Image.asset(
              AppImages.illustrationMemberEmpty,
            ),
          ),
          AppSizes.hGap20,
          const Text('No Member Found'),
        ],
      ),
    );
  }
}
