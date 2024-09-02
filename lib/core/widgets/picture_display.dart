import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/constants.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    super.key,
    this.profileLink,
    this.heroTag,
    this.onTap,
    this.disableTap = false,
    this.isLocal = false,
    this.isUpdating = false,
    this.localImage,
  });

  final String? profileLink;
  final String? heroTag;
  final void Function()? onTap;
  final bool disableTap;
  final bool isLocal;
  final bool isUpdating;
  final File? localImage;
  final Uint8List? faceFeat = null;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disableTap ? null : onTap,
      child: isUpdating
          ? Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage(
                  AppImages.deafaultUser,
                ),
                radius: Get.width * 0.2,
              ),
            )
          : Stack(
              children: [
                Hero(
                  tag: heroTag ?? 'no',
                  child: Container(
                    padding: EdgeInsets.all(profileLink == null ? 5 : 0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    child: isLocal
                        ? CircleAvatar(
                            backgroundImage: FileImage(localImage!),
                            radius: Get.width * 0.2,
                          )
                        : profileLink == null
                            ? CircleAvatar(
                                backgroundImage: const AssetImage(
                                  AppImages.deafaultUser,
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
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_a_photo_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
