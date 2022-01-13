import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/themes/text.dart';
import '../controllers/app_admin_controller.dart';

class ChangeHolidaySheet extends StatefulWidget {
  const ChangeHolidaySheet({Key? key}) : super(key: key);

  @override
  _ChangeHolidaySheetState createState() => _ChangeHolidaySheetState();
}

class _ChangeHolidaySheetState extends State<ChangeHolidaySheet> {
  /* <---- Dependency -----> */
  final AppAdminController _controller = Get.find();

  /// List of days to show in option
  List<String> _days = [];

  @override
  void initState() {
    super.initState();
    _days = _controller.allWeekDays;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppDefaults.padding,
      ),
      decoration: BoxDecoration(
        color: Get.theme.canvasColor,
        borderRadius: AppDefaults.bottomSheetRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select a holiday',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          AppSizes.hGap10,
          const Divider(),
          AppSizes.hGap10,
          /* <---- Days List -----> */
          GetBuilder<AppAdminController>(builder: (controller) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _days.length,
                (index) => _DayTile(
                  isSelected: index + 1 == controller.currentUser.holiday,
                  dayName: _days[index],
                  onTap: () async {
                    print(index + 1);
                    await controller.updateHoliday(selectedDay: index + 1);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({
    Key? key,
    required this.isSelected,
    required this.dayName,
    required this.onTap,
  }) : super(key: key);

  final bool isSelected;
  final String dayName;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: isSelected
            ? const Icon(
                Icons.check,
                color: AppColors.appGreen,
              )
            : null,
        title: Text(
          dayName,
          style: AppText.b1.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
          ),
        ),
        subtitle: isSelected
            ? Text(
                'Currently Selected',
                style: AppText.caption,
              )
            : null,
      ),
    );
  }
}
