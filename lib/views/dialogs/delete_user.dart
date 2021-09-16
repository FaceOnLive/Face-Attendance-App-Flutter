import 'package:face_attendance/controllers/members/member_controller.dart';
import 'package:face_attendance/views/pages/03_main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_defaults.dart';
import '../../constants/app_sizes.dart';
import '../themes/text.dart';

class DeleteUserDialog extends StatefulWidget {
  const DeleteUserDialog({
    Key? key,
    required this.memberID,
  }) : super(key: key);

  final String memberID;

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  RxBool _deletingUser = false.obs;

  @override
  void dispose() {
    _deletingUser.close();
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
              'Delete User',
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
                    () => _deletingUser.isTrue
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
                                  _deletingUser.trigger(true);
                                  await Get.find<MembersController>()
                                      .removeMember(memberID: widget.memberID);
                                  Get.offAll(() => MainScreenUI());
                                  _deletingUser.trigger(false);
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
