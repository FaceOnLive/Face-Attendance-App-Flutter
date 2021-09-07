import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/views/pages/06_members/member_add.dart';
import 'package:face_attendance/views/pages/06_members/members_list.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembersScreen extends StatelessWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /* <---- Header ----> */
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Members',
                    style: AppText.h6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                ),
                MembersList(),
              ],
            ),
            /* <---- Member Add ----> */
            Positioned(
              bottom: 20,
              right: Get.width * 0.07,
              child: FloatingActionButton(
                onPressed: () {
                  Get.to(() => MemberAddScreen());
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
