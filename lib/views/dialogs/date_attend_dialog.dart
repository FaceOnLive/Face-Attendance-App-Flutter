import 'package:face_attendance/controllers/members/member_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../themes/text.dart';

class DeleteAttendDialog extends StatelessWidget {
  const DeleteAttendDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSizes.hGap10,
            Text(
              'Delete Unattendance',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.APP_RED,
              ),
            ),
            Divider(
              color: AppColors.PLACEHOLDER_COLOR,
              thickness: 0.3,
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.DEFAULT_PADDING,
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
                              color: AppColors.APP_GREEN,
                            ),
                            Text('No'),
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
                              color: AppColors.APP_RED,
                            ),
                            Text('Yes')
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
      ),
    );
  }
}
