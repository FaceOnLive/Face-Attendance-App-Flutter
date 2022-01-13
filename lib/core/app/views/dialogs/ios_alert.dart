import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../themes/text.dart';

class IosAlertDialog extends StatelessWidget {
  const IosAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSizes.hGap10,
          Text(
            'Info',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const Divider(
            color: AppColors.placeholderColor,
            thickness: 0.3,
          ),
          Container(
            padding: const EdgeInsets.all(
              AppDefaults.padding,
            ),
            child: Column(
              children: [
                Image.asset(
                  AppImages.illustrationWorkingOn,
                ),
                AppSizes.hGap20,
                const Text(
                  'Currently the app functionality is limited for iOS. We are working hard to bring full support.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
