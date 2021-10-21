import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/space.dart';
import '../08_spaces/space_member_add.dart';
import '../../widgets/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/member.dart';
import '../../themes/text.dart';
import '../06_members/member_info.dart';

class AttendedUserList extends StatelessWidget {
  const AttendedUserList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              DateFormat.yMMMEd().format(DateTime.now()),
              style: AppText.caption,
            ),
            // Header
            GetBuilder<SpaceController>(
              builder: (controller) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: controller.radioOption,
                            onChanged: (v) {
                              controller.onRadioSelection(0);
                            },
                          ),
                          Text('All'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: controller.radioOption,
                            onChanged: (v) {
                              controller.onRadioSelection(1);
                            },
                          ),
                          Text('Attended'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<int>(
                            value: 2,
                            groupValue: controller.radioOption,
                            onChanged: (v) {
                              controller.onRadioSelection(2);
                            },
                          ),
                          Text('Unattended'),
                        ],
                      ),
                    ],
                  ),
                  // // Filtering
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Today',
                  //       style: AppText.caption,
                  //     ),
                  //     Icon(
                  //       Icons.filter_alt_outlined,
                  //       size: 20,
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
            AppSizes.hGap10,
            /* <---- USER LIST -----> */
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (!controller.isEverythingFetched) {
                  // Loading Members
                  return LoadingMembers();
                } else {
                  // There is no member
                  if (controller.spacesMember.length > 0 &&
                      controller.allMembersSpace.length > 0) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return await controller.refreshAll();
                        },
                        child: ListView.separated(
                            itemCount: controller.spacesMember.length,
                            itemBuilder: (context, index) {
                              Member _currentMember =
                                  controller.spacesMember[index];
                              return _MemberListTile(
                                member: _currentMember,
                                currentSpaceID:
                                    controller.currentSpace!.spaceID!,
                                attendedTime: controller.isMemberAttendedToday(
                                  memberID: _currentMember.memberID!,
                                ),
                                fetchingTodaysLog: controller.fetchingTodaysLog,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 7,
                              );
                            }),
                      ),
                    );
                  } else if (controller.allMembersSpace.length > 0 &&
                      controller.spacesMember.length < 1) {
                    return Expanded(
                      child: Center(
                        child: Text('Attendance is clear'),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: NoMemberFound(
                        currentSpace: controller.currentSpace!,
                      ),
                    );
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class _MemberListTile extends StatelessWidget {
  const _MemberListTile({
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
          () => MemberInfoScreen(
            member: member,
            spaceID: currentSpaceID,
          ),
        );
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
      trailing: fetchingTodaysLog
          ? Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: Icon(Icons.info_outline_rounded),
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
                    Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.APP_GREEN,
                    ),
                  ],
                )
              : Icon(
                  Icons.close_rounded,
                  color: AppColors.APP_RED.withOpacity(0.5),
                ),
    );
  }
}

/// When No Members are found on List
/// This widgets are used on other parts of the UI where there is a user List
/// For Example in Member Adding or Removing,
/// Reusing widgets makes our app efficient
class NoMemberFound extends StatelessWidget {
  const NoMemberFound({
    Key? key,
    required this.currentSpace,
  }) : super(key: key);

  final Space currentSpace;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Get.width * 0.5,
          child: Image.asset(
            AppImages.ILLUSTRATION_MEMBER_EMPTY,
          ),
        ),
        AppSizes.hGap20,
        Text('No Member Found'),
        AppSizes.hGap10,
        AppButton(
          width: Get.width * 0.8,
          prefixIcon: Icon(
            Icons.person_add_alt_1_rounded,
            color: Colors.white,
          ),
          label: 'Add Member to ${currentSpace.name}',
          onTap: () {
            Get.bottomSheet(
              SpaceMemberAddScreen(
                space: currentSpace,
              ),
              isScrollControlled: true,
              ignoreSafeArea: false,
            );
          },
        ),
      ],
    );
  }
}

class LoadingMembers extends StatelessWidget {
  /// To Add A Loading List Effect
  /// This widgets are used on other parts of the UI where there is a user List
  /// For Example in Member Adding or Removing
  /// Reusing widgets makes our app efficient
  const LoadingMembers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
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
      ),
    );
  }
}
