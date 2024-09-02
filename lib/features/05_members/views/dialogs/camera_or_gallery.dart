import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/data/services/app_photo.dart';
import '../../../../core/themes/text.dart';

class CameraGallerySelectDialog extends StatelessWidget {
  const CameraGallerySelectDialog({super.key});

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
            'Select',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {
                        File? image =
                            await AppPhotoService.getImageFromCamera();
                        Get.back(result: image);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: Get.width * 0.2,
                          ),
                          const Text('Camera'),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        File? image =
                            await AppPhotoService.getImageFromGallery();
                        Get.back(result: image);
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_rounded,
                            size: Get.width * 0.2,
                          ),
                          const Text('Gallery')
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
