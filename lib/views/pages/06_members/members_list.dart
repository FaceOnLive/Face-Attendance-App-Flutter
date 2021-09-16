import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/members/member_controller.dart';
import '../../../models/member.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import 'member_info.dart';
import '../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MembersList extends StatelessWidget {
  const MembersList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder<MembersController>(
          builder: (controller) => controller.isFetchingUser
              ? _LoadingData()
              : controller.allMember.length > 0
                  ? ListView.builder(
                      itemCount: controller.allMember.length,
                      itemBuilder: (context, index) {
                        return _MemberListTile(
                          member: controller.allMember[index],
                        );
                      },
                    )
                  : _NoMemberFound(),
        ),
      ),
    );
  }
}

class _NoMemberFound extends StatelessWidget {
  const _NoMemberFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Get.width * 0.7,
            child: Image.asset(
              AppImages.ILLUSTRATION_MEMBER_EMPTY,
            ),
          ),
          AppSizes.hGap20,
          Text('No Member Found'),
        ],
      ),
    );
  }
}

class _MemberListTile extends StatelessWidget {
  const _MemberListTile({
    Key? key,
    required this.member,
  }) : super(key: key);

  final Member member;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => MemberInfoScreen(
              member: member,
            ));
      },
      leading: Hero(
        tag: member.memberID ?? member.memberPicture,
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            member.memberPicture,
          ),
        ),
      ),
      title: Text(member.memberName),
      subtitle: Text(member.memberNumber.toString()),
      trailing: Icon(
        Icons.info_outlined,
        color: AppColors.APP_GREEN,
      ),
    );
  }
}

// To Add A Loading List Effect
class _LoadingData extends StatelessWidget {
  const _LoadingData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: ListTile(
            leading: CircleAvatar(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDefaults.defaulBorderRadius,
                  ),
                  child: Text(
                    'Hello Testge g',
                    style: AppText.b1,
                  ),
                ),
                AppSizes.hGap5,
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDefaults.defaulBorderRadius,
                  ),
                  child: Text('+852 XXXX XXXXgegege g'),
                ),
              ],
            ),
            trailing: Container(
              child: Icon(Icons.info_rounded),
            ),
          ),
        );
      },
    );
  }
}
