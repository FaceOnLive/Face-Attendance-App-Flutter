import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/member.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';
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
              style: context.textTheme.caption,
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
                switch (controller.spaceViewState) {

                  /// Initializing
                  case SpaceViewState.isInitializing:
                    return const LoadingMembers();

                  /// Fetching Member
                  case SpaceViewState.isFetching:
                    return const LoadingMembers();

                  /// No Space Found
                  // case SpaceViewState.isMemberEmpty:
                  //   return NoMemberFound(
                  //     currentSpace: controller.currentSpace!,
                  //   );

                  /// No Member Found
                  case SpaceViewState.isMemberEmpty:
                    return NoMemberFound(
                      currentSpace: controller.currentSpace!,
                    );

                  /// Filtered list is empty
                  case SpaceViewState.isFilterdListEmpty:
                    return const AttendanceIsClearWidget();

                  /// Everything is alright
                  case SpaceViewState.isFetched:
                    return const UserListFetched();

                  default:
                    return const Text("Something error happened");
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class UserListFetched extends GetView<SpaceController> {
  const UserListFetched({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          return await controller.refreshData();
        },
        child: ListView.separated(
            itemCount: controller.filteredListMember.length,
            itemBuilder: (context, index) {
              Member _currentMember = controller.filteredListMember[index];
              return MemberListTileSpace(
                member: _currentMember,
                currentSpaceID: controller.currentSpace!.spaceID!,
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
  }
}
