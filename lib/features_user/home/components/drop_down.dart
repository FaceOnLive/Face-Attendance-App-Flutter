import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../core/models/space.dart';
import '../../../features/06_spaces/views/pages/space_info.dart';
import '../../core/controllers/app_member_space.dart';
import '../views/join_qr_code_page.dart';

class AppMemberDropDown extends StatelessWidget {
  const AppMemberDropDown({
    Key? key,
  }) : super(key: key);

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
                borderRadius: AppDefaults.borderRadius,
              ),
              child: GetBuilder<AppMemberSpaceController>(
                builder: (controller) {
                  if (controller.isFetchingSpaces) {
                    return const SizedBox(
                      height: 30,
                      child: LinearProgressIndicator(),
                    );
                  } else if (controller.allSpaces.isEmpty) {
                    return const _JoinNewSpaceButton();
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
                      onChanged: controller.onSpaceDropDownChange,
                    );
                  }
                },
              ),
            ),
          ),
          AppSizes.wGap10,

          // Space Join QR Button
          IconButton(
            onPressed: () {
              Get.to(() => const AppMemberJoinQRCODEPage());
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
      onTap: () => Get.to(() => const AppMemberJoinQRCODEPage()),
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
