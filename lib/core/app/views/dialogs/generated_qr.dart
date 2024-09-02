import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../constants/constants.dart';
import '../../../themes/text.dart';
import '../../../widgets/app_button.dart';

class GenerateQRDialog extends StatelessWidget {
  const GenerateQRDialog({
    super.key,
    required this.data,
    this.title,
  });

  final String data;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.borderRadius,
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Container(
        padding: const EdgeInsets.all(AppDefaults.padding / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Share QR Code',
              style: AppText.h6.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: AppColors.placeholderColor,
              thickness: 0.3,
            ),
            QrImageView(
              padding: const EdgeInsets.all(5),
              data: data,
              version: QrVersions.auto,
              size: Get.height * 0.3,
              eyeStyle: const QrEyeStyle(color: AppColors.primaryColor),
            ),
            AppSizes.hGap10,
            AppButton(
              width: Get.width * 0.6,
              label: 'Close',
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
