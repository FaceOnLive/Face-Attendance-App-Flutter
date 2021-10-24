import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../themes/text.dart';
import '../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

class GenerateQRDialog extends StatelessWidget {
  const GenerateQRDialog({
    Key? key,
    required this.data,
    this.title,
  }) : super(key: key);

  final String data;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
      ),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: Container(
        padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Share QR Code',
              style: AppText.h6.copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(
              color: AppColors.PLACEHOLDER_COLOR,
              thickness: 0.3,
            ),
            QrImage(
              padding: EdgeInsets.all(5),
              data: data,
              version: QrVersions.auto,
              size: Get.height * 0.3,
              foregroundColor: AppColors.PRIMARY_COLOR,
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
