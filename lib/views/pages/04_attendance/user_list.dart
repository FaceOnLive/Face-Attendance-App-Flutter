import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/space.dart';
import '../08_spaces/space_member_add.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/member.dart';
import '../../themes/text.dart';
import '../06_members/member_info.dart';

class AttendedUserList extends StatefulWidget {
  const AttendedUserList({
    Key? key,
  }) : super(key: key);

  @override
  _AttendedUserListState createState() => _AttendedUserListState();
}

class _AttendedUserListState extends State<AttendedUserList> {
  SpaceController _spaceController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        Text('Attended'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        Text('Unattended'),
                      ],
                    ),
                  ],
                ),
                // Filtering
                Row(
                  children: [
                    Text(
                      'Today',
                      style: AppText.caption,
                    ),
                    Icon(
                      Icons.filter_alt_outlined,
                      size: 20,
                    )
                  ],
                ),
              ],
            ),
            AppSizes.hGap10,

            GetBuilder<SpaceController>(
              builder: (controller) => !controller.isEverythingFetched
                  ? LoadingMembers()
                  : _spaceController.currentSpaceMembers.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount:
                                _spaceController.currentSpaceMembers.length,
                            itemBuilder: (context, index) {
                              return _MemberListTile(
                                member:
                                    _spaceController.currentSpaceMembers[index],
                                isAttended: index.isEven ? true : false,
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: NoMemberFound(
                            currentSpace: _spaceController.currentSpace!,
                          ),
                        ),
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
    this.isAttended = false,
  }) : super(key: key);

  final Member member;
  final bool isAttended;

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
      trailing: isAttended
          ? Icon(
              Icons.check_circle_rounded,
              color: AppColors.APP_GREEN,
            )
          : Icon(
              Icons.close_rounded,
              color: AppColors.APP_RED,
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
              SpaceMemberAddSheet(
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
