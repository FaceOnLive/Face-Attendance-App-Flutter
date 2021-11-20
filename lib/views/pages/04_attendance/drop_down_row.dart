import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/spaces/space_controller.dart';
import '../../../models/space.dart';
import '../../themes/text.dart';
import '../08_spaces/space_add.dart';
import '../08_spaces/space_info.dart';
import 'log_screen.dart';

class DropDownRow extends GetView<SpaceController> {
  const DropDownRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: context.theme.primaryColor,
                ),
                borderRadius: AppDefaults.defaulBorderRadius,
              ),
              child: GetBuilder<SpaceController>(builder: (controller) {
                return controller.isFetchingSpaces
                    ? const SizedBox(
                        height: 50,
                        child: LinearProgressIndicator(),
                      )
                    : DropdownButton<String>(
                        isExpanded: true,
                        underline: const SizedBox(),
                        dropdownColor: context.theme.canvasColor,
                        items: List.generate(
                          controller.allSpaces.length + 1,
                          (index) {
                            // Create button
                            if (index == controller.allSpaces.length) {
                              return const DropdownMenuItem(
                                child: _CreateNewSpaceButton(),
                                value: 'create',
                              );
                            }

                            /// List
                            Space _currentSpace = controller.allSpaces[index];
                            return DropdownMenuItem(
                              child: _DropDownSpaceItem(
                                active: true,
                                iconData: _currentSpace.icon,
                                label: _currentSpace.name,
                                onTap: () {
                                  Get.to(
                                    () => SpaceInfoScreen(space: _currentSpace),
                                  );
                                },
                              ),
                              value: _currentSpace.name.toLowerCase(),
                            );
                          },
                        ),
                        value: controller.currentSpace!.name.toLowerCase(),
                        onChanged: controller.onSpaceChangeDropDown,
                      );
              }),
            ),
          ),
          AppSizes.wGap10,
          // DATE COLUMN
          // Column(
          //   children: [
          //     Text(
          //       DateFormat.EEEE().format(DateTime.now()),
          //       style: AppText.caption,
          //     ),
          //     Text(
          //       DateFormat.yMMMMd().format(DateTime.now()),
          //       style: AppText.caption,
          //     ),
          //   ],
          // ),
          // Space Log Button
          IconButton(
            onPressed: () {
              Get.to(() => const SpaceLogScreen());
            },
            icon: const Icon(Icons.assignment_outlined),
          ),
        ],
      ),
    );
  }
}

class _CreateNewSpaceButton extends StatelessWidget {
  const _CreateNewSpaceButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => const SpaceCreateScreen());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create New Space',
            style: AppText.b1.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          AppSizes.wGap10,
          const Icon(Icons.add),
        ],
      ),
    );
  }
}

class _DropDownSpaceItem extends StatelessWidget {
  const _DropDownSpaceItem({
    Key? key,
    required this.label,
    required this.active,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final bool active;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(iconData),
            AppSizes.wGap10,
            Text(
              label,
              style: AppText.b1.copyWith(
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onTap,
          child: const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
