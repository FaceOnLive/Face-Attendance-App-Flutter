import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/constants.dart';
import '../../../themes/text.dart';
import '../../../widgets/app_button.dart';

class LimitReachedDialog extends StatelessWidget {
  const LimitReachedDialog({Key? key}) : super(key: key);

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
            'Max User Limit Reached',
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
                  'Currently we are supporting limited members per account. If you want to register more users please contact us at contact@faceonlive.com',
                  textAlign: TextAlign.center,
                ),
                AppButton(
                    label: 'Or click here',
                    onTap: () async {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: 'contact@faceonlive.com',
                      );
                      String url = params.toString();
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        print('Could not launch $url');
                      }
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
