import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../../../02_entrypoint/entrypoint.dart';
import '../controllers/space_controller.dart';

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
  final RxBool _deletingSpace = false.obs;

  @override
  void dispose() {
    _deletingSpace.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDefaults.borderRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSizes.hGap10,
          Text(
            'Delete Space',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.appRed,
            ),
          ),
          const Divider(
            color: AppColors.placeholderColor,
            thickness: 0.3,
          ),
          Container(
            padding: const EdgeInsets.all(
              AppDefaults.padding,
            ),
            child: Column(
              children: [
                Obx(
                  () => _deletingSpace.isTrue
                      ? const CircularProgressIndicator()
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
                                    color: AppColors.appGreen,
                                  ),
                                  const Text('No'),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                _deletingSpace.trigger(true);
                                await Get.find<SpaceController>()
                                    .removeSpace(spaceID: widget.spaceID);
                                Get.offAll(() => const EntryPointUI());
                                _deletingSpace.trigger(false);
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: Get.width * 0.2,
                                    color: AppColors.appRed,
                                  ),
                                  const Text('Yes')
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
    );
  }
}
