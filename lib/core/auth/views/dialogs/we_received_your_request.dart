import 'package:flutter/material.dart';

import '../../../constants/constants.dart';
import '../../../themes/text.dart';

class RequestReceivedDialog extends StatelessWidget {
  const RequestReceivedDialog({Key? key}) : super(key: key);

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
            'Successfull',
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
                  AppImages.illustrationEmailSent,
                ),
                AppSizes.hGap20,
                const Text(
                  'We receieved your request, we will contact you soon on the provided email and a notification on this app. Thank you',
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
