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
              AppSizes.defaultPadding,
            ),
            child: Column(
              children: [
                Image.asset(
                  AppImages.illustrationEmailSent,
                ),
                AppSizes.hGap20,
                const Text(
                  'A email has been sent to you verify. Please verify the email by clicking the link.',
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
