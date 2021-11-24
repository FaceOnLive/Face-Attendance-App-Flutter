import '../pages/06_members/member_add_qr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../pages/06_members/member_add.dart';
import '../themes/text.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({Key? key}) : super(key: key);

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
            'Add User',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                        Get.to(() => const MemberAddQrScreen());
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.qr_code_scanner_rounded,
                            size: Get.width * 0.2,
                          ),
                          const Text('QR Code'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        Get.to(() => const MemberAddScreen());
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            size: Get.width * 0.2,
                          ),
                          const Text('Custom')
                        ],
                      ),
                    ),
                  ],
                ),
                AppSizes.hGap20,
                Text(
                  'Please select a source',
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
