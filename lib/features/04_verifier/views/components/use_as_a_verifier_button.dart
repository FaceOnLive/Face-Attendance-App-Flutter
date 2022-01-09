import 'package:face_attendance/core/constants/constants.dart';
import 'package:face_attendance/core/themes/text.dart';
import 'package:face_attendance/features/04_verifier/views/dialogs/static_verifier_sheet_lock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UseAsAVerifierButton extends StatelessWidget {
  const UseAsAVerifierButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.bottomSheet(
        //   StaticVerifierPasswordSet(),
        //   isScrollControlled: true,
        // );
        Get.bottomSheet(
            const StaticVerifierLockUnlock(
              isLockMode: true,
            ),
            isScrollControlled: true);
      },
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppSizes.defaultRadius),
            topRight: Radius.circular(AppSizes.defaultRadius),
          ),
          boxShadow: AppDefaults.defaultBoxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Use as a static verifier',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
