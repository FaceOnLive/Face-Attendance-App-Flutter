import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/member.dart';
import '../../../../core/themes/text.dart';
import '../pages/member_details_page.dart';

class MemberListTileSpace extends StatelessWidget {
  const MemberListTileSpace({
    Key? key,
    required this.member,
    required this.currentSpaceID,
    this.attendedTime,
    this.fetchingTodaysLog = true,
  }) : super(key: key);

  final Member member;
  final String currentSpaceID;
  final DateTime? attendedTime;
  final bool fetchingTodaysLog;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(
          () => MemberAttendanceDetails(
            member: member,
            spaceID: currentSpaceID,
          ),
        );
      },
      leading: Hero(
        tag: member.memberID ?? member.memberName,
        child: member.memberPicture == null
            ? const CircleAvatar(
                backgroundImage: AssetImage(AppImages.deafaultUser),
              )
            : CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  member.memberPicture!,
                ),
              ),
      ),
      title: Text(member.memberName),
      subtitle: Text(member.memberNumber.toString()),
      trailing: fetchingTodaysLog
          ? Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: const Icon(Icons.info_outline_rounded),
            )
          : attendedTime != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.jm().format(attendedTime!),
                      style: AppText.caption,
                    ),
                    AppSizes.wGap5,
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.appGreen,
                    ),
                  ],
                )
              : Icon(
                  Icons.close_rounded,
                  color: AppColors.appRed.withOpacity(0.5),
                ),
    );
  }
}
