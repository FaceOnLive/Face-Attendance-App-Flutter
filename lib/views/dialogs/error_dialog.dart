import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../themes/text.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  const ErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSizes.hGap10,
          Text(
            'Error',
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
              AppSizes.defaultPadding,
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
