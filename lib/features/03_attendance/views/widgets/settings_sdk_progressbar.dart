import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../core/app/controllers/settings_controller.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';

class SettingSDKDatabase extends StatelessWidget {
  const SettingSDKDatabase({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller) {
      if (controller.isSettingSdk) {
        return Column(
          children: [
            AnimatedContainer(
              alignment: Alignment.center,
              width: double.infinity,
              duration: AppDefaults.defaultDuration,
              padding: const EdgeInsets.all(AppSizes.defaultPadding / 2),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
              ),
              child: Text(
                'Setting SDK database...',
                style: AppText.b1.copyWith(color: Colors.white),
              ),
            ),
            const LinearProgressIndicator(),
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
