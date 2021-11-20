import '../../../controllers/spaces/space_controller.dart';
import '../06_members/member_attendance.dart';
import '../06_members/member_edit.dart';
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

class MemberAttendanceDetails extends StatelessWidget {
  const MemberAttendanceDetails({
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
        title: const Text('Info'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => MemberEditScreen(
                  member: member,
                ),
              );
            },
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          child: Column(
            children: [
              /* <---- User Info ----> */
              ProfilePictureWidget(
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
                        color: AppColors.primaryColor),
                  ),
                  Text(member.memberNumber.toString()),
                  Text(member.memberFullAdress),
                ],
              ),
              // Divider
              SizedBox(
                height: Get.height * 0.05,
                width: Get.width * 0.4,
                child: const Divider(
                  color: AppColors.primaryColor,
                ),
              ),

              /* <---- Attendance ----> */
              spaceID == null
                  ? const SizedBox()
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
  final MembersController _membersController = Get.find();
  final SpaceController _spaceController = Get.find();

  // Progress
  final RxBool _isFetchingUserData = false.obs;

  // UnAttended Date
  List<DateTime> _unAttendedDate = [];

  /// Is Attended Today
  final RxBool _isAttendedToday = false.obs;

  Future<void> _fetchThisMemberAttendance() async {
    _unAttendedDate = [];
    _isFetchingUserData.trigger(true);
    _unAttendedDate = await _membersController.fetchThisYearAttendnce(
      memberID: widget.memberID,
      spaceID: widget.spaceID,
      year: DateTime.now().year,
    );
    // _isAttendedToday.value = _membersController.isMemberAttendedToday(
    //   unattendedDate: _unAttendedDate,
    // );

    _isAttendedToday.value =
        _spaceController.isMemberAttendedToday(memberID: widget.memberID) ==
                null
            ? false
            : true;

    _isFetchingUserData.trigger(false);
  }

  @override
  void initState() {
    super.initState();
    _fetchThisMemberAttendance();
  }

  @override
  void dispose() {
    _isFetchingUserData.close();
    _isAttendedToday.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Attendance Report',
          style: AppText.bBOLD.copyWith(color: AppColors.primaryColor),
        ),
        // is attended Today
        Obx(() => _IsAttendedTodayRow(isAttendedToday: _isAttendedToday.value)),

        AppSizes.hGap10,

        /// Calender
        Obx(
          () => _isFetchingUserData.isTrue
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SfCalendar(
                        view: CalendarView.month,
                        backgroundColor: context.theme.scaffoldBackgroundColor,
                        cellBorderColor: Colors.white,
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: AppText.b1.copyWith(
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        blackoutDatesTextStyle: const TextStyle(
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
                        suffixIcon: const Icon(Icons.edit, color: Colors.white),
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
  final bool isAttendedToday;
  const _IsAttendedTodayRow({
    required this.isAttendedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isAttendedToday == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Attended Today', style: AppText.caption),
                  const Icon(Icons.check, color: AppColors.appGreen, size: 15),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Attendence Today', style: AppText.caption),
                  const Icon(Icons.close, color: AppColors.appRed, size: 15),
                ],
              ),
      ],
    );
  }
}
