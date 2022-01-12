import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../06_spaces/views/pages/space_create_page.dart';

class NoSpaceFound extends StatelessWidget {
  const NoSpaceFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: Get.width * 0.5,
              child: Image.asset(AppImages.illustrationSpaceEmpty),
            ),
            AppSizes.hGap20,
            const Text('No space found..'),
            AppButton(
              width: Get.width * 0.5,
              prefixIcon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: 'Create Space',
              onTap: () {
                Get.to(() => const SpaceCreatePage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
