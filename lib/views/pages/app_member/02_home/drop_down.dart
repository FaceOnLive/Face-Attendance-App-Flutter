import 'join_qr_code.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../constants/app_sizes.dart';
import '../../../../controllers/spaces/app_member_space.dart';
import '../../../../models/space.dart';
import '../../08_spaces/space_info.dart';
import '../../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMemberDropDown extends StatefulWidget {
  const AppMemberDropDown({
    Key? key,
  }) : super(key: key);

  @override
  State<AppMemberDropDown> createState() => _AppMemberDropDownState();
}

class _AppMemberDropDownState extends State<AppMemberDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              child: GetBuilder<AppMemberSpaceController>(
                builder: (controller) {
                  if (controller.isFetchingSpaces) {
                    return const SizedBox(
                      height: 50,
                      child: LinearProgressIndicator(),
                    );
                  } else if (controller.allSpaces.isEmpty) {
                    return const SizedBox();
                  } else {
                    return DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: context.theme.canvasColor,
                      items: List.generate(
                        controller.allSpaces.length + 1,
                        (index) {
                          // Create button
                          if (index == controller.allSpaces.length) {
                            return const DropdownMenuItem(
                              child: _JoinNewSpaceButton(),
                              value: 'Join',
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
                      onChanged: controller.onSpaceDropDownTap,
                    );
                  }
                },
              ),
            ),
          ),
          AppSizes.wGap10,
          // DATE COLUMN
          Column(
            children: const [],
          ),
          // Space Log Button
          IconButton(
            onPressed: () {
              Get.to(() => const AppMemberJoinQRCODE());
            },
            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _JoinNewSpaceButton extends StatelessWidget {
  const _JoinNewSpaceButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Get.to(() => SpaceCreateScreen());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Join New Space',
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
