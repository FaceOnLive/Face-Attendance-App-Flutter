import 'package:cached_network_image/cached_network_image.dart';
import '../../../constants/app_images.dart';
import '../../../models/space.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/members/member_controller.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/member.dart';
import '../04_attendance/user_list.dart';
import '../../widgets/app_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpaceMemberAddScreen extends StatefulWidget {
  const SpaceMemberAddScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  _SpaceMemberAddScreenState createState() => _SpaceMemberAddScreenState();
}

class _SpaceMemberAddScreenState extends State<SpaceMemberAddScreen> {
  /* <---- Dependency -----> */
  MembersController _membersController = Get.find();
  SpaceController _spaceController = Get.find();

  /* <---- Selection -----> */
  List<Member> _availableMember = [];
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
  RxBool _isAddingMember = false.obs;

  /// Remove Member From Available List
  void _filterOutAddedMember() {
    List<Member> _allMember = Get.find<MembersController>().allMember;
    List<String> _idsAllMember = [];
    _allMember.forEach((element) {
      _idsAllMember.add(element.memberID!);
    });

    _allMember.forEach((element) {
      if (widget.space.memberList.contains(element.memberID)) {
        // That means the member is already in ther list
      } else {
        _availableMember.add(element);
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
    _isAddingMember.close();
    _selectedMember.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Members',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /* <---- List -----> */
            GetBuilder<MembersController>(
              builder: (controller) => controller.isFetchingUser
                  ? LoadingMembers()
                  : _availableMember.length > 0
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _availableMember.length,
                            itemBuilder: (context, index) {
                              Member _currentMember = _availableMember[index];
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
              () => AppButton(
                disableBorderRadius: true,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(AppSizes.DEFAULT_PADDING),
                label: 'Add',
                isLoading: _isAddingMember.value,
                isButtonDisabled: _selectedMember.length < 1,
                onTap: () async {
                  try {
                    _isAddingMember.trigger(true);
                    await _spaceController.addMembersToSpace(
                      spaceID: widget.space.spaceID!,
                      members: _selectedMember,
                    );
                    Get.back();
                    Get.back();
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

/* <---- Other Helpful Widgets -----> */

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
