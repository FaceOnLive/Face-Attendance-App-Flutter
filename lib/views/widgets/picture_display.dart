import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PictureWidget extends StatelessWidget {
  const PictureWidget({
    Key? key,
    this.profileLink,
    this.heroTag,
    this.onTap,
    this.disableTap = false,
    this.isLocal = false,
    this.localImage,
  }) : super(key: key);

  final String? profileLink;
  final String? heroTag;
  final void Function()? onTap;
  final bool disableTap;
  final bool isLocal;
  final File? localImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disableTap ? null : onTap,
      child: Container(
        child: Stack(
          children: [
            Hero(
              tag: heroTag ?? 'no',
              child: Container(
                padding: EdgeInsets.all(profileLink == null ? 5 : 0),
                decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.PRIMARY_COLOR,
                    width: 5,
                  ),
                ),
                child: isLocal
                    ? CircleAvatar(
                        backgroundImage: FileImage(localImage!),
                        radius: Get.width * 0.2,
                      )
                    : profileLink == null
                        ? CircleAvatar(
                            backgroundImage: AssetImage(
                              AppImages.DEFAULT_USER,
                            ),
                            radius: Get.width * 0.2,
                          )
                        : CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              profileLink!,
                            ),
                            radius: Get.width * 0.2,
                          ),
              ),
            ),
            if (!disableTap)
              Positioned(
                bottom: 0,
                right: 5,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
