import '../../../constants/app_colors.dart';
import 'member_add.dart';
import 'members_list.dart';
import '../../themes/text.dart';
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
              child: FloatingActionButton.extended(
                onPressed: () {
                  Get.to(() => MemberAddScreen());
                },
                icon: Icon(
                  Icons.person_add_rounded,
                ),
                label: Text('Add'),
                backgroundColor: AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
