import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/controllers/app_member_verify.dart';
import '../components/app_member_header.dart';
import '../components/drop_down.dart';
import '../components/today_date_widget.dart';
import '../components/verifier_section.dart';

class AppMemberHomeScreen extends StatelessWidget {
  const AppMemberHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          const AppMemberHeaderHome(),
          const TodayDateRowWidget(),
          Expanded(
            child: GetBuilder<AppMemberVerifyController>(builder: (controller) {
              return Column(
                children: [
                  // DropDown
                  controller.verifyingState == VerifyState.verifying
                      ? const SizedBox()
                      : const AppMemberDropDown(),
                  const Expanded(
                    child: AppMemberVerifierWidget(),
                  ),
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
