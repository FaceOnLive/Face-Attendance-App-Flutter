import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';

class DeleteAttendDialog extends StatelessWidget {
  const DeleteAttendDialog({
    Key? key,
  }) : super(key: key);

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
            'Delete Unattendance',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back(result: false);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.close,
                            size: Get.width * 0.2,
                            color: AppColors.appGreen,
                          ),
                          const Text('No'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back(result: true);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.check,
                            size: Get.width * 0.2,
                            color: AppColors.appRed,
                          ),
                          const Text('Yes')
                        ],
                      ),
                    ),
                  ],
                ),
                AppSizes.hGap20,
                Text(
                  'Mark as attended the selected day?',
                  textAlign: TextAlign.center,
                  style: AppText.caption,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
