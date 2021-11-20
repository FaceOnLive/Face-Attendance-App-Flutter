import '../../../constants/app_defaults.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../models/member.dart';
import '../../themes/text.dart';
import '../../widgets/picture_display.dart';
import 'member_edit.dart';

class MemberInfoScreen extends StatelessWidget {
  const MemberInfoScreen({
    Key? key,
    required this.member,
  }) : super(key: key);

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultPadding),
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDefaults.defaulBorderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            leading: const SizedBox(),
            // title: Text('Info'),
            actions: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
          /* <---- User Info ----> */
          ProfilePictureWidget(
            disableTap: true,
            profileLink: member.memberPicture,
            heroTag: member.memberID,
          ),
          Column(
            children: [
              AppSizes.hGap10,
              Text(
                member.memberName,
                style: AppText.h5.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
              Text(member.memberNumber.toString()),
              Text(member.memberFullAdress),
            ],
          ),
          const Chip(
            label: Text('Member is Custom'),
          ),
          AppButtonOutline(
            label: 'Edit Member',
            onTap: () {
              Get.back();
              Get.to(() => MemberEditScreen(member: member));
            },
          ),
          AppSizes.hGap20,
        ],
      ),
    );
  }
}
