import 'package:cached_network_image/cached_network_image.dart';
import 'space_member_add.dart';
import 'space_member_remove.dart';
import '../../widgets/app_button.dart';
import '../../../constants/app_colors.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/member.dart';
import '../../../models/space.dart';
import '../06_members/member_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            child: Container(
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
                    Get.to(() => SpaceMemberRemoveScreen(space: widget.space));
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
      trailing: const Icon(
        Icons.info_outlined,
        color: AppColors.appGreen,
      ),
    );
  }
}
