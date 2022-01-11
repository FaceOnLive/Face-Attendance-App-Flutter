import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/member_image_leading.dart';
import '../controllers/verify_controller.dart';

class ShowMessagePopUP extends StatelessWidget {
  /// This will show up when verification started
  const ShowMessagePopUP({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyController>(
      builder: (controller) {
        return Center(
          child: AnimatedOpacity(
            // IF We Should show the card
            opacity: controller.showProgressIndicator ? 1.0 : 0.0,
            duration: AppDefaults.duration,
            child: AnimatedContainer(
              duration: AppDefaults.duration,
              margin: const EdgeInsets.all(AppDefaults.margin),
              padding: const EdgeInsets.all(10),
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDefaults.borderRadius,
                boxShadow: AppDefaults.boxShadow,
              ),
              child: controller.isVerifyingNow
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          AppSizes.wGap10,
                          Text('Verifying'),
                        ],
                      ),
                    )
                  : controller.verifiedMember == null
                      ? const ListTile(
                          title: Text('No Member Found'),
                          trailing: Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        )
                      : ListTile(
                          leading: MemberImageLeading(
                            imageLink: controller.verifiedMember!.memberPicture,
                          ),
                          title: Text(controller.verifiedMember!.memberName),
                          subtitle: Text(controller.verifiedMember!.memberNumber
                              .toString()),
                          trailing: const Icon(
                            Icons.check_box_rounded,
                            color: AppColors.appGreen,
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }
}
