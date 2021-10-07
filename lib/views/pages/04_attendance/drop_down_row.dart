import '../../../controllers/spaces/space_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_defaults.dart';
import '../../../constants/app_sizes.dart';
import '../../../models/space.dart';
import '../08_spaces/space_add.dart';
import '../08_spaces/space_info.dart';
import '../../themes/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DropDownRow extends GetView<SpaceController> {
  const DropDownRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
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
                    ? Container(
                        height: 50,
                        child: LinearProgressIndicator(),
                      )
                    : DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(),
                        dropdownColor: Colors.white,
                        items: List.generate(
                          controller.allSpaces.length + 1,
                          (index) {
                            // Create button
                            if (index == controller.allSpaces.length) {
                              return DropdownMenuItem(
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
          Column(
            children: [
              Text(
                DateFormat.EEEE().format(DateTime.now()),
                style: AppText.caption,
              ),
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: AppText.caption,
              ),
            ],
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
        Get.to(() => SpaceCreateScreen());
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create New Space',
              style: AppText.b1.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
            AppSizes.wGap10,
            Icon(Icons.add),
          ],
        ),
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
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onTap,
          child: Icon(
            Icons.info_outline_rounded,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}
