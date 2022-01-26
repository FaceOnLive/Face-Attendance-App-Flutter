import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/models/member.dart';
import '../../../../../core/widgets/member_image_leading.dart';
import '../member_info.dart';

class MemberListTile extends StatelessWidget {
  const MemberListTile({
    Key? key,
    required this.member,
  }) : super(key: key);

  final Member member;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.bottomSheet(
          MemberInfoScreen(member: member),
          isScrollControlled: true,
          useRootNavigator: true,
        );
      },
      leading: Hero(
        tag: member.memberID ?? member.memberNumber,
        child: MemberImageLeading(
          imageLink: member.memberPicture,
        ),
      ),
      title: Text(member.memberName),
      subtitle: Text(member.memberNumber.toString()),
      trailing: const Icon(
        Icons.info_outlined,
        color: AppColors.appGreen,
      ),
    );
  }
}
