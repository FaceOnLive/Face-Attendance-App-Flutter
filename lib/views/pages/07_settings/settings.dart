import 'package:face_attendance/views/widgets/app_button.dart';
import 'package:face_attendance/views/widgets/picture_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_defaults.dart';
import 'package:face_attendance/constants/app_images.dart';
import 'package:face_attendance/constants/app_sizes.dart';
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
            /* <---- All Setting ----> */
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ADMIN PROFILE PICTURE
                    PictureWidget(
                      heroTag: AppImages.unsplashPersons[0],
                      profileLink: AppImages.unsplashPersons[0],
                      onTap: () {},
                    ),
                    AppCustomListTile(
                      label: 'Admin Details',
                      onTap: () {},
                      leading: Icon(Icons.person),
                    ),
                    AppCustomListTile(
                      label: 'Update Face Data',
                      onTap: () {},
                      leading: Icon(Icons.face_rounded),
                    ),
                    AppCustomListTile(
                      label: 'Change Password',
                      onTap: () {},
                      leading: Icon(Icons.lock),
                    ),

                    AppCustomListTile(
                      label: 'Notfications',
                      onTap: () {},
                      leading: Icon(Icons.notifications_rounded),
                      trailing: CupertinoSwitch(
                        onChanged: (val) {},
                        value: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /* <---- Bottom Logout Button ----> */
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(3, 4),
                    color: Colors.black12,
                    spreadRadius: 4,
                    blurRadius: 20,
                  )
                ],
              ),
              child: AppButton(
                label: 'Logout',
                onTap: () {},
                width: Get.width * 0.5,
                color: AppColors.APP_RED,
                suffixIcon: Icon(
                  Icons.logout_rounded,
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

class AppCustomListTile extends StatelessWidget {
  const AppCustomListTile({
    Key? key,
    required this.onTap,
    this.label,
    this.leading,
    this.trailing,
  }) : super(key: key);

  final void Function() onTap;
  final String? label;
  final Icon? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: InkWell(
        borderRadius: AppDefaults.defaulBorderRadius,
        splashColor: AppColors.shimmerHighlightColor,
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: AppSizes.DEFAULT_MARGIN,
              vertical: AppSizes.DEFAULT_MARGIN / 2),
          decoration: BoxDecoration(
            boxShadow: AppDefaults.defaultBoxShadow,
            color: Colors.white,
            borderRadius: AppDefaults.defaulBorderRadius,
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(AppSizes.DEFAULT_PADDING / 2),
            enabled: true,
            leading: leading ?? Icon(Icons.person_rounded),
            title: Text(
              label ?? 'Add Text Here',
              style: AppText.b1,
            ),
            trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded),
          ),
        ),
      ),
    );
  }
}
