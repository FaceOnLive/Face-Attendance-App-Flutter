import '../../../controllers/members/member_controller.dart';
import '../../dialogs/date_attend_dialog.dart';
import '../../widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MemberAttendanceEditScreen extends StatefulWidget {
  const MemberAttendanceEditScreen({
    Key? key,
    required this.memberID,
    required this.spaceID,
    required this.unattendedDates,
  }) : super(key: key);

  final String memberID;
  final String spaceID;
  final List<DateTime> unattendedDates;

  @override
  _MemberAttendanceEditScreenState createState() =>
      _MemberAttendanceEditScreenState();
}

class _MemberAttendanceEditScreenState
    extends State<MemberAttendanceEditScreen> {
  /* <---- Dependency -----> */
  MembersController _controller = Get.find();

  /// Keep Track of selected date
  RxList<DateTime> _selectedDate = RxList<DateTime>();

  // When a checkbox is tapped on list
  _onCheckBoxTapped(DateTime date) {
    if (_selectedDate.contains(date)) {
      _selectedDate.remove(date);
    } else {
      _selectedDate.add(date);
    }
  }

  /// Progress
  RxBool _addingAttendance = false.obs;

  /// On Attendance add
  Future<void> _onAttendanceAdd() async {
    bool _confirmDelete = await Get.dialog(
      DeleteAttendDialog(),
    );
    if (_confirmDelete) {
      _addingAttendance.trigger(true);
      await _controller.attendanceAddMultiple(
          memberID: widget.memberID,
          spaceID: widget.spaceID,
          dates: _selectedDate);
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
        title: Text('Unattended Dates'),
      ),
      body: Container(
        child: Obx(
          () => Column(
            children: [
              widget.unattendedDates.length > 0
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
                              icon: Icon(Icons.delete),
                              onPressed: () {},
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text('No Unattended Dates Found'),
                      ),
                    ),
              AppButton(
                label: 'Mark As Attended',
                onTap: _onAttendanceAdd,
                isLoading: _addingAttendance.value,
                disableBorderRadius: true,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(25),
                isButtonDisabled: _selectedDate.length > 0 ? false : true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
