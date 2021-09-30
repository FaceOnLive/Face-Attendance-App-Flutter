import 'package:face_attendance/controllers/members/member_controller.dart';
import 'package:face_attendance/controllers/user/user_controller.dart';
import 'package:face_attendance/views/widgets/app_button.dart';
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
  const MemberInfoScreen({
    Key? key,
    required this.member,
    this.spaceID,
  }) : super(key: key);

  final Member member;
  final String? spaceID;

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
                    style: AppText.h5.copyWith(
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
              spaceID == null
                  ? SizedBox()
                  :
                  // Calendar
                  _MemberAttendance(
                      spaceID: spaceID!,
                      memberID: member.memberID!,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberAttendance extends StatefulWidget {
  const _MemberAttendance({
    Key? key,
    required this.spaceID,
    required this.memberID,
  }) : super(key: key);

  final String spaceID;
  final String memberID;

  @override
  State<_MemberAttendance> createState() => _MemberAttendanceState();
}

class _MemberAttendanceState extends State<_MemberAttendance> {
  // Progress
  RxBool _isFetchinUserData = false.obs;

  // UnAttended Date
  List<DateTime> _unAttendedDate = [];

  Future<void> _fetchThisMemberAttendance() async {
    _isFetchinUserData.trigger(true);
    _unAttendedDate =
        await Get.find<MembersController>().fetchThisYearAttendnce(
      memberID: widget.memberID,
      spaceID: widget.spaceID,
      year: DateTime.now().year,
    );
    isAttendedToday();
    _isFetchinUserData.trigger(false);
  }

  /// Is Attended Today
  RxBool _isAttendedToday = false.obs;

  void isAttendedToday() {
    if (_unAttendedDate.contains(DateTime.now().day)) {
      _isAttendedToday.trigger(false);
    } else {
      _isAttendedToday.trigger(true);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchThisMemberAttendance();
  }

  @override
  void dispose() {
    _isFetchinUserData.close();
    _isAttendedToday.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Attendance Report',
          style: AppText.bBOLD.copyWith(color: AppColors.PRIMARY_COLOR),
        ),
        AppSizes.hGap10,
        Obx(
          () => _isFetchinUserData.isTrue
              ? Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SfCalendar(
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
                        blackoutDatesTextStyle: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                        blackoutDates: _unAttendedDate,
                        firstDayOfWeek:
                            Get.find<AppUserController>().currentUser.holiday,
                      ),
                      _isAttendedToday.isTrue
                          ? AppButton(
                              width: Get.width * 0.8,
                              label: "Mark as unattended",
                              suffixIcon:
                                  Icon(Icons.check, color: Colors.white),
                              backgroundColor: AppColors.APP_RED,
                              onTap: () {},
                            )
                          : AppButton(
                              width: Get.width * 0.8,
                              label: "Mark as attended",
                              suffixIcon:
                                  Icon(Icons.check, color: Colors.white),
                              onTap: () {},
                            ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
