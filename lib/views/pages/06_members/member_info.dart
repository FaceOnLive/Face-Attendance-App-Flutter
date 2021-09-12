import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../themes/text.dart';
import '../../widgets/picture_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class MemberInfoScreen extends StatelessWidget {
  const MemberInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: Container(
        width: Get.width,
        child: Column(
          children: [
            /* <---- User Info ----> */
            PictureWidget(
              disableTap: true,
              profileLink: AppImages.unsplashPersons[0],
              heroTag: AppImages.unsplashPersons[0],
            ),
            Column(
              children: [
                AppSizes.hGap10,
                Text(
                  'Member Name',
                  style: AppText.h6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR),
                ),
                Text('+852 XXXX XXXX'),
                Text('Luen Cheong Can Centre, Hong Kong'),
              ],
            ),
            // Divider
            SizedBox(
              height: Get.height * 0.05,
              width: Get.width * 0.4,
              child: Divider(
                color: AppColors.PRIMARY_COLOR,
              ),
            ),

            /* <---- Attendance ----> */
            Text(
              'Attendance Report',
              style: AppText.bBOLD.copyWith(color: AppColors.PRIMARY_COLOR),
            ),
            // Calendar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2040, 3, 14),
                focusedDay: DateTime.now(),
                rangeStartDay: DateTime.utc(2021, 9, 10),
                rangeEndDay: DateTime.utc(2021, 9, 22),
                daysOfWeekHeight: Get.height * 0.05,
                calendarStyle: CalendarStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
