import '../../controllers/spaces/space_controller.dart';
import '../pages/03_main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../themes/text.dart';

class DeleteSpaceDialog extends StatefulWidget {
  const DeleteSpaceDialog({
    Key? key,
    required this.spaceID,
  }) : super(key: key);

  final String spaceID;

  @override
  State<DeleteSpaceDialog> createState() => _DeleteSpaceDialog();
}

class _DeleteSpaceDialog extends State<DeleteSpaceDialog> {
  RxBool _deletingSpace = false.obs;

  @override
  void dispose() {
    _deletingSpace.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.defaulBorderRadius,
      ),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSizes.hGap10,
            Text(
              'Delete Space',
              style: AppText.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.APP_RED,
              ),
            ),
            Divider(
              color: AppColors.PLACEHOLDER_COLOR,
              thickness: 0.3,
            ),
            Container(
              padding: EdgeInsets.all(
                AppSizes.DEFAULT_PADDING,
              ),
              child: Column(
                children: [
                  Obx(
                    () => _deletingSpace.isTrue
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  Get.back();
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.close,
                                      size: Get.width * 0.2,
                                      color: AppColors.APP_GREEN,
                                    ),
                                    Text('No'),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  _deletingSpace.trigger(true);
                                  await Get.find<SpaceController>()
                                      .removeSpace(spaceID: widget.spaceID);
                                  Get.offAll(() => MainScreenUI());
                                  _deletingSpace.trigger(false);
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: Get.width * 0.2,
                                      color: AppColors.APP_RED,
                                    ),
                                    Text('Yes')
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  AppSizes.hGap20,
                  Text(
                    'CAUTION: This action is irreversible.',
                    textAlign: TextAlign.center,
                    style: AppText.caption,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
