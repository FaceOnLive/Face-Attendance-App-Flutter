import 'package:face_attendance/features/03_attendance/views/widgets/widgets.dart';
import 'package:face_attendance/features/06_spaces/views/controllers/space_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'drop_down_row.dart';
import 'user_list.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

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
                        DropDownRow(),

                        /* <---- User List ----> */
                        AttendedUserList()
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
