import '../../../../core/models/member.dart';
import '../../../../core/models/space.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../../../03_attendance/views/components/components.dart';
import '../../../05_members/views/controllers/member_controller.dart';
import '../controllers/space_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';

class SpaceMemberAddScreen extends StatefulWidget {
  const SpaceMemberAddScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  _SpaceMemberAddScreenState createState() => _SpaceMemberAddScreenState();
}

class _SpaceMemberAddScreenState extends State<SpaceMemberAddScreen> {
  /* <---- Dependency -----> */
  final MembersController _membersController = Get.find();
  final SpaceController _spaceController = Get.find();

  /* <---- Selection -----> */
  final List<Member> _availableMember = [];
  final RxList<Member> _selectedMember = RxList<Member>();

  void _onMemberSelect(Member member) {
    if (_selectedMember.contains(member)) {
      _selectedMember.remove(member);
    } else {
      _selectedMember.add(member);
    }
    _membersController.update();
  }

  /// Progress BOOL
  final RxBool _isAddingMember = false.obs;

  /// Remove Member From Available List
  void _filterOutAddedMember() {
    List<Member> _allMember = Get.find<MembersController>().allMembers;
    List<String> _idsAllMember = [];
    for (var element in _allMember) {
      _idsAllMember.add(element.memberID!);
    }

    for (var element in _allMember) {
      if (widget.space.memberList.contains(element.memberID) ||
          widget.space.appMembers.contains(element.memberID!)) {
        // That means the member is already in ther list
      } else {
        _availableMember.add(element);
      }
    }
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
        title: const Text(
          'Add Members',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            /* <---- List -----> */
            GetBuilder<MembersController>(
              builder: (controller) => controller.isFetchingUser
                  ? const LoadingMembers()
                  : _availableMember.isNotEmpty
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
                      : const _EmptyMemberList(),
            ),
            /* <---- Add Button -----> */
            Obx(
              () => AppButton(
                disableBorderRadius: true,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(AppDefaults.padding),
                label: 'Add',
                isLoading: _isAddingMember.value,
                isButtonDisabled: _selectedMember.isEmpty,
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
                      backgroundColor: AppColors.appGreen,
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
          SizedBox(
            width: Get.width * 0.6,
            child: Image.asset(AppImages.illustrationMemberEmpty),
          ),
          AppSizes.hGap20,
          const Text('There is no one to add'),
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
        tag: member.memberID ?? member.memberNumber,
        child: MemberImageLeading(
          imageLink: member.memberPicture,
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
