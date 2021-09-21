import 'dart:io';

import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../../services/app_photo.dart';
import '../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraGallerySelectDialog extends StatelessWidget {
  const CameraGallerySelectDialog({Key? key}) : super(key: key);

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
              'Select',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          File? _image =
                              await AppPhotoService.getImageFromCamera();
                          Get.back(result: _image);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: Get.width * 0.2,
                            ),
                            Text('Camera'),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          File? _image =
                              await AppPhotoService.getImageFromGallery();
                          Get.back(result: _image);
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_library_rounded,
                              size: Get.width * 0.2,
                            ),
                            Text('Gallery')
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
      ),
    );
  }
}
