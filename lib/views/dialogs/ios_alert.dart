import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';

class IosAlertDialog extends StatelessWidget {
  const IosAlertDialog({Key? key}) : super(key: key);

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
              'Info',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR,
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
                  Image.asset(
                    AppImages.ILLUSTRATION_WORKING_ON,
                  ),
                  AppSizes.hGap20,
                  Text(
                    'Currently the app functionality is limited for iOS. We are working hard to bring full support.',
                    textAlign: TextAlign.center,
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
