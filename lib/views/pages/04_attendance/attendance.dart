import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_attendance/views/pages/04_attendance/user_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            /* <---- Header ----> */
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: Get.height * 0.1,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: AppDefaults.defaultBoxShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /* <---- Left Side ----> */
                  Row(
                    children: [
                      Hero(
                        tag: AppImages.MAIN_LOGO,
                        child: Image.asset(
                          AppImages.MAIN_LOGO_2,
                          width: Get.width * 0.13,
                        ),
                      ),
                      AppSizes.wGap5,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Turing Tech',
                            style: AppText.b2.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Face Attendance App',
                            style: AppText.caption,
                          )
                        ],
                      ),
                    ],
                  ),
                  /* <---- Right Side ----> */
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      AppImages.unsplashPersons[0],
                    ),
                    radius: Get.width * 0.07,
                  ),
                ],
              ),
            ),
            /* <---- DropDown and Date----> */
            _DropDownRow(),

            /* <---- User List ----> */
            AttendedUserList()
          ],
        ),
      ),
    );
  }
}

class _DropDownRow extends StatelessWidget {
  const _DropDownRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.PRIMARY_COLOR,
                ),
                borderRadius: AppDefaults.defaulBorderRadius,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: SizedBox(),
                dropdownColor: Colors.white,
                items: [
                  DropdownMenuItem(
                    child: _DropDownSpaceItem(
                      active: true,
                      iconData: Icons.business,
                      label: 'Office',
                    ),
                    value: 'office',
                  ),
                  DropdownMenuItem(
                    child: _DropDownSpaceItem(
                      active: true,
                      iconData: Icons.home,
                      label: 'Home',
                    ),
                    value: 'home',
                  ),
                  DropdownMenuItem(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create New Space',
                            style: AppText.b1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          AppSizes.wGap10,
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                    value: 'create',
                  ),
                ],
                value: 'office',
                onChanged: (value) {},
              ),
            ),
          ),
          AppSizes.wGap10,
          Column(
            children: [
              Text(
                DateFormat.EEEE().format(DateTime.now()),
                style: AppText.caption,
              ),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: AppText.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DropDownSpaceItem extends StatelessWidget {
  const _DropDownSpaceItem({
    Key? key,
    required this.label,
    required this.active,
    required this.iconData,
  }) : super(key: key);

  final String label;
  final bool active;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(iconData),
            AppSizes.wGap10,
            Text(
              label,
              style: AppText.b1.copyWith(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        ),
        Icon(
          Icons.info_outline_rounded,
          color: AppColors.PRIMARY_COLOR,
        ),
      ],
    );
  }
}
