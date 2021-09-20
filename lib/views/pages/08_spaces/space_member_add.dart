import 'package:cached_network_image/cached_network_image.dart';
import 'package:face_attendance/constants/app_colors.dart';
import 'package:face_attendance/constants/app_sizes.dart';
import 'package:face_attendance/controllers/members/member_controller.dart';
import 'package:face_attendance/controllers/spaces/space_controller.dart';
import 'package:face_attendance/models/member.dart';
import 'package:face_attendance/views/pages/04_attendance/user_list.dart';
import 'package:face_attendance/views/themes/text.dart';
import 'package:face_attendance/views/widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpaceMemberAddSheet extends StatefulWidget {
  const SpaceMemberAddSheet({Key? key, required this.spaceID})
      : super(key: key);

  final String spaceID;

  @override
  _SpaceMemberAddSheetState createState() => _SpaceMemberAddSheetState();
}

class _SpaceMemberAddSheetState extends State<SpaceMemberAddSheet> {
  /* <---- Dependency -----> */
  MembersController _membersController = Get.find();
  SpaceController _spaceController = Get.find();

  /* <---- Selection -----> */
  List<Member> _selectedMember = [];

  void _onMemberSelect(Member member) {
    if (_selectedMember.contains(member)) {
      _selectedMember.remove(member);
    } else {
      _selectedMember.add(member);
    }
    _membersController.update();
  }

  RxBool _isAddingMember = false.obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _isAddingMember.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Column(
          children: [
            /* <---- Header -----> */
            Container(
              padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
              child: Text(
                'Add Members',
                style: AppText.h6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.PRIMARY_COLOR),
              ),
            ),
            Divider(),
            /* <---- List -----> */
            GetBuilder<MembersController>(
              builder: (controller) => controller.isFetchingUser
                  ? LoadingMembers()
                  : controller.allMember.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: controller.allMember.length,
                            itemBuilder: (context, index) {
                              Member _currentMember =
                                  controller.allMember[index];
                              return _MemberListTile(
                                member: _currentMember,
                                isSelected:
                                    _selectedMember.contains(_currentMember),
                                onTap: () {
                                  _onMemberSelect(controller.allMember[index]);
                                },
                              );
                            },
                          ),
                        )
                      : NoMemberFound(),
            ),
            /* <---- Add Button -----> */
            Obx(
              () => AppButton(
                disableBorderRadius: true,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
                label: 'Add',
                isLoading: _isAddingMember.value,
                onTap: () async {
                  try {
                    _isAddingMember.trigger(true);
                    await _spaceController.addMembersToSpace(
                      spaceID: widget.spaceID,
                      members: _selectedMember,
                    );
                    Get.back();
                    Get.rawSnackbar(
                      title: 'Member Added Successfully',
                      message:
                          'Total ${_selectedMember.length} Members has been added',
                      backgroundColor: AppColors.APP_GREEN,
                      snackStyle: SnackStyle.GROUNDED,
                    );
                    _isAddingMember.trigger(false);
                  } on FirebaseException catch (e) {
                    print(e);
                    _isAddingMember.trigger(false);
                  }
                },
              ),
            ),
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
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  final Member member;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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
      trailing: Checkbox(
        onChanged: (v) {
          onTap();
        },
        value: isSelected,
      ),
    );
  }
}
