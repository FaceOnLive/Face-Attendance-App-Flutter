import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/member_controller.dart';
import 'components/loading_data.dart';
import 'components/member_list_tile.dart';
import 'components/no_member_found.dart';

class MembersList extends StatelessWidget {
  const MembersList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: GetBuilder<MembersController>(
          builder: (controller) => controller.isFetchingUser
              ? const LoadingMemberData()
              : controller.allMembers.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: ListView.separated(
                        itemCount: controller.allMembers.length,
                        controller: controller.scrollController,
                        itemBuilder: (context, index) {
                          return MemberListTile(
                            member: controller.allMembers[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(
                            height: 7,
                          );
                        },
                      ),
                    )
                  : const NoMemberFoundSection(),
        ),
      ),
    );
  }
}
