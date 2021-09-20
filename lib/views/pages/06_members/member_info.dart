import '../../../models/member.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../themes/text.dart';
import '../../widgets/picture_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'member_edit.dart';

class MemberInfoScreen extends StatelessWidget {
  const MemberInfoScreen({Key? key, required this.member}) : super(key: key);

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => MemberEditScreen(
                  member: member,
                ),
              );
            },
            icon: Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          child: Column(
            children: [
              /* <---- User Info ----> */
              PictureWidget(
                disableTap: true,
                profileLink: member.memberPicture,
                heroTag: member.memberID,
              ),
              Column(
                children: [
                  AppSizes.hGap10,
                  Text(
                    member.memberName,
                    style: AppText.h6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.PRIMARY_COLOR),
                  ),
                  Text(member.memberNumber.toString()),
                  Text(member.memberFullAdress),
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
                child: SfCalendar(
                  view: CalendarView.month,
                  backgroundColor: Colors.white,
                  cellBorderColor: Colors.white,
                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: AppText.b1.copyWith(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  showNavigationArrow: true,
                  blackoutDates: [
                    DateTime.now().add(
                      Duration(days: 2),
                    ),
                    DateTime.now().add(
                      Duration(days: 3),
                    ),
                    DateTime.now().add(
                      Duration(days: 4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
