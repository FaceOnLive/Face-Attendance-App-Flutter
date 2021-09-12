import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_images.dart';
import '../../constants/app_sizes.dart';
import '../themes/text.dart';
import 'package:flutter/material.dart';

class EmailSentSuccessfullDialog extends StatelessWidget {
  const EmailSentSuccessfullDialog({Key? key}) : super(key: key);

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
              'Successfull',
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
                    AppImages.ILLUSTRATION_EMAIL_SENT,
                  ),
                  AppSizes.hGap20,
                  Text(
                    'A email has been sent to you verify. Please verify the email by clicking the link.',
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
