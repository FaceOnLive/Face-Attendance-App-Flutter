import '../../dialogs/generated_qr.dart';
import 'space_add_qr.dart';
import 'space_search.dart';

import 'space_range.dart';

import 'space_members.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../models/space.dart';
import 'space_edit.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpaceInfoScreen extends StatelessWidget {
  const SpaceInfoScreen({Key? key, required this.space}) : super(key: key);

  final Space space;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Space Info'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SpaceEditScreen(
                    space: space,
                  ));
            },
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* <---- Icon ----> */
            Container(
              padding: const EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.3),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: AppDefaults.defaulBorderRadius,
              ),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Icon(
                  space.icon,
                  color: Colors.white,
                  size: Get.width * 0.3,
                ),
              ),
            ),
            /* <---- Title ----> */
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                space.name,
                style: AppText.h5.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Text('Total Members: ${space.memberList.length}'),
            AppSizes.hGap20,
            /* <---- Actions Button ----> */
            SizedBox(
              width: Get.width * 0.7,
              child: Column(
                children: [
                  AppButton(
                    prefixIcon: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                    label: 'Members Management',
                    onTap: () {
                      Get.to(() => SpaceMembersScreen(
                            space: space,
                          ));
                    },
                  ),
                  AppButton(
                    prefixIcon: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                    ),
                    label: 'Edit Space Info',
                    onTap: () {
                      Get.to(() => SpaceEditScreen(space: space));
                    },
                  ),
                  AppButton(
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ),
                    label: 'Search Attendance',
                    onTap: () {
                      Get.to(
                        () => SpaceSearchScreen(
                          space: space,
                        ),
                      );
                    },
                  ),
                  AppButton(
                    prefixIcon: const Icon(
                      Icons.edit_location_alt_rounded,
                      color: Colors.white,
                    ),
                    label: 'Edit Office Range',
                    onTap: () {
                      Get.to(() => const SpaceRangeScreen());
                    },
                  ),
                  AppButton(
                    prefixIcon: const Icon(
                      Icons.person_pin_outlined,
                      color: Colors.white,
                    ),
                    label: 'Add Person From QR',
                    onTap: () {
                      Get.to(() => const SpaceAddQrPersonScreen());
                    },
                  ),
                ],
              ),
            ),
            AppButtonOutline(
              width: Get.width * 0.7,
              padding: const EdgeInsets.all(20),
              prefixIcon: const Icon(
                Icons.qr_code_2_rounded,
              ),
              label: 'Share Space',
              onTap: () {
                Get.dialog(
                  GenerateQRDialog(
                    data: 'Space: ${space.spaceID}',
                    title: 'Share Space',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
