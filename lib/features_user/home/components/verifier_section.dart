import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/app_member_verify.dart';
import 'verifer_section_unverifed.dart';
import 'verifier_section_member_attended.dart';
import 'verifier_section_no_space_found.dart';
import 'verifier_section_open_camera_.dart';
import 'verifying_section_animation.dart';

class AppMemberVerifierWidget extends GetView<AppMemberVerifyController> {
  const AppMemberVerifierWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        /* <---- Status -----> */
        GetBuilder<AppMemberVerifyController>(
          builder: (_) {
            switch (controller.verifyingState) {
              case VerifyState.attended:
                {
                  return const MemberAttendedSection();
                }
              case VerifyState.verifying:
                {
                  return const OpenCameraPreview();
                }

              case VerifyState.verified:
                {
                  return const VerifyAnimation();
                }
              case VerifyState.unverified:
                {
                  return const UnverifiedSection();
                }

              case VerifyState.noSpaceFound:
                {
                  return const NoSpaceFoundSection();
                }

              case VerifyState.initializing:
                {
                  return const Center(child: CircularProgressIndicator());
                }
              default:
                return const Text('Oops! Something gone wrong');
            }
          },
        ),
      ],
    );
  }
}
