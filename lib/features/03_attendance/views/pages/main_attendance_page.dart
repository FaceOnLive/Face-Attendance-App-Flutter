import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../04_verifier/views/components/verifier_face_login_test.dart';
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
            AppButton(
              label: 'Test Face Login',
              onTap: () => Get.to(() => const VerifierTestFaceLoginPage()),
              margin: EdgeInsets.zero,
              suffixIcon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
              disableBorderRadius: true,
            ),
            /* <---- Header ----> */
            const HeaderMainPage(),
            /* <---- Attendance List -----> */
            GetBuilder<SpaceController>(
              builder: (controller) {
                if (controller.spaceViewState ==
                    SpaceViewState.isInitializing) {
                  return const LoadingMembers();
                } else if (controller.spaceViewState ==
                    SpaceViewState.isNoSpaceFound) {
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

            /// If sdk is still setting up
            const SettingSDKDatabase()
          ],
        ),
      ),
    );
  }
}
