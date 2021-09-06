import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/views/themes/text.dart';

class AdminSettingScreen extends StatelessWidget {
  const AdminSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Setting',
          style: AppText.bBOLD,
        ),
      ),
      body: Container(
        width: Get.width,
        child: Column(
          children: [
            // ADMIN PROFILE PICTURE
            ProfilePictureWidget(
              heroTag: AppImages.unsplashPersons[0],
              profileLink: AppImages.unsplashPersons[0],
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    Key? key,
    required this.profileLink,
    required this.heroTag,
    required this.onTap,
  }) : super(key: key);

  final String profileLink;
  final String heroTag;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: heroTag,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.PRIMARY_COLOR,
                  width: 5,
                ),
              ),
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  AppImages.unsplashPersons[0],
                ),
                radius: Get.width * 0.2,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 5,
            child: InkWell(
              onTap: () {},
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
          ),
        ],
      ),
    );
  }
}
