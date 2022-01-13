import '../../../../core/constants/constants.dart';
import '../../../02_entrypoint/entrypoint.dart';
import '../controllers/member_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/themes/text.dart';

class DeleteUserDialog extends StatefulWidget {
  const DeleteUserDialog({
    Key? key,
    required this.memberID,
    required this.isCustom,
  }) : super(key: key);

  final String memberID;
  final bool isCustom;

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  final RxBool _deletingUser = false.obs;

  @override
  void dispose() {
    _deletingUser.close();
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
            'Delete User',
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
                  () => _deletingUser.isTrue
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
                                _deletingUser.trigger(true);
                                await Get.find<MembersController>()
                                    .removeMember(
                                  memberID: widget.memberID,
                                  isCustom: widget.isCustom,
                                );
                                Get.offAll(() => const EntryPointUI());
                                _deletingUser.trigger(false);
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
