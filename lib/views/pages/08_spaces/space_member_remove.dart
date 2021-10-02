import 'package:cached_network_image/cached_network_image.dart';
import '../../../constants/app_images.dart';
import '../../../models/space.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/members/member_controller.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/member.dart';
import '../04_attendance/user_list.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpaceMemberRemoveSheet extends StatefulWidget {
  const SpaceMemberRemoveSheet({Key? key, required this.space})
      : super(key: key);

  final Space space;

  @override
  _SpaceMemberRemoveSheetState createState() => _SpaceMemberRemoveSheetState();
}

class _SpaceMemberRemoveSheetState extends State<SpaceMemberRemoveSheet> {
  /* <---- Dependency -----> */
  MembersController _membersController = Get.find();
  SpaceController _spaceController = Get.find();

  /* <---- Selection -----> */
  List<Member> _availableMemberInSpace = [];
  RxList<Member> _selectedMember = RxList<Member>();

  void _onMemberSelect(Member member) {
    if (_selectedMember.contains(member)) {
      _selectedMember.remove(member);
    } else {
      _selectedMember.add(member);
    }
    _membersController.update();
  }

  /// Progress BOOL
  RxBool _isRemovingMember = false.obs;

  /// Remove Member From Available List
  void _filterOutAddedMember() {
    List<Member> _allMember = Get.find<MembersController>().allMember;
    List<String> _idsAllMember = [];
    _allMember.forEach((element) {
      _idsAllMember.add(element.memberID!);
    });

    _allMember.forEach((element) {
      if (widget.space.memberList.contains(element.memberID)) {
        _availableMemberInSpace.add(element);
      } else {
        // That means the member is already in their list
      }
    });
    _membersController.update();
  }

  @override
  void initState() {
    super.initState();
    _filterOutAddedMember();
  }

  @override
  void dispose() {
    _isRemovingMember.close();
    _selectedMember.close();
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
            AppSizes.hGap10,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: AppBar(
                title: Text(
                  'Remove Members',
                  style: AppText.h6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            /* <---- List -----> */
            GetBuilder<MembersController>(
              builder: (controller) => controller.isFetchingUser
                  ? LoadingMembers()
                  : _availableMemberInSpace.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _availableMemberInSpace.length,
                            itemBuilder: (context, index) {
                              Member _currentMember =
                                  _availableMemberInSpace[index];
                              return _MemberListTile(
                                member: _currentMember,
                                isSelected:
                                    _selectedMember.contains(_currentMember),
                                onTap: () {
                                  _onMemberSelect(_currentMember);
                                },
                              );
                            },
                          ),
                        )
                      : _EmptyMemberList(),
            ),
            /* <---- Add Button -----> */
            Obx(
              () => _selectedMember.length > 0
                  ? AppButton(
                      disableBorderRadius: true,
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
                      label: 'Remove',
                      isLoading: _isRemovingMember.value,
                      backgroundColor: AppColors.APP_RED,
                      onTap: () async {
                        try {
                          _isRemovingMember.trigger(true);
                          await _spaceController.removeMembersFromSpace(
                            spaceID: widget.space.spaceID!,
                            members: _selectedMember,
                          );
                          Get.back();
                          Get.back(closeOverlays: false);
                          Get.rawSnackbar(
                            title: 'Member Removed Successfully',
                            message:
                                'Total ${_selectedMember.length} Members has been removed',
                            backgroundColor: AppColors.APP_RED,
                            snackStyle: SnackStyle.GROUNDED,
                          );
                          _isRemovingMember.trigger(false);
                        } on FirebaseException catch (e) {
                          print(e);
                          _isRemovingMember.trigger(false);
                        }
                      },
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMemberList extends StatelessWidget {
  const _EmptyMemberList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Get.width * 0.6,
            child: Image.asset(AppImages.ILLUSTRATION_MEMBER_EMPTY),
          ),
          AppSizes.hGap20,
          Text('There is no one to add'),
        ],
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
