import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/member.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../03_attendance/views/dialogs/date_attend_dialog.dart';
import '../controllers/member_controller.dart';

class MemberAttendanceEditScreen extends StatefulWidget {
  const MemberAttendanceEditScreen({
    Key? key,
    required this.member,
    required this.spaceID,
    required this.unattendedDates,
  }) : super(key: key);

  final Member member;
  final String spaceID;
  final List<DateTime> unattendedDates;

  @override
  _MemberAttendanceEditScreenState createState() =>
      _MemberAttendanceEditScreenState();
}

class _MemberAttendanceEditScreenState
    extends State<MemberAttendanceEditScreen> {
  /* <---- Dependency -----> */
  final MembersController _controller = Get.find();

  /// Keep Track of selected date
  final RxList<DateTime> _selectedDate = RxList<DateTime>();

  // When a checkbox is tapped on list
  _onCheckBoxTapped(DateTime date) {
    if (_selectedDate.contains(date)) {
      _selectedDate.remove(date);
    } else {
      _selectedDate.add(date);
    }
  }

  /// Progress
  final RxBool _addingAttendance = false.obs;

  /// On Attendance add
  Future<void> _onAttendanceAdd() async {
    bool _confirmDelete = await Get.dialog(
      const DeleteAttendDialog(),
    );
    if (_confirmDelete) {
      _addingAttendance.trigger(true);
      await _controller.attendanceAddMultiple(
        memberID: widget.member.memberID!,
        isCustom: widget.member.isCustom,
        spaceID: widget.spaceID,
        dates: _selectedDate,
      );
      _addingAttendance.trigger(false);
      Get.back();
      Get.back();
    }
  }

  @override
  void dispose() {
    _selectedDate.close();
    _addingAttendance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unattended Dates'),
      ),
      body: Obx(
        () => Column(
          children: [
            widget.unattendedDates.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: widget.unattendedDates.length,
                      itemBuilder: (context, index) {
                        DateTime _currentDate = widget.unattendedDates[index];
                        return ListTile(
                          onTap: () {
                            _onCheckBoxTapped(_currentDate);
                          },
                          leading: Checkbox(
                            onChanged: (v) {
                              _onCheckBoxTapped(_currentDate);
                            },
                            value: _selectedDate.contains(_currentDate),
                          ),
                          title: Text(
                            DateFormat.yMMMEd().format(_currentDate),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        );
                      },
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text('No Unattended Dates Found'),
                    ),
                  ),
            AppButton(
              label: 'Mark As Attended',
              onTap: _onAttendanceAdd,
              isLoading: _addingAttendance.value,
              disableBorderRadius: true,
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(25),
              isButtonDisabled: _selectedDate.isNotEmpty ? false : true,
            )
          ],
        ),
      ),
    );
  }
}
