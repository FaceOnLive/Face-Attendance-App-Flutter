import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/space.dart';
import '../../../../core/themes/text.dart';
import '../../../06_spaces/views/controllers/space_controller.dart';
import '../../../06_spaces/views/pages/space_create_page.dart';
import '../../../06_spaces/views/pages/space_info.dart';

class DropDownRowSection extends GetView<SpaceController> {
  const DropDownRowSection({
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
                borderRadius: AppDefaults.borderRadius,
              ),
              child: GetBuilder<SpaceController>(builder: (controller) {
                switch (controller.spaceViewState) {
                  case SpaceViewState.isInitializing:
                    return const SizedBox(
                      height: 50,
                      child: LinearProgressIndicator(),
                    );

                  case SpaceViewState.isNoSpaceFound:
                    return const SizedBox();

                  case SpaceViewState.isFetched:
                    return const _TheDropDown();

                  case SpaceViewState.isMemberEmpty:
                    return const _TheDropDown();

                  default:
                    return const _TheDropDown();
                }
              }),
            ),
          ),
          AppSizes.wGap10,

          /// This is deprecated and no longer used
          // Space Log Button
          // IconButton(
          //   onPressed: () {
          //     Get.to(() => const SpaceLogScreen());
          //   },
          //   icon: const Icon(Icons.assignment_outlined),
          // ),
        ],
      ),
    );
  }
}

class _TheDropDown extends GetView<SpaceController> {
  const _TheDropDown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: _CreateNewSpaceButton(),
              value: 'create',
            );
          }

          /// List
          Space _indexedSpace = controller.allSpaces[index];
          return DropdownMenuItem(
            child: _DropDownSpaceItem(
              active: true,
              iconData: _indexedSpace.icon,
              label: _indexedSpace.name,
              onTap: () {
                Get.to(
                  () => SpaceInfoScreen(space: _indexedSpace),
                );
              },
            ),
            value: _indexedSpace.name.toLowerCase(),
          );
        },
      ),
      value: controller.currentSpace!.name.toLowerCase(),
      onChanged: controller.onDropDownUpdate,
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
        Get.to(() => const SpaceCreatePage());
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
