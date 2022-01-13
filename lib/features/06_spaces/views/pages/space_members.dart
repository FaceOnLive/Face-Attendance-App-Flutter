import '../../../../core/models/member.dart';
import '../../../../core/models/space.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../../../05_members/views/pages/member_info.dart';
import '../controllers/space_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';

import 'space_member_add.dart';
import 'space_member_remove.dart';

class SpaceMembersScreen extends StatefulWidget {
  const SpaceMembersScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  State<SpaceMembersScreen> createState() => _SpaceMembersScreenState();
}

class _SpaceMembersScreenState extends State<SpaceMembersScreen> {
  /* <---- Dependency -----> */
  SpaceController controller = Get.find();

  /// Member List
  List<Member> _allSpacesMember = [];

  // Get Member of this space
  void _getMemberOfThisSpace() {
    _allSpacesMember =
        controller.getMembersBySpaceID(spaceID: widget.space.spaceID!);
  }

  @override
  void initState() {
    super.initState();
    _getMemberOfThisSpace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _allSpacesMember.isEmpty
                ? const Center(
                    child: Text('No Member Found'),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount: _allSpacesMember.length,
                      itemBuilder: (context, index) {
                        Member _currentMember = _allSpacesMember[index];
                        return _MemberListTile(member: _currentMember);
                      },
                    ),
                  ),
          ),
          if (_allSpacesMember.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Add Member',
                    onTap: () {
                      Get.to(() => SpaceMemberAddScreen(space: widget.space));
                    },
                    disableBorderRadius: true,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(20),
                    prefixIcon: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    label: 'Remove Member',
                    onTap: () {
                      Get.to(
                          () => SpaceMemberRemoveScreen(space: widget.space));
                    },
                    disableBorderRadius: true,
                    backgroundColor: AppColors.appRed,
                    margin: const EdgeInsets.all(0),
                    padding: const EdgeInsets.all(20),
                    prefixIcon: const Icon(
                      Icons.person_remove_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
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
        Get.bottomSheet(
          MemberInfoScreen(
            member: member,
          ),
          isScrollControlled: true,
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
