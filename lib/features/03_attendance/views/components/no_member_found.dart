import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/space.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../06_spaces/views/pages/space_member_add.dart';

/// When No Members are found on List
/// This widgets are used on other parts of the UI where there is a user List
/// For Example in Member Adding or Removing,
/// Reusing widgets makes our app efficient
class NoMemberFound extends StatelessWidget {
  const NoMemberFound({
    Key? key,
    required this.currentSpace,
  }) : super(key: key);

  final Space currentSpace;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width * 0.5,
            child: Image.asset(
              AppImages.illustrationMemberEmpty,
            ),
          ),
          AppSizes.hGap20,
          const Text('No Member Found'),
          AppSizes.hGap10,
          AppButton(
            width: Get.width * 0.8,
            prefixIcon: const Icon(
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
            ),
            label: 'Add Member to ${currentSpace.name}',
            onTap: () {
              Get.bottomSheet(
                SpaceMemberAddScreen(
                  space: currentSpace,
                ),
                isScrollControlled: true,
                ignoreSafeArea: false,
              );
            },
          ),
        ],
      ),
    );
  }
}
