import '../../../../core/models/member.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import 'components.dart';

class AttendedUserListSection extends StatelessWidget {
  const AttendedUserListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
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
                          Radio<MemberFilterList>(
                            value: MemberFilterList.all,
                            groupValue: controller.selectedOption,
                            onChanged: (v) {
                              controller.onRadioSelection(MemberFilterList.all);
                            },
                          ),
                          const Text('All'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<MemberFilterList>(
                            value: MemberFilterList.attended,
                            groupValue: controller.selectedOption,
                            onChanged: (v) {
                              controller.onRadioSelection(
                                MemberFilterList.attended,
                              );
                            },
                          ),
                          const Text('Attended'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<MemberFilterList>(
                            value: MemberFilterList.unattended,
                            groupValue: controller.selectedOption,
                            onChanged: (v) {
                              controller.onRadioSelection(
                                  MemberFilterList.unattended);
                            },
                          ),
                          const Text('Unattended'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppSizes.hGap10,
            /* <---- USER LIST -----> */
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (!controller.isEverythingFetched) {
                  // Loading Members
                  return const LoadingMembers();
                } else if (controller.isEverythingFetched) {
                  // There is no member
                  if (controller.filteredListMember.isNotEmpty &&
                      controller.allMembersSpace.isNotEmpty) {
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          return await controller.refreshAll();
                        },
                        child: ListView.separated(
                            itemCount: controller.filteredListMember.length,
                            itemBuilder: (context, index) {
                              Member _currentMember =
                                  controller.filteredListMember[index];
                              return MemberListTile(
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
                              return const Divider(
                                height: 7,
                              );
                            }),
                      ),
                    );
                  } else if (controller.allMembersSpace.isNotEmpty &&
                      controller.filteredListMember.isEmpty) {
                    return const AttendanceIsClearWidget();
                  } else if (controller.allMembersSpace.isEmpty &&
                      controller.filteredListMember.isEmpty &&
                      controller.isEverythingFetched) {
                    return NoMemberFound(
                      currentSpace: controller.currentSpace!,
                    );
                  } else {
                    return const Center(
                      child: Text('There is an error'),
                    );
                  }
                } else {
                  return const LoadingMembers();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
