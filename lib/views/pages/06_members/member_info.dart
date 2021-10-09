import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_sizes.dart';
import '../../../controllers/members/member_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../models/member.dart';
import '../../dialogs/date_dialog.dart';
import '../../themes/text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/picture_display.dart';
import 'member_attendance.dart';
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
  /* <---- Dependency -----> */
  MembersController _membersController = Get.find();

  // Progress
  RxBool _isFetchinUserData = false.obs;

  // UnAttended Date
  List<DateTime> _unAttendedDate = [];

  /// Is Attended Today
  RxBool _isAttendedToday = false.obs;

  Future<void> _fetchThisMemberAttendance() async {
    _unAttendedDate = [];
    _isFetchinUserData.trigger(true);
    _unAttendedDate = await _membersController.fetchThisYearAttendnce(
      memberID: widget.memberID,
      spaceID: widget.spaceID,
      year: DateTime.now().year,
    );
    _isAttendedToday.value = _membersController.isMemberAttendedToday(
      unattendedDate: _unAttendedDate,
    );
    _isFetchinUserData.trigger(false);
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
        _IsAttendedTodayRow(isAttendedToday: _isAttendedToday),
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
                        backgroundColor: context.theme.canvasColor,
                        cellBorderColor: Colors.white,
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: AppText.b1.copyWith(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        blackoutDatesTextStyle: TextStyle(
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                        blackoutDates: _unAttendedDate,
                        firstDayOfWeek:
                            Get.find<AppUserController>().currentUser.holiday,
                        onTap: (v) async {
                          if (v.date != null) {
                            await Get.dialog(
                              DateInfoDialog(
                                dateTime: v.date!,
                                spaceID: widget.spaceID,
                                memberID: widget.memberID,
                              ),
                            );
                            await _fetchThisMemberAttendance();
                          }
                        },
                      ),
                      AppButton(
                        width: Get.width * 0.8,
                        label: "Update Attendance",
                        suffixIcon: Icon(Icons.edit, color: Colors.white),
                        onTap: () {
                          Get.to(
                            () => MemberAttendanceEditScreen(
                              memberID: widget.memberID,
                              unattendedDates: _unAttendedDate,
                              spaceID: widget.spaceID,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _IsAttendedTodayRow extends StatelessWidget {
  const _IsAttendedTodayRow({
    Key? key,
    required RxBool isAttendedToday,
  })  : _isAttendedToday = isAttendedToday,
        super(key: key);

  final RxBool _isAttendedToday;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isAttendedToday.isTrue
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Attended Today', style: AppText.caption),
                      Icon(Icons.check, color: AppColors.APP_GREEN, size: 15),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not Attended', style: AppText.caption),
                      Icon(Icons.close, color: AppColors.APP_RED, size: 15),
                    ],
                  ),
          ],
        ));
  }
}
