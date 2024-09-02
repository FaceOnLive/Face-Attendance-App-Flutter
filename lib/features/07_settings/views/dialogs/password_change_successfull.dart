import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';

class SuccessfullDialog extends StatelessWidget {
  const SuccessfullDialog({super.key, this.message});

  final String? message;

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
                  AppImages.illustrationSuccessFull,
                ),
                AppSizes.hGap20,
                Text(
                  message ?? 'The task has been finished successfully',
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
