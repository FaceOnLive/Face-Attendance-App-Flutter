import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/constants.dart';
import '../../../themes/text.dart';

class ErrorDialog extends StatelessWidget {
  final String message, title;
  const ErrorDialog({Key? key, required this.title, required this.message})
      : super(key: key);

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
            title,
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.appRed,
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
                Icon(
                  Icons.close,
                  color: AppColors.appRed,
                  size: Get.width * 0.2,
                ),
                AppSizes.hGap20,
                Text(
                  message,
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
