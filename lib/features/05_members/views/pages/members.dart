import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/app/views/dialogs/limit_reached.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../controllers/member_controller.dart';
import '../dialogs/add_user.dart';
import 'members_list.dart';

class MembersScreen extends GetView<MembersController> {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /* <---- Header ----> */
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Members',
                    style: AppText.h6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const MembersList(),
              ],
            ),
            /* <---- Member Add ----> */
            Positioned(
              bottom: 20,
              right: Get.width * 0.07,
              child: FloatingActionButton.extended(
                onPressed: () {
                  controller.allMembers.length >= 10
                      ? Get.dialog(
                          const LimitReachedDialog(),
                        )
                      : Get.dialog(const AddUserDialog());
                },
                icon: const Icon(
                  Icons.person_add_rounded,
                ),
                label: const Text('Add'),
                backgroundColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
