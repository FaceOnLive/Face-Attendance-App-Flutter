import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/date_util.dart';
import '../../../../core/models/member.dart';
import '../../../../core/themes/text.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../05_members/views/controllers/member_controller.dart';

class DateInfoDialog extends StatelessWidget {
  const DateInfoDialog({
    Key? key,
    required this.dateTime,
    required this.spaceID,
    required this.member,
  }) : super(key: key);

  final DateTime dateTime;
  final String spaceID;
  final Member member;

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
            'Update Attendnace',
            style: AppText.h6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const Divider(
            color: AppColors.placeholderColor,
            thickness: 0.3,
          ),
          _UpdateAttendane(
            member: member,
            spaceID: spaceID,
            date: dateTime,
          ),
        ],
      ),
    );
  }
}

class _UpdateAttendane extends StatefulWidget {
  const _UpdateAttendane({
    Key? key,
    required this.spaceID,
    required this.member,
    required this.date,
  }) : super(key: key);
  final String spaceID;
  final Member member;
  final DateTime date;

  @override
  __UpdateAttendaneState createState() => __UpdateAttendaneState();
}

class __UpdateAttendaneState extends State<_UpdateAttendane> {
  /* <---- Dependency -----> */
  final MembersController _controller = Get.find();

  // Progress
  final RxBool _isUpdatingAttendance = false.obs;

  // SWITCH
  final RxBool _attended = true.obs;

  // is Today
  bool _isToday = false;

  // When the switch is false
  Future<void> _onAttendance() async {
    try {
      _isUpdatingAttendance.trigger(true);
      await _controller.attendanceAddMember(
        memberID: widget.member.memberID!,
        spaceID: widget.spaceID,
        date: widget.date,
        isCustom: widget.member.isCustom,
      );
      Get.back();
      _isUpdatingAttendance.trigger(false);
    } on FirebaseException catch (e) {
      print(e);
      _isUpdatingAttendance.trigger(true);
    }
  }

  // When the switch is true
  Future<void> _onRemoveAttendance() async {
    try {
      _isUpdatingAttendance.trigger(true);
      await _controller.attendanceRemoveMember(
        memberID: widget.member.memberID!,
        spaceID: widget.spaceID,
        date: widget.date,
        isCustom: widget.member.isCustom,
      );
      Get.back();
      _isUpdatingAttendance.trigger(false);
    } on FirebaseException catch (e) {
      print(e);
      _isUpdatingAttendance.trigger(true);
    }
  }

  /* <---- State -----> */
  @override
  void initState() {
    super.initState();
    _isToday = DateUtil.compareDays(
      date1: DateTime.now(),
      date2: widget.date,
    );
  }

  @override
  void dispose() {
    _attended.close();
    _isUpdatingAttendance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        AppDefaults.padding,
      ),
      child: Column(
        children: [
          Text(
            DateFormat.yMMMEd().format(widget.date),
            style: AppText.caption,
          ),
          Obx(
            () => SwitchListTile(
              value: _attended.value,
              onChanged: (v) {
                _attended.value = !_attended.value;
              },
              title: Text(
                _attended.isTrue
                    ? _isToday == false
                        ? 'Attended'
                        : 'Today'
                    : 'Unattended',
              ),
            ),
          ),
          AppSizes.hGap20,
          Obx(
            () => AppButton(
              label: _isToday ? 'Update Today' : 'Update',
              isLoading: _isUpdatingAttendance.value,
              onTap: () {
                if (_attended.isTrue) {
                  _onAttendance();
                } else {
                  _onRemoveAttendance();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
