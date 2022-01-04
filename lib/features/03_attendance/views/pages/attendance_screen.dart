import '../../../../core/widgets/app_button.dart';
import '../widgets/widgets.dart';
import '../../../04_verifier/views/components/verifier_check.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';

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
            AppButton(
              label: 'Verifier SDK Check',
              onTap: () => Get.to(() => const VerifierCheckScreen()),
              suffixIcon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
              disableBorderRadius: true,
              margin: EdgeInsets.zero,
            ),
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
