import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../06_spaces/views/controllers/space_controller.dart';
import '../components/components.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      color: context.theme.canvasColor,
      child: SafeArea(
        child: Column(
          children: [
            /* <---- Header ----> */
            const HeaderMainPage(),
            /* <---- Attendance List -----> */
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (controller.isFetchingSpaces) {
                  return const LoadingMembers();
                } else if (controller.allSpaces.isEmpty) {
                  return const NoSpaceFound();
                } else {
                  return Expanded(
                    child: Column(
                      children: const [
                        /* <---- DropDown and Date----> */
                        DropDownRowSection(),

                        /* <---- User List ----> */
                        AttendedUserListSection()
                      ],
                    ),
                  );
                }
              },
            ),
            const SettingSDKDatabase()
          ],
        ),
      ),
    );
  }
}
